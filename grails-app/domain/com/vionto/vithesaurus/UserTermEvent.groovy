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
 * Changes on a term caused by user.
 */
class UserTermEvent extends UserEvent {
	
    // we cannot use Term here as we then couldn't delete Terms:
    String word
    int termId
    
    UserTermEvent() {
        // should not be used 
    }

    UserTermEvent(Term term, LogInfo logInfo) {
        super(term.synset, null, logInfo)
        this.word = term.word
        this.termId = term.id
    }
    
    String toString() {
        StringBuilder s = new StringBuilder()
        s.append("type:")
        s.append(eventTypeToString())
        s.append(" termid:${termId} synsetid:${synset.id}")
        s.append(" user:${byUser.userId} ip:${ipAddress} ")
        s.append(" changedesc:${changeDesc} propchanges:")
        s.append(propChanges())
        return s.toString()
    }
    
}
