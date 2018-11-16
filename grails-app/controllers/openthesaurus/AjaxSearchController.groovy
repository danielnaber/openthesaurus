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

package openthesaurus

import java.sql.Connection
import com.vionto.vithesaurus.Synset
import com.vionto.vithesaurus.SearchResult

import java.util.regex.Matcher
import java.util.regex.Pattern

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
    def ajaxMainSearch() {
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
                // We only show up to 5 substring matches, but we need a higher limit here as this
                // search works on the terms, not on the synsets.
                // TODO: this still doesn't guarantee we get all matches - increasing the value leads to performance problems
                def substringTermMatches = searchService.searchPartialResult(query, 0, 6)
                // TODO: this works but highlighting does not (query: 'ähneln' vs. 'sich ähneln'):
                //if (query.startsWith("sich ") || query.startsWith("etwas ")) {
                //    String simplifiedQuery = query.replaceAll("^(sich|etwas) ", "")
                //    substringTermMatches.addAll(searchService.searchPartialResult(simplifiedQuery, 0, 6))
                //}
                Pattern boundaryPattern = Pattern.compile(".*\\b" + Pattern.quote(params.q) + "\\b.*")
                for (substringMatch in substringTermMatches) {
                    def substringMatches = searchService.searchSynsets(substringMatch.term, 10, 0, false)
                    addSynsetMatches(boundaryPattern, substringMatches, synsetList, substringSynsetList, subwordSynsetList)
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
        String message = "ajaxSearch: ${runTime}ms for '${query}', ${synsetList.size()}+${substringSynsetList.size()} matches"
        if (spellcheck) {
            log.info("${message} (incl. spellcheck)")
        } else {
            log.info("${message}")
        }
        [synsetList: synsetList, substringSynsetList: substringSynsetList,
         minLengthForSubstringQuery: minLengthForSubstringQuery, mostSimilarTerm: mostSimilarTerm]
    }

    private addSynsetMatches(Pattern boundaryPattern, SearchResult substringMatches, List synsetList, List substringSynsetList, List subwordSynsetList) {
        for (synset in substringMatches.synsetList) {
            Matcher matcher = boundaryPattern.matcher(synset.toUnsortedString().toLowerCase())
            if (matcher.matches()) {
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