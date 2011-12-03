/**
 * vithesaurus - web-based thesaurus management tool
 * Copyright (C) 2011 Daniel Naber (www.danielnaber.de)
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
import java.sql.Connection

class AjaxSearchController extends BaseController {

    def dataSource       // will be injected

    /**
     * Return a simplified search result (exact and substring matches) to be fetched
     * via Ajax.
     * 
     * TODO: duplicate matches, e.g. for "Saxofon"
     * TODO: grüß matches gruß and vice versa
     */
    def ajaxMainSearch = {
        long startTime = System.currentTimeMillis()
        SynsetController synsetController = new SynsetController()
        String query = params.q.trim()
        def directMatches = synsetController.doSearch(query, null, null, null, 10, 0)
        def synsetList = directMatches.synsetList
        def substringSynsetList = []
        def minLengthForSubstringQuery = 3
        if (query.length() >= minLengthForSubstringQuery) {
            Connection conn = dataSource.getConnection()
            try {
                def substringTermMatches = synsetController.searchPartialResult(query, conn, 0, 5)
                for (substringMatch in substringTermMatches) {
                    def substringMatches = synsetController.doSearch(substringMatch.term, null, null, null, 10, 0)
                    substringSynsetList.addAll(substringMatches.synsetList) 
                }
            } finally {
                conn.close()
            }
        }
        long runTime = System.currentTimeMillis() - startTime
        log.info("ajaxSearch: ${runTime}ms for '${query}'")
        [synsetList: synsetList, substringSynsetList: substringSynsetList,
         minLengthForSubstringQuery: minLengthForSubstringQuery]
    }

}