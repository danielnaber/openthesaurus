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

class AdminController extends BaseController {
    
    def beforeInterceptor = [action: this.&adminAuth]
    
    def index = {
        final int resultLimit = 10
        def latestUsers = ThesaurusUser.withCriteria {
          order("creationDate", "desc")
          maxResults(resultLimit)
        }
        [latestUsers: latestUsers, resultLimit: resultLimit]
    }

    def checkNormalizedTermIntegrity = {
        List terms = Term.list()
        int count = 0
        for (term in terms) {
            String normalizedWord = StringTools.normalize(term.word)
            if (normalizedWord != term.word && normalizedWord != term.normalizedWord) {
              render "Error: <a href='../synonyme/edit/${term.synset.id}'>${term.word} | ${term.normalizedWord}</a><br />"
            }
            count++
        }
        render "<br>Checked ${count} terms."
    }

}
