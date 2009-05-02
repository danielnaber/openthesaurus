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
 * A typed link from one term to another one.
 */
class TermLink {

    Term targetTerm
    TermLinkType linkType

    static belongsTo = [term:Term]

    static mapping = {
        //id generator:'sequence', params:[sequence:'synset_link_seq']
    }

    TermLink() {
    }

    TermLink(Term fromTerm, Term toTerm, TermLinkType linkType) {
        this.term = fromTerm
        this.targetTerm = toTerm
        this.linkType = linkType
    }
    
    def saveAndLog() {
        def saved = save()
        if (saved) {
          log.info("linking term '${term.id}' to term ${targetTerm.id} " +
                "with type ${linkType.id} (${linkType})")
        } else {
            log.info("could not link term '${term.id}' to term ${targetTerm.id}: ${errors}")
        }
        return saved
    }

    String toString() {
        return "${linkType}@${targetTerm}"
    }
}
