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
 * A typed link from one synset to another one, suggested
 * by the automatic import.
 */
class SynsetLinkSuggestion implements Comparable {

    Synset targetSynset
    LinkType linkType
    /**
     * Number of facts that back this link.
     */
    int factCount

    static belongsTo = [synset:Synset]

    static mapping = {
        //id generator:'sequence', params:[sequence:'synset_link_suggestion_seq']
    }

    SynsetLinkSuggestion() {
    }

    /**
     * Copy constructor.
     */
    SynsetLinkSuggestion(SynsetLinkSuggestion link) {
        this(link.synset, link.targetSynset, link.linkType)
        this.factCount = link.factCount
    }

    SynsetLinkSuggestion(Synset fromSynset, Synset toSynset, LinkType linkType) {
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
            log.warn("could not link synset '${synset.id}' to synset ${targetSynset.id}: ${errors}")
        }
        return saved
    }

    /**
     * A stable sort order: order by link type, import status,
     * preferred term
     */
    int compareTo(Object other) {
        try {

        if (other.linkType.linkName == linkType.linkName) {
            if (other.factCount == null) {
                return 1
            } else if (factCount == null) {
                return -1
            } else if (other.factCount != factCount) {
                return other.factCount > factCount ? 1 : -1
            } else {
                return targetSynset.synsetPreferredTerm.
                    compareToIgnoreCase(other.targetSynset.synsetPreferredTerm)
            }
        } else {
            return linkType.linkName.compareToIgnoreCase(other.linkType.linkName)
        }

        } catch (Exception e) {
            System.out.println(e)
        }

    }

    String toString() {
        return "${linkType}@${targetSynset}"
    }
}
