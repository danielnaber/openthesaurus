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
import java.text.SimpleDateFormat
import java.util.zip.ZipEntry
import java.util.zip.ZipOutputStream

/**
 * Exports concepts to a plain text file.
 */
class ExportTextController extends BaseController {

  def beforeInterceptor = [action: this.&localHostAuth]
    
  def run = {

      File tmpFile = new File(grailsApplication.config.thesaurus.export.text.output + ".tmp")
      log.info("Writing plain text export to " + tmpFile)
      FileWriter fw = new FileWriter(tmpFile)
      
      String licenseText = message(code:'text.export.license')
      SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm")
      String date = sdf.format(new Date())
      fw.write(licenseText.replaceAll("__DATE__", date))
      fw.write("\n")
      
      List synsets = Synset.findAllByIsVisible(true)
      log.info("Exporting " + synsets.size() + " synsets")
      int count = 0
      for (synset in synsets) {
        int i = 0
        if (synset.terms.size() <= 1) {
          // not interesting, as these offer no synonyms
          continue
        }
        for (term in synset.terms) {
          if (term.level) {
            fw.write(term.word + " (" + term.level + ")")
          } else {
            fw.write(term.word)
          }
          if (i < synset.terms.size() - 1) {
            fw.write(";")
          }
          i++
        }
        fw.write("\n")
        if (count % 5000 == 0) {
          log.info("Text exporting synset #${count}")
        }
        count++
      }
      
      fw.close()
      
      File tmpZipFile = new File(grailsApplication.config.thesaurus.export.text.output + ".tmp.zip")
      createZip(tmpFile, tmpZipFile)
      
      File finalFile = new File(grailsApplication.config.thesaurus.export.text.output)
      if (finalFile.exists()) {
        boolean deleted = finalFile.delete()
        if (!deleted) {
          throw new Exception("Could not delete: " + finalFile)
        }
      }
      tmpZipFile.renameTo(finalFile)
      
      String msg = "Text export finished (count: ${count})"
      render msg
      log.info(msg)
  }
    
  private createZip(File data, File targetZip) throws IOException {
    FileOutputStream fos = new FileOutputStream(targetZip)
    ZipOutputStream zos = new ZipOutputStream(fos)
    
    zos.putNextEntry(new ZipEntry("openthesaurus.txt"))
    StringTools.writeToStream(data, zos)
    
    zos.putNextEntry(new ZipEntry("LICENSE.txt"))
    StringTools.writeToStream(new File(grailsApplication.config.thesaurus.export.license), zos)
    
    zos.close()
    fos.close()
  }
  
}
