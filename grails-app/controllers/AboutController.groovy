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
import java.util.regex.Pattern
            
class AboutController extends BaseController {

    def index = {
        []
    }

    def faq = {
        []
    }

    def api = {
        []
    }

    def download = {
        File dbDump = new File(new String(grailsApplication.config.thesaurus.dbDump))
        File textDump = new File(new String(grailsApplication.config.thesaurus.export.text.output))
        File oooDump = new File(new String(grailsApplication.config.thesaurus.export.oxt.output))
        File oooDumpCh = new File(new String(grailsApplication.config.thesaurus.export.oxt.outputCH))
        [dbDump: dbDump, textDump: textDump, oooDump: oooDump, oooDumpCh: oooDumpCh]
    }

    def topusers = {
        []
    }

    def imprint = {
        []
    }
    
    def newsarchive = {
        []
    }
    
    /** Livewatch.de server monitoring */
    def livecheck = {
      	Pattern p = Pattern.compile("[a-f0-9]{32}")
      	String key = request.getParameter("key")
      	if (key == null) {
      		render "Alles OK"
      	} else if (p.matcher(key).matches()) {
      	    render key
      	} else {
      	    render ""
      	}
    }

}
