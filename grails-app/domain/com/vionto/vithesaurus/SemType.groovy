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
 * Per-concept type information from UMLS.
 */
class SemType {
  
	String semType
	String categoryType
	int categoryTypeID
	
    static mapping = {
        //id generator:'sequence', params:[sequence:'sem_type_seq']
    }

    static constraints = {
	    semType(unique:true)
	    categoryType(nullable:true)
	}

	String toString() {
		return semType
	}
	
}