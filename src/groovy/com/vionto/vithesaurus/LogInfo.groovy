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

/**
 * Information about changes by users that are going to be logged.
 */
class LogInfo {
    
    // Possible values for eventType:
    /** Synset creation. */
    final static int CREATION = 0
    /** Synset modification. */
    final static int MODIFICATION = 1
    /** Linking between two synsets. */
    final static int LINKING = 2
    
    ThesaurusUser byUser
    String ipAddress
    int eventType
    List propertyDiffs
    String description
    String oldValue
    String newValue
    SynsetLink synsetLink

    /**
     * Synset linking.
     */
    LogInfo(def session, String ipAddress, SynsetLink synsetLink, String description,
            String userDescription) {
         if (!synsetLink) {
             throw new Exception("synsetLink cannot be null")
         }
         this.synsetLink = synsetLink
         this.byUser = session?.user
         this.ipAddress = ipAddress
         this.eventType = LINKING
         this.oldValue = description
         this.newValue = description
         this.description = userDescription
    }
    
    /**
     * Synset changes. Use null for oldObject if
     * there is no old object to compare to (i.e. if the synset
     * has just been created).
     */
    LogInfo(def session, String ipAddress,
            Object oldObject, Object newObject, String description) {
        this.byUser = session?.user
        this.ipAddress = ipAddress
        this.eventType = oldObject == null ? CREATION : MODIFICATION
        this.propertyDiffs = DiffTool.diff(oldObject, newObject)
        this.description = description
        if (oldObject) {
            this.oldValue = oldObject.toDetailedString()
        }
        this.newValue = newObject.toDetailedString()
    }
    
    /**
     * For changes done via API.
     * Currently commented out because the API is also called from a 
     * controller thus there's a session available.
     *
    LogInfo(ThesaurusUser user, int eventType, String description) {
        this.byUser = user
        this.ipAddress = ipAddress
        this.eventType = eventType
        this.description = description
    }*/
 
    String toString() {
        StringBuilder s = new StringBuilder()
        s.append("LogInfo: user:${byUser?.userId} ip:${ipAddress} ")
        if (eventType == CREATION) {
            s.append("creation")
        } else if (eventType == MODIFICATION) {
            s.append("modification")
        } else if (eventType == LINKING) {
            s.append("linking")
        } else {
            throw new IllegalStateException("unknown event type: ${eventType}")
        }
        if (eventType == LINKING) {
            s.append(" changedesc:${description}")
        } else {
            s.append(" changedesc:${description} propchanges:${propertyDiffs}")
        }
        return s.toString()
    }

}
