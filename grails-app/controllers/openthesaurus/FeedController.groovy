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

import com.vionto.vithesaurus.*
import org.apache.commons.lang.StringEscapeUtils

import java.text.DateFormat
import java.text.SimpleDateFormat

/**
 * RSS feed of latest changes. Also see UserEventController.
 */
class FeedController extends BaseController {

   def index() {
       def pubDateFormatter = new SimpleDateFormat("EEE, dd MMM yyyy HH:mm:ss Z", Locale.ENGLISH)

       int max = params.max ? Integer.parseInt(params.max) : 50
       if (max > 250) {
         max = 250
       }
       def eventList = UserEvent.withCriteria {
         maxResults(max)
         order("creationDate", "desc")
       }
       
       def diffs = [:]
       def typeNames = [:]
       UserEventTools tools = new UserEventTools()
       tools.buildMetaInformation(eventList, diffs, typeNames)

       def events = eventList.collect {
           String desc
           if (it.getClass() == com.vionto.vithesaurus.UserSynsetEvent) {
               desc = "Eintrag"
           } else if (it.getClass() == com.vionto.vithesaurus.UserTermEvent) {
               desc = "Wort"
           } else {
               desc = "??? (${it.getClass()})"
           }

           if (it.eventType == LogInfo.CREATION) {
               desc += " hinzugefügt"
           } else if (it.eventType == LogInfo.MODIFICATION) {
               desc += " geändert"
           } else if (it.eventType == LogInfo.LINKING) {
               desc += " verknüpft"
           } else {
               desc += " ??? (${it.eventType})"
           }

           String titleStr = desc
           String username = it.byUser.realName
           if (!username) {
               username = "[anonym]"
           }
           desc += " von Benutzer ${username.encodeAsHTML()}:<br/><br/>"

           String moreInfo = ""
           if (it.getClass() == com.vionto.vithesaurus.UserSynsetEvent && it.eventType == LogInfo.CREATION) {
               // we only get a mostly useless 'empty', so add the synset itself:
               moreInfo += "<br /><br />Eintrag: " + it.synset.toShortStringWithShortLevel(20, true)
           }
           if (it.changeDesc) {
               moreInfo += "<br /><br />Kommentar zur Änderung: " + it.changeDesc.encodeAsHTML()
           }

           String entry = ""
           String link = ""
           String content = ""

           if (it.getClass() == com.vionto.vithesaurus.UserTermEvent && it.eventType == LogInfo.CREATION) {
               // this is part of the synset change info already
           } else {
               String changeDesc = StringEscapeUtils.unescapeHtml(it.synset.toShortString(5))
               entry = username + ": " + titleStr + ": " + changeDesc
               //actually <guid> must be unique but I cannot set this it seems, so let's make
               //the link unique, as this is used as guid:
               link = "${grailsApplication.config.thesaurus.serverURL}/synset/edit/${it.synset.id}#${it.id}"
               content = desc + diffs.get(it)
                       .replaceAll("class='add'>", "style='font-weight:bold;color:green'> ")
                       .replaceAll("class='del'>", "style='font-weight:bold;color:red;text-decoration: line-through'> ")
               // we don't just want to allow all HTML for security reasons, but it's okay to un-escape
               // some harmless tags here:
                       .replaceAll("&lt;br/&gt;", "<br/>")
                       .replaceAll("&lt;b&gt;", "<b>")
                       .replaceAll("&lt;/b&gt;", "</b>") + moreInfo
           }


           [title: entry, pubDate: it.creationDate, description: content, link: link]
       }

       response.setContentType("application/xml")
       [events: events, formatter: pubDateFormatter]
   }
}
