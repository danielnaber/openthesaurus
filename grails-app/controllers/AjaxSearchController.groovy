/**
 * OpenThesaurus - web-based thesaurus management tool
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
import com.vionto.vithesaurus.Synset
import com.vionto.vithesaurus.PartialMatch
import com.vionto.vithesaurus.SearchResult

class AjaxSearchController extends BaseController {

    def dataSource       // will be injected

    def searchService

    /**
     * Return a simplified search result (exact and substring matches) to be fetched
     * via Ajax.
     * 
     * TODO: grüß matches gruß and vice versa
     * TODO: gets confused when query appears in parenthesis int the database (e.g. search "wörtlich")
     */
    def ajaxMainSearch = {
        long startTime = System.currentTimeMillis()
        String query = params.q
        // get 10 + 1 matches so we can display the "there are more matches" link:
        def directMatches = searchService.searchSynsets(query, 11, 0)
        def synsetList = directMatches.synsetList
        def substringSynsetList = []
        def subwordSynsetList = []
        def mostSimilarTerm = null
        boolean spellcheck = false
        def minLengthForSubstringQuery = 3
        if (query.length() >= minLengthForSubstringQuery) {
            Connection conn = dataSource.getConnection()
            try {
                // TODO: increase the limits?!
                def substringTermMatches = searchService.searchPartialResult(query, 0, 5)
                for (substringMatch in substringTermMatches) {
                    def substringMatches = searchService.searchSynsets(substringMatch.term, 10, 0)
                    addSynsetMatches(substringMatch, substringMatches, synsetList, substringSynsetList, subwordSynsetList)
                }
                synsetList.addAll(subwordSynsetList)
                if (synsetList.size() == 0 && substringSynsetList.size() == 0) {
                    mostSimilarTerm = searchService.searchMostSimilarTerm(query, conn)
                    spellcheck = true
                }
            } finally {
                conn.close()
            }
        }
        long runTime = System.currentTimeMillis() - startTime
        if (spellcheck) {
            log.info("ajaxSearch: ${runTime}ms for '${query}' (incl. spellcheck)")
        } else {
            log.info("ajaxSearch: ${runTime}ms for '${query}'")
        }
        [synsetList: synsetList, substringSynsetList: substringSynsetList,
         minLengthForSubstringQuery: minLengthForSubstringQuery, mostSimilarTerm: mostSimilarTerm]
    }

    private addSynsetMatches(PartialMatch substringMatch, SearchResult substringMatches, List synsetList, List substringSynsetList, List subwordSynsetList) {
        for (synset in substringMatches.synsetList) {
            if (synset.toString().toLowerCase().matches(".*\\b" + params.q + "\\b.*")) {
                if (!alreadyListed(synset, substringSynsetList, subwordSynsetList, synsetList)) {           // avoid duplicates
                    subwordSynsetList.add(synset)
                }
            } else {
                if (!alreadyListed(synset, substringSynsetList, subwordSynsetList, synsetList)) {           // avoid duplicates
                    substringSynsetList.add(synset)
                }
            }
        }
    }

    private boolean alreadyListed(Synset synset, List... lists) {
        for (list in lists) {
            if (list.contains(synset)) {
                return true
            }
        }
        return false
    }

}