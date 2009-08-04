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

import com.vionto.vithesaurus.*
import java.text.SimpleDateFormat
import java.util.zip.ZipEntryimport java.util.zip.ZipOutputStream
/**
 * Exports concepts to an OpenOffice.org OXT file.
 */
class ExportOxtController extends BaseController {

  def beforeInterceptor = [action: this.&localHostAuth]
  String encoding = "UTF-8"
  def run = {
      File tmpFile = File.createTempFile("openthesaurus.dat", "")
      log.info("Writing data export for OXT to " + tmpFile)
      FileWriter fw = new FileWriter(tmpFile)
      BufferedWriter bw = new BufferedWriter(fw);

      File tmpFileIdx = File.createTempFile("openthesaurus.idx", "")
      log.info("Writing index export for OXT to " + tmpFileIdx)
      FileWriter fwIdx = new FileWriter(tmpFileIdx)
      BufferedWriter bwIdx = new BufferedWriter(fwIdx);
      
      int indexPos = 0      indexPos = dataWrite(encoding + "\n", bw, indexPos)
      bwIdx.write(encoding + "\n")      
      def termList = Term.withCriteria {
        synset {
            eq('isVisible', true)
        }
        order("word", "asc")      }      bwIdx.write(termList.size() + "\n")      Set allWordsSet = new HashSet()	// to avoid dupes      List allWords = []      for (term in termList) {        String normTerm = term.word        if (term.normalizedWord) {          normTerm = term.normalizedWord        }        // avoid duplicates here:        if (!allWordsSet.contains(normTerm)) {          allWords.add(normTerm)        }        allWordsSet.add(normTerm)      }      Collections.sort(allWords, String.CASE_INSENSITIVE_ORDER)                
      log.info("Exporting " + termList.size() + " terms")
      int count = 0
      SynsetController ctrl = new SynsetController()
      for (word in allWords) {        long t = System.currentTimeMillis()        def result = ctrl.doDBSearch(word, null, null, null);        if (count % 100 == 0) {          log.info(count + ". results = " + result.totalMatches + ", " + (System.currentTimeMillis()-t) + "ms")        }
        bwIdx.write(word.toLowerCase() + "|" + indexPos + "\n")        indexPos = dataWrite(word.toLowerCase() + "|" + result.totalMatches + "\n", bw, indexPos)
        for (synset in result.synsetList) {
          List sortedTerms = synset.terms.sort()
          indexPos = dataWrite("-", bw, indexPos);
          for (sortedTerm in sortedTerms) {
            if (sortedTerm.word != word) {
              indexPos = dataWrite("|" + sortedTerm.word, bw, indexPos);            }
          }
          indexPos = dataWrite("\n", bw, indexPos);        }
        //if (count > 1000) {
        //  break
        //}
        count++
      }
      
      bw.close()
      fw.close()
      bwIdx.close()
      fwIdx.close()
      log.info("Export done")      
      render "OK: " + grailsApplication.config.thesaurus.export.oxt.output
            createZip(tmpFile, tmpFileIdx)
      tmpFile.delete()      tmpFileIdx.delete()  }
  
  private dataWrite(String str, BufferedWriter bw, int indexPos) {    bw.write(str)
    return indexPos + str.getBytes(encoding).length
  }
  private createZip(File data, File index) throws IOException {    File zipFile = new File(grailsApplication.config.thesaurus.export.oxt.output)    FileOutputStream fos = new FileOutputStream(zipFile)    ZipOutputStream zos = new ZipOutputStream(fos)    zos.putNextEntry(new ZipEntry(grailsApplication.config.thesaurus.export.idxFile))    writeToStream(index, zos)    zos.putNextEntry(new ZipEntry(grailsApplication.config.thesaurus.export.datFile))    writeToStream(data, zos)    zos.putNextEntry(new ZipEntry("description.xml"))    writeToStream(new File(grailsApplication.config.thesaurus.export.descFile), zos)    zos.putNextEntry(new ZipEntry("Dictionaries.xcu"))    writeToStream(new File(grailsApplication.config.thesaurus.export.dictFile), zos)    zos.putNextEntry(new ZipEntry("META-INF/manifest.xml"))    writeToStream(new File(grailsApplication.config.thesaurus.export.manifestFile), zos)    zos.close()    fos.close()  }  private void writeToStream(File file, OutputStream out) throws IOException {    log.info("Writing " + file.getAbsolutePath() + " to stream")    FileInputStream fis = new FileInputStream(file);    BufferedInputStream bis = new BufferedInputStream(fis);    final byte[] chars = new byte[4096];    int readbytes = 0;    while (readbytes >= 0) {      readbytes = bis.read(chars, 0, 4096);      if (readbytes <= 0) {        break;      }      out.write(chars, 0, readbytes);    }    bis.close();    fis.close();  }
}
