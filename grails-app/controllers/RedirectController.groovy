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
import javax.servlet.http.HttpServletResponse

/**
 * Controller that keeps old IDs from the PHP version of
 * OpenThesaurus working.
 */
class RedirectController extends BaseController {

    // temporary statistics
    /*def gotoUrl = {
        if (!params.url.contains('eyeplorer') && !params.url.contains('45info.com')) {
            throw new Exception("Illegal redirect url")
        }
        log.info("redirecting to " + params.url + ", UA: " + request.getHeader("User-Agent"))
        response.setHeader("Location", params.url)
        response.sendError(302)
    }*/

   def searchwithoutjavascript = {
     // remove the useless "x" and "y" coordinates caused by the graphical submit button
     String query = params.q
     if (!query) {
       query = "Suchwort"
     }
     redirect(controller:'synset', action:'search', params:[q: query])
   }

   def synseteditredirect = {
     permanentRedirect("synonyme/edit/" + params.id, response)
   }

   def synsetsearchredirect = {
       String q = URLEncoder.encode(params.q, "UTF-8")
       if (params.format) {
         q += "&format=" + params.format
       }
       if (params.similar) {
         q += "&similar=" + params.similar
       }
       if (params.mode) {
         q += "&mode=" + params.mode
       }
       permanentRedirect("synonyme/" + q, response)
   }

   def faq = {
       permanentRedirect("about/faq", response)
   }

   def background = {
       permanentRedirect("about/index", response)
   }

   def newsarchive = {
       permanentRedirect("about/newsarchive", response)
   }

   def statistics = {
       permanentRedirect("synset/statistics", response)
   }

   def login = {
       permanentRedirect("user/login", response)
   }

   def register = {
       permanentRedirect("user/register", response)
   }

   /* A to Z */
   def az = {
       permanentRedirect("term/list", response)
   }

   def imprint = {
       permanentRedirect("about/imprint", response)
   }
   
   def tree = {
       permanentRedirect("tree/index", response)
   }

   /* RSS feed */
   def feed = {
       permanentRedirect("feed", response)
   }

   def variation = {
       if (params.lang == 'at') {
         permanentRedirect("synset/variation/at", response)
       } else if (params.lang == 'ch') {
         permanentRedirect("synset/variation/ch", response)
       }
   }

   def overview = {
       if (!params.word) {
         log.info("missing 'word' parameter in redirect from overview")
         response.sendError(500, "Parameter 'word' must be specified")
         return
       }
       String q = URLEncoder.encode(params.word, "UTF-8")
       permanentRedirect("synonyme/" + q, response)
   }

   def substringSearch = {
       if (!params.word) {
         log.info("missing 'word' parameter in redirect from overview")
         response.sendError(500, "Parameter 'word' must be specified")
         return
       }
       String q = URLEncoder.encode(params.word, "UTF-8")
       permanentRedirect("synset/substring?q=" + q, response)
   }

   def gotoAbout = {
       permanentRedirect("about/index", response)
   }

   def synset = {
       if (params.id) {
         // this is an ID from the PHP version of OpenThesaurus, we keep it working:
         try {
           Integer.parseInt(params.id)
         } catch (Exception e) {
           // probably a spammer inserting a url into the parameter
           log.info("crappy id parameter in redirect: " + params.id)
           flash.message = message(code:'notfound.id.not.found', args:[params.id.encodeAsHTML()])
           response.sendError(404)
           return
         }
         Synset synset = Synset.findByOriginalId(params.id)
         if (synset == null) {
           flash.message = message(code:'notfound.id.not.found', args:[params.id.encodeAsHTML()])
           response.sendError(404)
           return
         }
         permanentRedirect("synonyme/edit/" + synset.id, response)
         return
       }
       response.sendError(404)
   }
   
   def worddetail = {
       try {
         Integer.parseInt(params.wmid)
       } catch (Exception e) {
         // probably a spammer inserting a url into the parameter
         log.info("crappy wmid parameter in redirect: " + params.id)
         flash.message = message(code:'notfound.id.not.found', args:[params.wmid.encodeAsHTML()])
         response.sendError(404)
         return
       }
       Term term = Term.findByOriginalId(params.wmid)
       if (term == null) {
         flash.message = message(code:'notfound.termid.not.found', args:[params.wmid.encodeAsHTML()])
         response.sendError(404)
         return
       }
       permanentRedirect("term/edit/" + term.id, response)
   }
   
   void permanentRedirect(String url, HttpServletResponse response) {
        String newUrl = getBaseUrl() + url
        response.setHeader("Location", newUrl)
        // search engines expect 301 if a move is permanent:
        response.sendError(301)
    }

    private String getBaseUrl() {
        // This cannot be taken from the request as the installation might
        // be shielded behind an Apache server and we don't see the outside URL
        // in the request:
        return grailsApplication.config.thesaurus.serverURL + "/"
    }

}
