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

class TestController extends BaseController {

    def dataSource
    
    def index = {
        render "Running simple self-test (specific to openthesaurus.de)<br/>"
        assumeMatches("Tür", 1)
        assumeMatches("Tur", 1)  // not really correct, but a known bug
        assumeMatches("aishuifezerfewjv", 0)
        assumeMatches("Bank", 2)
        SynsetController synsetController = new SynsetController()
        String searchString = "grüß got"
        assumeMatches(searchString, 1, {
            Connection conn = dataSource.getConnection()
            try {
                synsetController.searchPartialResult(searchString, conn, 0, 5).size()
            } finally {
                conn.close()
            }
        })
    }

    private assumeMatches(String searchString, int expectedMatches) {
        assumeMatches(searchString, expectedMatches, {
                    SynsetController synsetController = new SynsetController()
                    synsetController.doSearch(searchString, null, null, null, 10, 0).synsetList.size()
        })
    }
    
    private assumeMatches(String searchString, int expectedMatches, def closure) {
        def matches = closure()
        if (matches == expectedMatches) {
            render "OK (${matches} matches)"
        } else {
            render "ERROR: got ${matches}, expected ${expectedMatches} "
        }
        render " searching '${searchString}'"
        render "<br/>\n"
    }

}
