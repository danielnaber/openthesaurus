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

/**
 * RSS feed of latest changes. Also see UserEventController.
 */
class FeedController extends BaseController {

   def index = {

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

       // FIXME: i18n at several places..
       render(feedType:"rss", feedVersion:"2.0") {
         title = "Letzte Änderungen in OpenThesaurus"
         link = "${grailsApplication.config.thesaurus.serverURL}/feed"
         description = "Letzte Änderungen in OpenThesaurus"
         eventList.each() { event ->
           String desc
           String title = ""
           if (event.getClass() == com.vionto.vithesaurus.UserSynsetEvent) {
             desc = "Eintrag"
           } else if (event.getClass() == com.vionto.vithesaurus.UserTermEvent) {
             desc = "Wort"
           } else {
             desc = "??? (${event.getClass()})"
           }
           if (event.eventType == LogInfo.CREATION) {
             desc += " hinzugefügt"
           } else if (event.eventType == LogInfo.MODIFICATION) {
             desc += " geändert"
           } else if (event.eventType == LogInfo.LINKING) {
             desc += " verknüpft"
           } else {
             desc += " ??? (${event.eventType})"
           }
           title = desc
           String username = event.byUser.realName
           if (!username) {
             username = "[anonym]"
           }
           desc += " von Benutzer ${username.encodeAsHTML()}: "
           String moreInfo = ""
           if (event.getClass() == com.vionto.vithesaurus.UserSynsetEvent && event.eventType == LogInfo.CREATION) {
             // we only get a mostly useless 'empty', so add the synset itself:
             moreInfo += "<br /><br />Eintrag: " + event.synset.toShortStringWithShortLevel(20, true)
           }
           if (event.changeDesc) {
             moreInfo += "<br /><br />Kommentar zur Änderung: " + event.changeDesc.encodeAsHTML()
           }
           if (event.getClass() == com.vionto.vithesaurus.UserTermEvent && event.eventType == LogInfo.CREATION) {
             // this is part of the synset change info already
           } else {
             entry(username.encodeAsHTML() + ": " + title + ": " + event.synset.toShortString(5)) {
               publishedDate = event.creationDate
               //actually <guid> must be unique but I cannot set this it seems, so let's make
               //the link unique, as this is used as guid:
               link = "${grailsApplication.config.thesaurus.serverURL}/synset/edit/${event.synset.id}#${event.id}"
               content {
                 type = "text/html"
                 desc + diffs.get(event)
                   .replaceAll("class='add'>", "style='font-weight:bold;color:green'> ")
                   .replaceAll("class='del'>", "style='font-weight:bold;color:red;text-decoration: line-through'> ") + moreInfo
               }
             }
           }
         }
       }
       
   }

}
