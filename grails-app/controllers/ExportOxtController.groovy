import java.io.BufferedWriter/**
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

import com.vionto.vithesaurus.*import com.vionto.vithesaurus.tools.StringTools
import java.sql.Connectionimport java.sql.ResultSetimport java.sql.Statementimport java.text.SimpleDateFormat
import java.util.zip.ZipEntryimport java.util.zip.ZipOutputStream
/**
 * Exports concepts to an OpenOffice.org OXT file.
 */
class ExportOxtController extends BaseController {

  def beforeInterceptor = [action: this.&localHostAuth]
  def dataSource       // will be injected  def sessionFactory   // will be injected  String encoding = "UTF-8"  
  def run = {
      File tmpFile = File.createTempFile("openthesaurus.dat", "")
      log.info("Writing data export for OXT to " + tmpFile)
      FileWriter fw = new FileWriter(tmpFile)
      BufferedWriter bw = new BufferedWriter(fw)

      File tmpFileIdx = File.createTempFile("openthesaurus.idx", "")
      log.info("Writing index export for OXT to " + tmpFileIdx)
      FileWriter fwIdx = new FileWriter(tmpFileIdx)
      BufferedWriter bwIdx = new BufferedWriter(fwIdx)
      
      int indexPos = 0      indexPos = dataWrite(encoding + "\n", bw, indexPos)
      bwIdx.write(encoding + "\n")            Connection conn = dataSource.getConnection()      Statement st = conn.createStatement()      def hibSession = sessionFactory.getCurrentSession()            log.info("Counting terms...")      ResultSet rs = st.executeQuery("""SELECT count(DISTINCT word) AS count FROM synset, term WHERE           synset.id = term.synset_id AND synset.is_visible = 1 ORDER BY word""")      rs.next()      int termCount = rs.getInt("count")      bwIdx.write(termCount + "\n")      log.info("Found ${termCount} terms...")      rs.close()      log.info("Collecting terms...")      rs = st.executeQuery("""SELECT DISTINCT word FROM synset, term WHERE           synset.id = term.synset_id AND synset.is_visible = 1 ORDER BY word""")      int count = 0
      SynsetController ctrl = new SynsetController()      while (rs.next()) {        String word = rs.getString("word")
        long t = System.currentTimeMillis()        def result = ctrl.doDBSearch(word, null, null, null)        if (count % 100 == 0) {          log.info(count + ". results = " + result.totalMatches + ", " + (System.currentTimeMillis()-t) + "ms")        }
        bwIdx.write(word.toLowerCase() + "|" + indexPos + "\n")        indexPos = dataWrite(word.toLowerCase() + "|" + result.totalMatches + "\n", bw, indexPos)
        for (synset in result.synsetList) {
          List sortedTerms = synset.terms.sort()
          indexPos = dataWrite("-", bw, indexPos)
          for (sortedTerm in sortedTerms) {
            if (sortedTerm.word != word) {
              indexPos = dataWrite("|" + sortedTerm.word, bw, indexPos)            }
          }
          indexPos = dataWrite("\n", bw, indexPos)        }        count++
        if (count % 500 == 0) {          log.info("Calling clear() at ${count}")          hibSession.clear()	// required to avoid OOM        }      }
      bw.close()
      fw.close()
      bwIdx.close()
      fwIdx.close()      rs.close()      st.close()      conn.close()
      log.info("Export done")      
      render "OK: " + grailsApplication.config.thesaurus.export.oxt.output
            createZip(tmpFile, tmpFileIdx)
      tmpFile.delete()      tmpFileIdx.delete()  }
  
  private dataWrite(String str, BufferedWriter bw, int indexPos) {    bw.write(str)
    return indexPos + str.getBytes(encoding).length
  }
  private createZip(File data, File index) throws IOException {    String finalName = grailsApplication.config.thesaurus.export.oxt.output    File zipFile = new File(finalName + ".tmp")    FileOutputStream fos = new FileOutputStream(zipFile)    ZipOutputStream zos = new ZipOutputStream(fos)    zos.putNextEntry(new ZipEntry(grailsApplication.config.thesaurus.export.idxFile))    StringTools.writeToStream(index, zos)    zos.putNextEntry(new ZipEntry(grailsApplication.config.thesaurus.export.datFile))    StringTools.writeToStream(data, zos)    zos.putNextEntry(new ZipEntry("description.xml"))    StringTools.writeToStream(new File(grailsApplication.config.thesaurus.export.descFile), zos)    zos.putNextEntry(new ZipEntry("Dictionaries.xcu"))    StringTools.writeToStream(new File(grailsApplication.config.thesaurus.export.dictFile), zos)    zos.putNextEntry(new ZipEntry("META-INF/manifest.xml"))    StringTools.writeToStream(new File(grailsApplication.config.thesaurus.export.manifestFile), zos)    zos.close()    fos.close()    // this is a publically visible file so make the new version visible atomically:    zipFile.renameTo(new File(finalName))  }}
