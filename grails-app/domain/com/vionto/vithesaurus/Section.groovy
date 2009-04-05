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
 * A section that synsets are associated with. Used
 * to partition the data into several parts.
 */
class Section implements Comparable, Cloneable {
    
    /** User-visible name of the section (a.k.a "Thesaurus") */
    String sectionName
    
    /** Used for sorting. Higher numbers come first. */
    int priority
    
    //static searchable = [only: ['sectionName']]
    
    static constraints = {
        sectionName(unique:true)
    }
   
    static mapping = {
        //id generator:'sequence', params:[sequence:'section_seq']
    }

    Section() {
    }
    
    Section(String sectionName) {
        this.sectionName = sectionName
    }
    
    String toString() {
        return sectionName
    }
 
    int compareTo(Object other) {
        if (priority != other.priority) {
            return other.priority - priority 
        }
        return sectionName.compareToIgnoreCase(other.sectionName)
    }
    
    Object clone() {
        return super.clone()
    }

}
