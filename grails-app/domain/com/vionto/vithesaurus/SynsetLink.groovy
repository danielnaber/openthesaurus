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
 * A typed link from one synset to another one.
 */
class SynsetLink implements Comparable {

    static belongsTo = [synset:Synset]

    static mapping = {
        //id generator:'sequence', params:[sequence:'synset_link_seq']
    }

    Synset targetSynset
    LinkType linkType

    SynsetLink() {
    }

    /**
     * Copy constructor.
     */
    SynsetLink(SynsetLink link) {
        this(link.synset, link.targetSynset, link.linkType)
    }

    SynsetLink(Synset fromSynset, Synset toSynset, LinkType linkType) {
        this.synset = fromSynset
        this.targetSynset = toSynset
        this.linkType = linkType
    }
    
    def saveAndLog() {
        def saved = save()
        if (saved) {
          log.info("linking synset '${synset.id}' to synset ${targetSynset.id} " +
                "with type ${linkType.id} (${linkType})")
        } else {
            log.info("could not link synset '${synset.id}' to synset ${targetSynset.id}: ${errors}")
        }
        return saved
    }

    /**
     * A stable sort order: order by link type (e.g. "hypernym"), then by preferred term
     */
    int compareTo(Object other) {
        if (other.linkType.linkName == linkType.linkName) {
            return targetSynset.id - other.targetSynset.id		// any order, but stable
        } else {
            return linkType.linkName.compareToIgnoreCase(other.linkType.linkName)
        }
    }

    String toString() {
        return "${linkType}@${targetSynset.terms}"
    }
}
