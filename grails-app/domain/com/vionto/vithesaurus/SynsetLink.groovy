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

    Synset targetSynset
    LinkType linkType

    /**
     * EVAL_APPROVED for links from SynsetLinkSuggestion that
     * have been manually approved, EVAL_REJECTED for links that have been
     * explicitly rejected. Only links with an evaluationStatus of null may
     * be deleted when importing new potential hypernym/hyponyms!
     */
    int evaluationStatus
    final static int EVAL_APPROVED = 1
    final static int EVAL_REJECTED = 2
    
    /**
     * Number of facts backing this link - only useful if this is generated from
     * a suggested link
     */
    int factCount = 0
    
    static belongsTo = [synset:Synset]

    static mapping = {
        //id generator:'sequence', params:[sequence:'synset_link_seq']
    }

    SynsetLink() {
    }

    /**
     * Copy constructor.
     */
    SynsetLink(SynsetLink link) {
        this(link.synset, link.targetSynset, link.linkType)
        this.evaluationStatus = link.evaluationStatus
        this.factCount = link.factCount
    }

    /**
     * Create a SynsetLink based on a suggested SynsetLink.
     */
    SynsetLink(SynsetLinkSuggestion link) {
        this(link.synset, link.targetSynset, link.linkType)
        this.factCount = link.factCount
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
            if (targetSynset.synsetPreferredTerm == null
                || other.targetSynset.synsetPreferredTerm == null) {
                return targetSynset.id - other.targetSynset.id		// any order, but stable
            }
            return targetSynset.synsetPreferredTerm.
                compareToIgnoreCase(other.targetSynset.synsetPreferredTerm)
        } else {
            return linkType.linkName.compareToIgnoreCase(other.linkType.linkName)
        }
    }

    String toString() {
        if (targetSynset.synsetPreferredTerm) {
            return "${linkType}@${targetSynset.synsetPreferredTerm}"
        } else {
            return "${linkType}@${targetSynset.terms}"
        }
    }
}
