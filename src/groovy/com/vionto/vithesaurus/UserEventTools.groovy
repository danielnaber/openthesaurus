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
package com.vionto.vithesaurus

class UserEventTools {

    /**
     * Takes a list of user events and two empty maps. Fills the first map with
     * information about the difference sets of those events (by building a
     * HTML snippet that highlights changes). Fills the second map with
     * information about which kind of change the event is, e.g. "term creation"
     * or "concept modification".
     */
    void buildMetaInformation(List eventList, Map diffs, Map typeNames) {
        for (event in eventList) {
            // normalize the different line endings:
            String oldVal = event.oldValue?.replaceAll("\r", "")
            String newVal = event.newValue?.replaceAll("\r", "")
            String diffStr = Diff.diff(oldVal, newVal)
            // replace first pipe added as a workaround for a diff bug:
            diffStr = diffStr.replaceFirst("^\\| ", "")
            diffs.put(event, diffStr)
            String typeName = ""
            if (event.getClass() == com.vionto.vithesaurus.UserSynsetEvent) {
                typeName = "concept"
            } else if (event.getClass() == com.vionto.vithesaurus.UserTermEvent) {
                typeName = "term"
            } else {
                typeName = "unknown (${event.getClass()})"
            }
            typeName += " "
            if (event.eventType == LogInfo.CREATION) {
                typeName += "creation"
            } else if (event.eventType == LogInfo.MODIFICATION) {
                typeName += "modification"
            } else if (event.eventType == LogInfo.LINKING) {
                typeName += "linking"
            } else {
                typeName = "unknown (${event.eventType})"
            }
            typeNames.put(event, typeName)
        }
    }

}