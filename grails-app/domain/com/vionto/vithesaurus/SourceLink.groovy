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
 * A source, defined by its URI.
 */
class SourceLink implements Comparable {

    String uri
    
    static belongsTo = [synset:Synset]

    static mapping = {
        //id generator:'sequence', params:[sequence:'source_link_seq']
    }

    SourceLink() {
    }
    
    SourceLink(String uri, Synset synset) {
        this.uri = uri
        this.synset = synset
    }
    
    String toString() {
        return uri
    }

    int compareTo(Object other) {
        return uri.compareTo(other.uri)
    }
    
}
