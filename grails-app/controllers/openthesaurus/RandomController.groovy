/**
 * OpenThesaurus - web-based thesaurus management tool
 * Copyright (C) 2011 Daniel Naber, www.danielnaber.de
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

package openthesaurus

import java.sql.Connection
import java.sql.PreparedStatement
import java.sql.ResultSet
import com.vionto.vithesaurus.Synset

class RandomController extends BaseController {
    
    def dataSource
    def randomWordService
    
    def synsets() {
        Connection conn
        PreparedStatement ps
        ResultSet resultSet
        List synsets = []
        try {
          conn = dataSource.getConnection()
          String sql = "SELECT id FROM synset WHERE is_visible = 1 ORDER BY RAND() LIMIT 10"
          ps = conn.prepareStatement(sql)
          resultSet = ps.executeQuery()
          while (resultSet.next()) {
              synsets.add(Synset.get(resultSet.getInt("id")))
          }
        } finally {
          if (resultSet != null) {
            resultSet.close()
          }
          if (ps != null) {
            ps.close()
          }
          if (conn != null) {
            conn.close()
          }
        }
        [synsets: synsets]
    }
    
    def words() {
        int wordCount = params.count ? Integer.parseInt(params.count) : 1
        int maxWords = 100
        if (wordCount > maxWords) {
          throw new Exception("Too many words requested: ${wordCount}, maximum is ${maxWords}")
        }
        def randomWords = randomWordService.getRandomWords(wordCount)
        render(contentType:"text/json", encoding:"utf-8") {
          metaData apiVersion: "0.2",
                   warning: "ACHTUNG: Bitte vor ernsthafter Nutzung feedback@openthesaurus.de kontaktieren, um bei API-Änderungen informiert zu werden",
                   copyright: grailsApplication.config.thesaurus.apiCopyright,
                   license: grailsApplication.config.thesaurus.apiLicense,
                   source: grailsApplication.config.thesaurus.apiSource,
                   date: new Date().toString(),
                   wordCount: randomWordService.getRandomWordsCount()
          result words: randomWords
      }
    }
    
}
