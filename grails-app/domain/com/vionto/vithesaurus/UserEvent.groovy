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
package com.vionto.vithesaurus;

/**
 * Changes caused by user, e.g. the creation of a synset.
 */
class UserEvent {

    Date creationDate
    ThesaurusUser byUser
    String ipAddress
    Synset otherSynset
    String changeDesc
    int eventType
    List propertyDiffs
    String oldValue     // value of old object's toDetailedValue()
    String newValue     // value of new object's toDetailedValue()

    static belongsTo = [synset:Synset]

    static constraints = {
        changeDesc(maxSize:4000)
        otherSynset(nullable:true)
        ipAddress(nullable:true)
        changeDesc(nullable:true)
        oldValue(nullable:true)
        newValue(nullable:true)
    }

    static mapping = {
        //id generator:'sequence', params:[sequence:'user_event_seq']
        oldValue(type:'text')
        newValue(type:'text')
    }

    UserEvent() {
        // should not be used
    }

    UserEvent(Synset synset, LogInfo logInfo) {
        this(synset, null, logInfo)
    }

    UserEvent(Synset synset, Synset otherSynset, LogInfo logInfo) {
        if (synset == null) {
            throw new NullPointerException("synset cannot be null")
        }
        if (logInfo == null) {
            throw new NullPointerException("logInfo cannot be null")
        }
        creationDate = new Date()
        this.synset = synset
        this.byUser = logInfo.byUser
        this.ipAddress = logInfo.ipAddress
        this.eventType = logInfo.eventType
        this.changeDesc = logInfo.description
        this.propertyDiffs = logInfo.propertyDiffs
        this.oldValue = logInfo.oldValue
        this.newValue = logInfo.newValue
    }

    /**
     * The changes as a human-readable string.
     */
    String propChanges() {
        StringBuilder s = new StringBuilder()
        for (diff in propertyDiffs) {
            s.append(diff)
            s.append("; ")
        }
        return s.toString()
    }

    /**
     * The event type ("creation" or "modification") as a
     * human-readable string.
     */
    String eventTypeToString() {
        if (eventType == LogInfo.CREATION) {
            return "creation"
        } else if (eventType == LogInfo.MODIFICATION) {
            return "modification"
        } else if (eventType == LogInfo.LINKING) {
            return "linking"
        } else {
            throw new IllegalStateException("unknown event type: ${eventType}")
        }
    }

}
