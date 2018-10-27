/**
 * OpenThesaurus - web-based thesaurus management tool
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

package openthesaurus

import grails.util.GrailsUtil

class AboutController extends BaseController {

    def grails() {
        def appVersion = grailsApplication.metadata.getApplicationVersion()

        def grailsVersion = grailsApplication.metadata.getGrailsVersion()
        def grailsVersionThruGrailsUtil = GrailsUtil.grailsVersion

        def message = "Application Version: ${appVersion}<br>Grails Version: ${grailsVersion}<br>Grails Version Thru GrailsUtils: ${grailsVersionThruGrailsUtil}"
        render message
    }

    def index() {
    }

    def jsonpExample() {
    }

    def fakeError = {
        throw new Exception("This is a fake error.")
    }

    def faq() {
    }

    def api() {
    }

    def download() {
        File dbDump = new File(new String(grailsApplication.config.thesaurus.dbDump))
        File textDump = new File(new String(grailsApplication.config.thesaurus.export.text.output))
        File oooDump = new File(new String(grailsApplication.config.thesaurus.export.oxt.output))
        File oooDumpCh = null
        if (grailsApplication.config.thesaurus.export.oxt.outputCH) {
            oooDumpCh = new File(new String(grailsApplication.config.thesaurus.export.oxt.outputCH))
        }
        [dbDump: dbDump, textDump: textDump, oooDump: oooDump, oooDumpCh: oooDumpCh]
    }

    def topusers() {
    }

    def imprint() {
    }

    def newsarchive() {
    }

    def newsletter() {
    }

    def werbung() {
    }

    def logMessage() {
        log.info("client message: " + params.msg + " - " + request.getHeader("User-Agent"))
        render("OK")
    }

}
