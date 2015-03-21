/**
 * OpenThesaurus - web-based thesaurus management tool
 * Copyright (C) 2012 Daniel Naber (www.danielnaber.de)
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

class SimilarLengthComparatorTest extends GroovyTestCase {

    void testComparator() {
        String query = 'hallo'
        SimilarMatch match1 = new SimilarMatch(term: 'hallooo', dist: 2)
        SimilarMatch match2 = new SimilarMatch(term: 'hallx', dist: 1)
        SimilarMatch match3 = new SimilarMatch(term: 'hallox', dist: 1)
        SimilarMatch match4 = new SimilarMatch(term: 'hall', dist: 1)
        def matches = Arrays.asList(match1, match2, match3, match4)
        Collections.sort(matches, new SimilarLengthComparator(query))
        assertEquals("hallx", matches.get(0).term)
        assertEquals("hallox", matches.get(1).term)
        assertEquals("hall", matches.get(2).term)
        assertEquals("hallooo", matches.get(3).term)
    }
}
