/**
 * vithesaurus - web-based thesaurus management tool
 * Copyright (C) 2009 vionto GmbH, www.vionto.com
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as
 * published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */ 

import org.xml.sax.*;
import org.xml.sax.helpers.*;
import org.apache.xml.serialize.*;
import com.vionto.vithesaurus.*
import org.hibernate.SessionFactory
import java.sql.Connection
import java.sql.ResultSet
import java.sql.Statement

/**
 * Exports concepts to an XML file.
 */
class ExportController extends BaseController {

  def beforeInterceptor = [action: this.&auth]
    
  def dataSource       // will be injected
  SessionFactory sessionFactory       // will be injected automatically

  /**
   * Short terms will be removed (can also affect preferred term),
   */
  final static int MIN_TERM_LENGTH = 0
    
  final static String NAMESPACE = 
      "http://www.vionto.com/conceptlist"
      
  final static AttributesImpl emptyAtts = new AttributesImpl()

  final static int FLUSH_LIMIT = 1000

  private long lastMeasureTime
  private String conceptIdPrefix = ""

  /**
   * When called with POST method and a path parameter, exports concepts to an
   * XML file, using the path parameter as a filename. When called with
   * method GET, shows a form to specify the output path.
   */
  def run = {
      if (request.method == 'GET') {
          []
          return
      }
      render "<html>"
      if (!params.path) {
          throw new IllegalArgumentException("No path set")
      }
      if (params.prefix) {
          conceptIdPrefix = params.prefix
      }
      String exportFile = params.path
      Section section = null
      if (params.section.id) {
          section = Section.get(params.section.id)
      }
      FileOutputStream fos = new FileOutputStream(exportFile)
      OutputFormat of = new OutputFormat("XML", "utf-8", true)
      of.setIndent(1)
      of.setIndenting(true)
      log.info("starting export to ${exportFile}")

      XMLSerializer serializer = new XMLSerializer(fos, of)
      ContentHandler hd = serializer.asContentHandler()
      hd.startDocument()
      
      final Category UNKNOWN_CATEGORY = Category.findByCategoryName("Unknown")
      if (!UNKNOWN_CATEGORY) {
          throw new IllegalArgumentException("No 'Unknown' category found")
      }

      AttributesImpl conceptListAtts = new AttributesImpl()
      conceptListAtts.addAttribute("", "", "xmlns", "CDATA",
              NAMESPACE)
      AttributesImpl categoryAtts = new AttributesImpl()
      AttributesImpl termsetAtts = new AttributesImpl()
      hd.startElement("", "" , "ConceptList", conceptListAtts)

      //
      // export categories as mappable = false
      //
      
      List categories = Category.list()
      for (category in categories) {
          if (category.isOriginal) {
              continue
          }
          if (!category.uri) {
              log.info("ignoring category with empty uri: $category")
              continue
          }
          categoryAtts.clear()
          categoryAtts.addAttribute("", "", "id", "CDATA", category.uri)
          categoryAtts.addAttribute("", "", "mappable", "CDATA", "false")
          hd.startElement("", "" , "Concept", categoryAtts)
          String uri = category.uri
          if (uri) {
              write("SourceURI", uri, hd)
          }
          termsetAtts.clear()
          // FIXME: for now, all categories are in English:
          termsetAtts.addAttribute("", "", "locale", "CDATA", "en")
          hd.startElement("", "" , "TermSet", termsetAtts)
          write("PreferredTerm", category.categoryName, hd)
          hd.endElement("", "" , "TermSet")
          hd.endElement("", "" , "Concept")
      }

      //
      // Export synsets. This is *much* faster than the old version that
      // uses Hibernate.
      //

      Connection conn = dataSource.getConnection()
      
      // load the ID -> Term mapping only once so we don't need
      // an additional query per synset (makes export *much* faster):
      Map idToTermMap = loadTermMapping(conn, section)

      Statement st = conn.createStatement()
      String sql = """SELECT
          word, synset.id AS synset_id, synset.synset_preferred_term,
          synset.originaluri, language.short_form,
          category_link.category_id AS category_id,
          preferred_term_link.term_id AS pref_term_id
          FROM term, synset, preferred_term_link, language, category_link
          WHERE
          synset.preferred_category_id <> ${UNKNOWN_CATEGORY.id} AND
          synset.is_visible = 1 AND
          term.synset_id = synset.id AND
          preferred_term_link.synset_id = synset.id AND
          term.language_id = language.id AND
          category_link.synset_id = synset.id"""
      if (section) {
          sql += """ AND synset.section_id = ${section.id}"""
      }
      sql += """ ORDER BY synset_id"""
      
      long time = System.currentTimeMillis()
      lastMeasureTime = System.currentTimeMillis()

      log.info("Running sql: $sql")
      ResultSet rs = st.executeQuery(sql)
      
      int synsetCounter = 0
      int prevSynsetID = -1
      Set catSet = new HashSet()
      ExportSimpleSynset synset = new ExportSimpleSynset()
      
      // building our own map is faster than using a hibernate lookup each time:
      List langs = Language.list()
      Map shortForm2Lang = new HashMap()
      for (Language lang : langs) {
          shortForm2Lang.put(lang.shortForm, lang)
      }
      while (rs.next()) {
          int synsetID = rs.getInt("synset_id")
          Language lang = shortForm2Lang.get(rs.getString("short_form"))
          assert(lang)
          if (prevSynsetID != synsetID) {
              writeSynset(synset, hd, synsetCounter, time)
              synsetCounter++
              catSet.clear()
              synset = new ExportSimpleSynset()
              synset.id = synsetID
              synset.originalURI = rs.getString("originaluri")
              String prefTermStr = rs.getString("synset_preferred_term")
          }
          int prefTermID = rs.getInt("pref_term_id")
          SimpleTerm prefTerm = idToTermMap.get(prefTermID)
          if (!prefTerm) {
              throw new RuntimeException("prefTermID $prefTermID not found in map")
          }
          synset.setPreferredTerm(prefTerm.langCode, prefTerm.word)
          if (!synset.containsWord(rs.getString("word"))) {
              synset.addTerm(new SimpleTerm(rs.getString("word"),
                      lang.shortForm))
          }
          Category category = Category.get(rs.getInt("category_id"))
          String categoryUri = null
          if (category.categoryType) {
              categoryUri = category.categoryType.uri
          } else {
              categoryUri = category.uri
          }
          // avoid category duplicates caused by our SQL query:
          if (categoryUri != null && !catSet.contains(categoryUri)) {
              synset.addCategoryUri(categoryUri)
              catSet.add(categoryUri)
          }
          /*if (synsetCounter > 5000) {
              break
          }*/
          prevSynsetID = synsetID
      }
      
      // don't skip the very last synset:
      writeSynset(synset, hd, synsetCounter, time)
      
      hd.endElement("", "" , "ConceptList")
      hd.endDocument()
      fos.close()

      float totalTime = (System.currentTimeMillis() - time) / 1000.0
      String msg = "done, exported ${synsetCounter} synsets to " +
          "${exportFile.encodeAsHTML()}, time=${totalTime}s"
      render "---${msg}<br/>"
      log.info(msg)
      render "</html>"
  }

  /**
   * Load the complete mapping: Term-ID -> Term from the database.
   */
  private Map loadTermMapping(Connection conn, Section section) {
      Map termMap = new HashMap()
      Statement st = conn.createStatement()
      String sql = """SELECT term.id, short_form, word
          FROM term, language, synset 
          WHERE
          synset.is_visible = 1 AND
          language.id = term.language_id AND
          term.synset_id = synset.id"""
      if (section) {
          /* example iof how to export more than one section (also see above):
          Section otherSection = Section.findBySectionName("otherSectionName")
          assert(otherSection)
          sql += """ AND (synset.section_id = ${section.id} OR
                  synset.section_id = ${otherSection.id})"""
          */
          sql += " AND synset.section_id = ${section.id}"
      }          
      log.info("Loading term mapping with SQL: $sql")
      ResultSet rs = st.executeQuery(sql)
      int counter = 0
      while (rs.next()) {
          termMap.put(rs.getInt("id"), new SimpleTerm(rs.getString("word"),
                  rs.getString("short_form")))
          if (counter % 50000 == 0) {
              log.info("Loading term $counter")
          }
          counter++
      }
      log.info("Done loading mapping with ${termMap.size()} entries")
      return termMap
  }
  
  /**
   * Write the given synset to an XML handler.
   */
  void writeSynset(ExportSimpleSynset synset, ContentHandler hd, int synsetCounter,
          long time) {
      AttributesImpl synAtts = new AttributesImpl()
      synAtts.addAttribute("", "", "id", "CDATA", conceptIdPrefix + synset.id)
      hd.startElement("", "" , "Concept", synAtts)
      // use a set so duplicates (caused by two categories mapping to the
      // same simplified category) are removed automatically:
      Set categoryInfos = []
      for (categoryUri in synset.catUris) {
          categoryInfos.add(categoryUri)
      }
      for (categoryInfo in categoryInfos.sort()) {
          write("CategoryTypeURI", categoryInfo, hd)
      }
      write("SourceURI", synset.originalURI ? synset.originalURI : "", hd)
      // iterate over a synset's languages
      for (langCode in synset.preferredTermLinks.keySet()) {
          String prefTermWord = synset.preferredTermLinks.get(langCode)
          AttributesImpl termsetAtts = new AttributesImpl()
          termsetAtts.addAttribute("", "", "locale", "CDATA", langCode)
          hd.startElement("", "" , "TermSet", termsetAtts)
          // TODO: use a different term if pref. must be ignored
          if (prefTermWord.length() >= MIN_TERM_LENGTH) {
              // allow only one upper/lowercase variant of a word per synset:
              Set allWordsLowercase = new HashSet()
              write("PreferredTerm", prefTermWord, hd)
              allWordsLowercase.add(prefTermWord.toLowerCase())
              // iterate over all terms
              for (term in synset.terms.sort()) {
                  // for this TermSet, only use the current language
                  if (term.langCode != langCode) {
                      continue
                  }
                  if (term.word == prefTermWord) {
                      continue
                  }
                  if (prefTermWord.length() < MIN_TERM_LENGTH) {
                      continue
                  }
                  String str = term.word
                  if (allWordsLowercase.contains(str.toLowerCase())) {
                      continue
                  }
                  allWordsLowercase.add(str.toLowerCase())
                  hd.startElement("", "" , "OtherTerm", emptyAtts)
                  hd.characters(str.toCharArray(), 0, str.length())
                  hd.endElement("", "" , "OtherTerm")
              }
          } else {
              log.info("Ignoring term, too short: ${prefTermWord}")
          }
          hd.endElement("", "" , "TermSet")
      }
      hd.endElement("", "" , "Concept")
      
      if (synsetCounter % FLUSH_LIMIT == 0) {
          float synPerSec = synsetCounter /
              ((System.currentTimeMillis()-time)/1000.0f)
          float currentSynPerSec = FLUSH_LIMIT /
              ((System.currentTimeMillis()-lastMeasureTime)/1000.0f)
          log.info("exported ${synsetCounter} synsets, in ${synPerSec} " + 
                  "synsets/sec (${currentSynPerSec})")
          lastMeasureTime = System.currentTimeMillis()
      }
  }
  
  /**
   * Write an XML element with the given content.
   */
  void write(String elemName, String content, ContentHandler hd) {
      hd.startElement("", "" , elemName, emptyAtts)
      hd.characters(content.toCharArray(), 0, content.length())
      hd.endElement("", "" , elemName)
  }
  
}
