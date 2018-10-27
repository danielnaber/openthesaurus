/**
 * OpenThesaurus - web-based thesaurus management tool
 * Copyright (C) 2010 Daniel Naber (www.danielnaber.de)
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

import com.vionto.vithesaurus.*
import java.sql.Connection

class SuggestController extends BaseController {
    
    def beforeInterceptor = [action: this.&auth]

    def dataSource       // will be injected
    def searchService
    
    def index() {}

    def findPotentiallyMissingSynonyms() {
        String text = params.text
        log.info("Checking ${text.length()} chars of text for unknown words")
        Connection conn = dataSource.getConnection()
        String[] terms = text.split("[\\s+\\.,;\"':„“?()«»]")
        BaseformFinder baseformFinder = new BaseformFinder()
        List unknownTerms = []
        List unknownTermsBaseforms = []
        for (term in terms) {
            if (term.trim().isEmpty() || term.matches("\\d+") || !term.matches(".*[a-zA-Z].*")) {
                continue
            }
            SearchResult result = searchService.searchSynsets(term)
            int matches = result.totalMatches
            if (matches == 0) {
                Set baseForms = baseformFinder.getBaseForms(conn, term)
                if (baseForms.size() == 0) {
                    if (!unknownTerms.contains(term)) {
                        unknownTerms.add(term)
                        unknownTermsBaseforms.add(null)
                    }
                } else {
                    for (baseform in baseForms) {
                        result = searchService.searchSynsets(baseform)
                        if (result.totalMatches == 0 && !unknownTermsBaseforms.contains(baseform)) {
                            unknownTermsBaseforms.add(baseform)
                            unknownTerms.add(term)
                        }
                    }
                }
            }
        }
        conn.close()
        [unknownTerms: unknownTerms, unknownTermsBaseforms: unknownTermsBaseforms]
    }

}
