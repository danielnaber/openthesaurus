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
package com.vionto.vithesaurus

import com.vionto.vithesaurus.tools.StringTools
import grails.persistence.Entity;

/**
 * The category that synsets are associated with.
 */
@Entity
class Category implements Comparable, Cloneable {

    /** User-visible name */
    String categoryName
    /** If true, cannot be selected when creating new synsets */
    Boolean isDisabled

    static constraints = {
        categoryName(unique:true)
        isDisabled(nullable:true)   // required to make automatic DB update work
    }

    Category() {
    }
    
    Category(String categoryName) {
        this.categoryName = categoryName
    }
    
    String toString() {
        return categoryName
    }
 
    int compareTo(Object other) {
        String name = StringTools.normalizeForSort(categoryName)
        String otherName = StringTools.normalizeForSort(other.categoryName)
        return name.compareToIgnoreCase(otherName)
    }
    
    Object clone() {
        return super.clone()
    }

}