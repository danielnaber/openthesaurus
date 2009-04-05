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
 * A link from one synset to (Term, Language) tuple.
 */
class PreferredTermLink implements Comparable {

    Language language
    Term term
    
    static belongsTo = [synset:Synset]
    
    static mapping = {
        //id generator:'sequence', params:[sequence:'preferred_term_link_seq']
    }

    /** Sort by language name. */
    int compareTo(Object other) {
        // there's only one preferred term per language, so it's
        // enough to compare omly the language, not the term:
        return language.shortForm.compareTo(other.language.shortForm)
    }

    String toString() {
        return "${language.shortForm}:${term}"
    }
}
