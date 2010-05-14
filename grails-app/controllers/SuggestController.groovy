/**
 * vithesaurus - web-based thesaurus management tool
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
    
    def index = {
        []
    }

    def findPotentiallyMissingSynonyms = {
        String text = params.text
        Connection conn = dataSource.getConnection()
        String[] terms = text.split("[\\s+\\.,;\"':]")
        SynsetController controller = new SynsetController()
        BaseformFinder baseformFinder = new BaseformFinder(conn)
        List unknownTerms = []
        for (term in terms) {
            if (term.isEmpty() || term.matches("\\d+")) {
                continue
            }
            int matches = 0
            SearchResult result = controller.doSearch(term, null, null, null)
            matches = result.totalMatches
            if (matches == 0) {
                String baseform = baseformFinder.getBaseForm(term)
                if (baseform != null) {
                    result = controller.doSearch(baseform, null, null, null)
                    matches = result.totalMatches
                }
            }
            if (matches == 0) {
                if (!unknownTerms.contains(term)) {
                    unknownTerms.add(term)
                }
            }
        }
        conn.close()
        [unknownTerms: unknownTerms]
    }

}
