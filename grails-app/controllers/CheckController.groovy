/**
 * OpenThesaurus - web-based thesaurus management tool
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
import java.sql.ResultSet
import java.sql.Statement

/**
 * Several checks for potential quality problems.
 */
class CheckController extends BaseController {

    def beforeInterceptor = [action: this.&auth]

    def dataSource       // will be injected

    /**
     * List all synsets that are not visible.
     */
    def listInvisibleSynsets = {
        int offset = params.offset ? Integer.parseInt(params.offset) : 0
        // get the invisible synsets to display:
        def synsetList = Synset.withCriteria {
            eq('isVisible', false)
            if (params.filter) {
                terms {
                    ilike('word', params.filter)
                }
            }
            maxResults(10)
            firstResult(offset)
            order('id')
        }
        // get the number of invisible synsets:
        int totalMatches
        if (params.filter) {
            def synsetListComplete = Synset.withCriteria {
                eq('isVisible', false)
                terms {
                    ilike('word', params.filter)
                }
            }
            totalMatches = synsetListComplete.size()
        } else {
            totalMatches = Synset.countByIsVisible(false)
        }
        [ synsetList : synsetList, totalMatches : totalMatches ]
    }

    /**
     * List homonyms, i.e. words that appear in more than one synset.
     */
    def listHomonyms = {
        Connection conn = dataSource.getConnection()
        Statement st = conn.createStatement()
        int limit = params.limit ? Integer.parseInt(params.limit) : 250
        String sql = """SELECT word,
                count(word) AS counter
                FROM term, synset
                WHERE
                    synset.id = term.synset_id AND
                    synset.is_visible = 1
                GROUP BY word ORDER BY counter DESC LIMIT $limit"""
        ResultSet rs = st.executeQuery(sql)
        List homonyms = []
        List homonymCounts = []
        while (rs.next()) {
            int counter = rs.getInt("counter")
            if (counter <= 1) {
                break
            }
            if (params.ignoreCase) {
                homonyms.add(rs.getString("lower(word)"))
            } else {
                homonyms.add(rs.getString("word"))
            }
            homonymCounts.add(counter)
        }
        st.close()
        conn.close()
        assert(homonyms.size() == homonymCounts.size())
        [ homonyms : homonyms, homonymCounts: homonymCounts, limit: limit ]
    }

}
