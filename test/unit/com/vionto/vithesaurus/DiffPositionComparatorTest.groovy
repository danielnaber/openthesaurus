/**
 * OpenThesaurus - web-based thesaurus management tool
 * Copyright (C) 2014 Daniel Naber (www.danielnaber.de)
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

class DiffPositionComparatorTest extends GroovyTestCase {

    void testComparator() {
        String query = 'hallo'
        SimilarMatch match1 = new SimilarMatch(term: 'halloX', dist: 2)
        SimilarMatch match2 = new SimilarMatch(term: 'halX', dist: 2)
        SimilarMatch match3 = new SimilarMatch(term: 'XallX', dist: 2)
        SimilarMatch match4 = new SimilarMatch(term: 'haXlX', dist: 2)
        def matches = Arrays.asList(match1, match2, match3, match4)
        Collections.sort(matches, new DiffPositionComparator(query))
        assertEquals("halloX", matches.get(0).term)
        assertEquals("halX", matches.get(1).term)
        assertEquals("haXlX", matches.get(2).term)
        assertEquals("XallX", matches.get(3).term)
    }
}
