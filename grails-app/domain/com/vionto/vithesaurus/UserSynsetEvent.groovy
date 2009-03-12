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
 * Changes on a synset caused by user, e.g. the creation of a synset.
 */
class UserSynsetEvent extends UserEvent {
	    
    UserSynsetEvent() {
        // should not be used 
    }

    // changes inside a snyset
    UserSynsetEvent(Synset synset, LogInfo logInfo) {
        this(synset, null, logInfo)
    }
    
    // links between synsets
    UserSynsetEvent(Synset synset, Synset otherSynset, LogInfo logInfo) {
        super(synset, otherSynset, logInfo)
    }

    String toString() {
        StringBuilder s = new StringBuilder()
        s.append("type:")
        s.append(eventTypeToString())
        s.append(" id:${synset.id} user:${byUser.userId} ip:${ipAddress}")
        s.append(" changedesc:${changeDesc} propchanges:")
        s.append(propChanges())
        return s.toString()
    }
    
}
