import java.io.BufferedWriter
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

import com.vionto.vithesaurus.*
import com.vionto.vithesaurus.tools.StringTools
import java.sql.Connection
import java.sql.ResultSet
import java.sql.Statement
import java.text.SimpleDateFormat
import java.util.zip.ZipEntry
import java.util.zip.ZipOutputStream
import org.apache.commons.io.FileUtils

/**
 * Exports concepts to an OpenOffice.org OXT file.
 */
class ExportOxtController extends BaseController {

  def beforeInterceptor = [action: this.&localHostAuth]

  def dataSource       // will be injected
  def sessionFactory   // will be injected

  String encoding = "UTF-8"

  private static final String SUPER_TERM = "Oberbegriff"
  
  def run = {

      File tmpFile = File.createTempFile("openthesaurus.dat", "")
      log.info("Writing data export for OXT to " + tmpFile)
      FileWriter fw = new FileWriter(tmpFile)
      BufferedWriter bw = new BufferedWriter(fw)

      File tmpFileIdx = File.createTempFile("openthesaurus.idx", "")
      log.info("Writing index export for OXT to " + tmpFileIdx)
      FileWriter fwIdx = new FileWriter(tmpFileIdx)
      BufferedWriter bwIdx = new BufferedWriter(fwIdx)
      
      int indexPos = 0
      indexPos = dataWrite(encoding + "\n", bw, indexPos)
      bwIdx.write(encoding + "\n")
      
      Connection conn = dataSource.getConnection()
      Statement st = conn.createStatement()

      def hibSession = sessionFactory.getCurrentSession()
      
      log.info("Counting terms...")
      ResultSet rs = st.executeQuery("""SELECT count(DISTINCT word) AS count FROM synset, term WHERE 
          synset.id = term.synset_id AND synset.is_visible = 1 ORDER BY word""")
      rs.next()
      int termCount = rs.getInt("count")
      bwIdx.write(termCount + "\n")
      log.info("Found ${termCount} terms...")
      rs.close()

      log.info("Collecting terms...")
      rs = st.executeQuery("""SELECT DISTINCT word FROM synset, term WHERE
          synset.id = term.synset_id AND synset.is_visible = 1 ORDER BY word""")

      int count = 0
      String variation = null
      if (params.variation == 'ch') {
        variation = 'ch'
        log.info("Using variation ${variation}")
      }

      int limit = 0
      if (params.limit) {
        limit = Integer.parseInt(params.limit)
      }

      List sortedWords = []
      Map wordToOrigWord = new HashMap()
      SynsetController ctrl = new SynsetController()

      while (rs.next()) {
        String word = rs.getString("word")
        word = word.replaceAll("\\(.*?\\)", "").trim()
        sortedWords.add(word)
        wordToOrigWord.put(word, rs.getString("word"))
      }

      Collections.sort(sortedWords, [
              compare: {String o1, String o2 -> o1.compareToIgnoreCase(o2)}
      ] as Comparator)   // sorts like Unix "sort" with LC_ALL=C

      for (word in sortedWords) {
        long t = System.currentTimeMillis()
        String origWord = wordToOrigWord.get(word)
        if (!origWord) {
          throw new Exception("'${word}' not found in map")
        }
        def result = ctrl.doDBSearch(origWord, null, null, null)
        if (limit > 0 && count > limit) {
          //useful for testing
          break
        }
        if (result.totalMatches == 0) {
          log.warn("No result for '${origWord}'")
        }
        if (count % 100 == 0) {
          log.info(count + ". results = " + result.totalMatches + ", " + (System.currentTimeMillis()-t) + "ms")
        }
        bwIdx.write(makeVariation(word.toLowerCase(), variation, true) + "|" + indexPos + "\n")
        indexPos = dataWrite(makeVariation(word.toLowerCase(), variation, true) + "|" + result.synsetList.size() + "\n", bw, indexPos)
        int lineCount = 0
        for (synset in result.synsetList) {
          List sortedTerms = synset.terms.sort()
          indexPos = dataWrite("-", bw, indexPos)
          // synonyms:
          for (sortedTerm in sortedTerms) {
            String wordWithLevel = makeVariation(sortedTerm.word, variation)
            if (sortedTerm.level) {
              wordWithLevel = "${wordWithLevel} (${sortedTerm.level.shortLevelName})"
            }
            indexPos = dataWrite("|" + wordWithLevel, bw, indexPos)
          }
          // super terms:
          for (link in synset.synsetLinks) {
            if (link.linkType.toString() == SUPER_TERM) {
              Synset superSynset = link.targetSynset
              List superSortedTerms = superSynset.terms.sort()
              for (superTerm in superSortedTerms) {
                String superWordWithLevel = makeVariation(superTerm.word, variation)
                if (superTerm.level) {
                  superWordWithLevel = "${superWordWithLevel} (${superTerm.level.shortLevelName})"
                }
                superWordWithLevel = "${superWordWithLevel} (${SUPER_TERM})"
                indexPos = dataWrite("|" + superWordWithLevel, bw, indexPos)
              }
            }
          }
          indexPos = dataWrite("\n", bw, indexPos)
          lineCount++
        }
        if (lineCount != result.synsetList.size()) {
          throw new RuntimeException("Problem exporting '${word}': ${lineCount} != ${result.totalMatches}")
        }
        count++
        if (count % 500 == 0) {
          log.info("Calling clear() at ${count}")
          hibSession.clear()	// required to avoid OOM
          //fast and incomplete export for testing:
          //if (count > 0) {
          //  break
          //}
        }
      }

      bw.close()
      fw.close()
      bwIdx.close()
      fwIdx.close()
      rs.close()
      st.close()
      conn.close()
      log.info("Export done")
      
      render "OK: " + grailsApplication.config.thesaurus.export.oxt.output
      
      createZip(tmpFile, tmpFileIdx, variation)
      tmpFile.delete()
      tmpFileIdx.delete()
  }

  private String makeVariation(String str, String variation, boolean normalize = false) {
    if (variation == 'ch') {
      str = str.replaceAll("ß", "ss")
    }
    if (normalize) {
      str = str.replaceAll("\\(.*?\\)", "").trim()
    }
    return str
  }

  private dataWrite(String str, BufferedWriter bw, int indexPos) {
    bw.write(str)
    return indexPos + str.getBytes(encoding).length
  }

  private createZip(File data, File index, String variation) throws IOException {
    String finalName
    if (variation == 'ch') {
      finalName = grailsApplication.config.thesaurus.export.oxt.outputCH
    } else if (variation == null) {
      finalName = grailsApplication.config.thesaurus.export.oxt.output
    } else {
      throw new Exception("Unknown variation '${variation}'")
    }
    File zipFile = new File(finalName + ".tmp")
    FileOutputStream fos = new FileOutputStream(zipFile)
    ZipOutputStream zos = new ZipOutputStream(fos)

    zos.putNextEntry(new ZipEntry(grailsApplication.config.thesaurus.export.idxFile))
    StringTools.writeToStream(index, zos)

    zos.putNextEntry(new ZipEntry(grailsApplication.config.thesaurus.export.datFile))
    StringTools.writeToStream(data, zos)

    Date now = new Date()

    File readmeFile = new File(grailsApplication.config.thesaurus.export.readmeFile)
    zos.putNextEntry(new ZipEntry(readmeFile.getName()))
    File tempReadmeFile = File.createTempFile("openthesaurus-ooo-readme", ".txt")
    String readme = FileUtils.readFileToString(readmeFile)
    SimpleDateFormat sdfReadme = new SimpleDateFormat("yyyy-MM-dd HH:mm")
    readme = readme.replaceAll("__DATE__", sdfReadme.format(now))
    FileWriter fwReadme = new FileWriter(tempReadmeFile)
    fwReadme.write(readme)
    fwReadme.close()
    StringTools.writeToStream(tempReadmeFile, zos)
    tempReadmeFile.delete()

    // set today's date in description.xml:
    zos.putNextEntry(new ZipEntry("description.xml"))
    File tempDescFile = File.createTempFile("openthesaurus-ooo-description", ".xml")
    String descXml = FileUtils.readFileToString(new File(grailsApplication.config.thesaurus.export.descFile))
    SimpleDateFormat sdfDesc = new SimpleDateFormat("yyyy.MM.dd")
    descXml = descXml.replaceAll("__DATE__", sdfDesc.format(now))
    FileWriter fwDesc = new FileWriter(tempDescFile)
    fwDesc.write(descXml)
    fwDesc.close()
    StringTools.writeToStream(tempDescFile, zos)
    tempDescFile.delete()

    zos.putNextEntry(new ZipEntry("Dictionaries.xcu"))
    StringTools.writeToStream(new File(grailsApplication.config.thesaurus.export.dictFile), zos)
    zos.putNextEntry(new ZipEntry("META-INF/manifest.xml"))
    StringTools.writeToStream(new File(grailsApplication.config.thesaurus.export.manifestFile), zos)
    zos.close()
    fos.close()
    // this is a publically visible file so make the new version visible atomically:
    zipFile.renameTo(new File(finalName))
  }

}
