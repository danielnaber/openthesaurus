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
    
   def faq = {
       String baseUrl = getBaseUrl()
       response.sendRedirect(baseUrl + "about/faq")
   }

   def background = {
       String baseUrl = getBaseUrl()
       response.sendRedirect(baseUrl + "about/index")
   }

   def newsarchive = {
       String baseUrl = getBaseUrl()
       response.sendRedirect(baseUrl + "about/newsarchive")
   }

   def statistics = {
       String baseUrl = getBaseUrl()
       response.sendRedirect(baseUrl + "synset/statistics")
   }

   /* A to Z */
   def az = {
       String baseUrl = getBaseUrl()
       response.sendRedirect(baseUrl + "term/list")
   }

   def imprint = {
       String baseUrl = getBaseUrl()
       response.sendRedirect(baseUrl + "about/imprint")
   }
   
   def tree = {
       String baseUrl = getBaseUrl()
       response.sendRedirect(baseUrl + "tree/index")
   }

   def variation = {
       String baseUrl = getBaseUrl()
       if (params.lang == 'at') {
         response.sendRedirect(baseUrl + "synset/variation/at")
       } else if (params.lang == 'ch') {
         response.sendRedirect(baseUrl + "synset/variation/ch")
       }
   }

   def overview = {
        String baseUrl = getBaseUrl()
        String q = URLEncoder.encode(params.word, "UTF-8")
        response.sendRedirect(baseUrl + "synset/search?q=" + q)
    }

    def gotoAbout = {
        String baseUrl = getBaseUrl()
        response.setHeader("Location", baseUrl + "about/index")
        // search engines expect 301 if a move is permanent:
        response.sendError(301)
    }
    
    def worddetail = {
        Term term = Term.findByOriginalId(params.wmid)
        if (term == null) {
          flash.message = message(code:'notfound.termid.not.found', args:[params.wmid.encodeAsHTML()])
          response.sendError(404)
          return
        }
        String url = baseUrl + "term/edit/" + term.id
        response.setHeader("Location", url)
        // search engines expect 301 if a move is permanent:
        response.sendError(301)
    }

    private String getBaseUrl() {
      String port = ""
        if (request.getLocalPort() != 80) {
          port = ":" + request.getLocalPort()
        }
        String baseUrl = 
          request.getScheme() + "://" + request.getServerName() + port + request.getContextPath() + "/"
        return baseUrl
    }

}
