/**
 * vthesaurus - web-based thesaurus management tool
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

import com.vionto.vithesaurus.*
import java.sql.Connection
import java.sql.DriverManager
import java.sql.ResultSet
import java.sql.PreparedStatement

class ImportController extends BaseController {
    
   //
   // FIXME: admin only
   //
   // def beforeInterceptor = [action: this.&adminAuth]
 
   // TODO:
   // -import users (encrypt password)
   // -test: keep lang. level (old: uses -> new: TermLevel)
   // -keep original ID
   // -antonyme
   // -oberbegriffe
   // -lookup-version des terms (nur wenn anders als term?)?

    private final String SUPER_NAME = "more generic synset"
    private final String SUPER_NAME_REVERSE = "more specific synset"
    private final String SUPER_VERB = "is a sub concept of"

    def index = {
        []
    }
    
    def run = {
        String dburl = params.dbUrl
        String dbuser = params.dbUsername
        String dbpassword = params.dbPassword
        Class.forName(params.dbClass)
        Connection conn = DriverManager.getConnection(dburl, dbuser, dbpassword)

        // TODO!?
        //cleanup(Category.findAll())
        //new Category("other").save()
        // TODO: needs to be cleaned up every time manually, why? 
        cleanup(TermLevel.findAll())
        
        cleanup(CategoryLink.findAll())
        cleanup(Term.findAll())
        cleanup(Synset.findAll())
        //return

        LinkType superLinkType = LinkType.findByLinkName(SUPER_NAME)
        if (!superLinkType) {
          superLinkType = new LinkType(linkName: SUPER_NAME,
              otherDirectionLinkName: SUPER_NAME_REVERSE, verbName: SUPER_VERB)
          render "Creating link type: $superLinkType"
          boolean saved = superLinkType.save()
          if (!saved) {
            throw new Exception("Could not create link type: $superLinkType")
          }
        }
        assert(superLinkType)
      	
        //
        // import categories
        //
        String sql = "SELECT id, subject FROM subjects"
        PreparedStatement ps = conn.prepareStatement(sql)
        ResultSet rs = ps.executeQuery()
        Map oldSubjectIdToCategory = new HashMap()
        while (rs.next()) {
          String catName = convert(rs.getString("subject"))
          Category cat = new Category(catName)
          render "Adding category $cat<br>"
          oldSubjectIdToCategory.put(rs.getInt("id"), cat)
          boolean saved = cat.save()
          if (!saved) {
            throw new Exception("Could not save category: $cat - $cat.errors")
          }
        }

        //
        // import term levels ("colloquial" etc)
        //
        sql = "SELECT id, name, shortname FROM uses"
        ps = conn.prepareStatement(sql)
        rs = ps.executeQuery()
        Map oldUseIdToTermLevel = new HashMap()
        int savedCount = 0
        while (rs.next()) {
          String useName = convert(rs.getString("name"))
          String shortUseName = convert(rs.getString("shortname"))	//FIXME: use this!
          TermLevel termLevel = new TermLevel(levelName: useName)
          render "Adding TermLevel $termLevel<br>"
          oldUseIdToTermLevel.put(rs.getInt("id"), termLevel)
          boolean saved = termLevel.save()
          if (!saved) {
            throw new Exception("Could not save termLevel: $termLevel - $termLevel.errors")
          }
        }

        //
        // import terms and synsets
        //
        sql = "SELECT id, subject_id, super_id FROM meanings WHERE hidden = 0"
        ps = conn.prepareStatement(sql)
        rs = ps.executeQuery()
        int count = 0
        
        Language german = Language.findByShortForm("de")
        assert(german)
        Category otherCategory = Category.findByCategoryName("other")
        assert(otherCategory)
        Section otherSection = Section.findBySectionName("other")
        assert(otherSection)
        
        while (rs.next()) {
          sql = "SELECT word, use_id FROM words, word_meanings WHERE meaning_id = ? AND words.id = word_meanings.word_id"
          PreparedStatement ps2 = conn.prepareStatement(sql)
          ps2.setInt(1, rs.getInt("id"))
          // TODO: another query for uses...
          ResultSet rs2 = ps2.executeQuery()
          Synset synset = new Synset()
          CategoryLink categoryLink
          if (rs.getInt("subject_id")) {
            Category cat = oldSubjectIdToCategory.get(rs.getInt("subject_id"))
            categoryLink = new CategoryLink(synset, cat)
            synset.preferredCategory = cat
          } else {
            categoryLink = new CategoryLink(synset, otherCategory)
            synset.preferredCategory = otherCategory
          }
          
          /* FIXME: in a second run, add super links:
          if (rs.getInt("super_id")) {
            SynsetLink link = new SynsetLink(from, to, superLinkType)
            synset.addSynsetLinks()
          }
          */
          
          synset.addCategoryLink(categoryLink)
          synset.section = otherSection
          int termCount = 0
          while (rs2.next()) {
            //FIXME: how to keep existing synset id?
            String term = convert(rs2.getString("word"))
            Term t = new Term(term, german, synset)
            if (rs2.getInt("use_id")) {
              TermLevel termLevel = oldUseIdToTermLevel.get(rs2.getInt("use_id"))
              assert(termLevel)
              t.level = termLevel
            }
            synset.addToTerms(t)
            termCount++
          }
          synset.isVisible = 1
          boolean saved = synset.save()
          if (!saved) {
            // TODO: throw exception instead
            render "NOT SAVED! $synset: ${synset.errors}<br>"
            log.warn("XXX $synset")
          } else {
            render "saved: $synset"
            savedCount++
          }
          render "<br>\n"
          count++
          //FIXME
          /*if (count > 3000) {
            break
          }*/
        }
        conn.close()
        render "- done ($savedCount) -"
    }

    /**
     * Fixes the broken MySQL encoding.
     */
    private String convert(String s) {
      // oh my, the encoding returned by MySQL is totally broken (also
      // depends on the version of the MySQL driver used):
      return new String(s.getBytes("latin1"), "utf-8").replaceAll("�\\?", "ß")
      //return s
    }
    
 
    private void cleanup(List l) {
      for (item in l) {
        //render "delete $item<br>"
        item.delete()
      }
    }

}