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
import java.net.URLEncoder
            
/**
 * Controller that keeps old IDs from the PHP version of
 * OpenThesaurus working.
 */
class RedirectController extends BaseController {
    
    String baseUrl = "http://localhost:8080/vithesaurus/"

    def overview = {
        String q = URLEncoder.encode(params.word, "UTF-8")
        response.sendRedirect(baseUrl + "synset/search?q=" + q)
    }

    def worddetail = {
        Term term = Term.findByOriginalId(params.wmid)
        if (term == null) {
          throw new Exception("No term found with the given id ${params.wmid}")
        }
        response.sendRedirect(baseUrl + "term/edit/" + term.id)
    }

}
