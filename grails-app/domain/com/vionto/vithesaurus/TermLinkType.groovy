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
 * A type of Link between Terms, e.g. "antonym", ...
 * 
 * Also see LinkType for links between Synsets.
 */
class TermLinkType {
  
    static mapping = {
        //id generator:'sequence', params:[sequence:'link_type_seq']
    }

    /** E.g. "antonym" */
	String linkName
	/** E.g. "antonym" */
	String otherDirectionLinkName
	/** The name when used in a sentence, e.g. "A is a B" */
	String verbName
	
    static constraints = {
        linkName(unique:true)
        verbName(unique:true)
	}

    TermLinkType() {
    }

    TermLinkType(String linkName) {
      this.linkName = linkName
    }
    
	String toString() {
		return linkName
	}
}
