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
 * A link from a synset to a SemType.
 */
class SemTypeLink implements Comparable {

    SemType semType
    
    static belongsTo = [synset:Synset]

    static mapping = {
        //id generator:'sequence', params:[sequence:'sem_type_link_seq']
    }

    SemTypeLink() {
    }
    
    SemTypeLink(Synset fromSynset, SemType semType) {
        this.synset = fromSynset
        this.semType = semType
    }
    
    def saveAndLog() {
        def saved = save()
        if (saved) {
          log.info("linking synset '${synset.id}' " +
                "with type ${semType.id} (${semType})")
        } else {
            log.info("could not link synset '${synset.id}'")
        }
        return saved
    }

    /** Some stable sort order. */
    int compareTo(Object other) {
        return semType.id - other.semType.id 
    }

    String toString() {
        return semType
    }
}
