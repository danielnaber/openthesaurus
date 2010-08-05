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
import java.sql.Connection
import java.sql.ResultSet
import java.sql.Statement

/**
 * Exports concepts to a plain text file, packed as a ZIP.
 */
class ExportTextController extends BaseController {

  def beforeInterceptor = [action: this.&localHostAuth]
    
  def dataSource       // will be injected
  def sessionFactory   // will be injected
  
  def run = {

      File tmpFile = new File(grailsApplication.config.thesaurus.export.text.output + ".tmp")
      log.info("Writing plain text export to " + tmpFile)

      OutputStream fout= new FileOutputStream(tmpFile);
      OutputStream bout= new BufferedOutputStream(fout);
      OutputStreamWriter out = new OutputStreamWriter(bout, "utf-8");

      String licenseText = message(code:'text.export.license')
      SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm")
      String date = sdf.format(new Date())
      out.write(licenseText.replaceAll("__DATE__", date))
      out.write("\n")
  
      Connection conn = dataSource.getConnection()
      Statement st = conn.createStatement()

      // simple but requires too much memory:
      //List synsets = Synset.findAllByIsVisible(true)

      ResultSet rs = st.executeQuery("""SELECT id FROM synset WHERE synset.is_visible = 1""")
      def hibSession = sessionFactory.getCurrentSession()
      
      int count = 0
      while (rs.next()) {
        Synset synset = Synset.get(rs.getLong("id"))
        count++
        if (synset.terms.size() <= 1) {
          // not interesting, as these offer no synonyms
          continue
        }
        int i = 0
        for (term in synset.terms) {
          if (term.level) {
            out.write(term.word + " (" + term.level + ")")
          } else {
            out.write(term.word)
          }
          if (i < synset.terms.size() - 1) {
            out.write(";")
          }
          i++
        }
        out.write("\n")
        if (count % 1000 == 0) {
          log.info("Text exporting synset #${count}")
          hibSession.clear()	// required to avoid OOM
        }
      }
      
      rs.close()
      st.close()
      out.close();
      bout.close()
      fout.close();
      conn.close()
      
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
