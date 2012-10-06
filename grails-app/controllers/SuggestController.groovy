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
import com.vionto.vithesaurus.*
import java.sql.Connection

class SuggestController extends BaseController {
    
    def beforeInterceptor = [action: this.&adminAuth]

    def dataSource       // will be injected
    def searchService
    
    def index = {
        []
    }

    def findPotentiallyMissingSynonyms = {
        String text = params.text
        Connection conn = dataSource.getConnection()
        String[] terms = text.split("[\\s+\\.,;\"':„“?()]")
        BaseformFinder baseformFinder = new BaseformFinder()
        List unknownTerms = []
        List unknownTermsBaseforms = []
        for (term in terms) {
            if (term.isEmpty() || term.matches("\\d+")) {
                continue
            }
            SearchResult result = searchService.searchSynsets(term)
            int matches = result.totalMatches
            if (matches == 0) {
                Set baseforms = baseformFinder.getBaseForms(conn, term)
                if (baseforms.size() == 0) {
                    if (!unknownTerms.contains(term)) {
                        unknownTerms.add(term)
                        unknownTermsBaseforms.add(null)
                    }
                } else {
                    for (baseform in baseforms) {
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
