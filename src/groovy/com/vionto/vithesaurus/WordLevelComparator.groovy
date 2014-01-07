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

/**
 * Compare so that synsets whose relevant term has no language level set is preferred.
 */
class WordLevelComparator implements Comparator {

    String query

    WordLevelComparator(String query) {
        this.query = query
    }

    @Override
    int compare(Object o1, Object o2) {
        Synset syn1 = (Synset) o1
        Synset syn2 = (Synset) o2
        int syn1Prio = hasLevelForQuery(syn1.terms) ? 1 : 0
        int syn2Prio = hasLevelForQuery(syn2.terms) ? 1 : 0
        return syn1Prio - syn2Prio
    }

    boolean hasLevelForQuery(def terms) {
        for (Term term : terms) {
            if ((term.word.equalsIgnoreCase(query) || term.normalizedWord?.equalsIgnoreCase(query)) && term.level) {
                return true
            }
        }
        return false
    }

}
