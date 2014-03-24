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

/**
 * Compare so that terms where the diff to the query is more at the end of the word come first,
 * assuming typos at the beginning of a word are less probable.
 */
class DiffPositionComparator implements Comparator {

    String query

    DiffPositionComparator(query) {
        this.query = query
    }

    @Override
    int compare(Object o1, Object o2) {
        SimilarMatch similarMatch1 = (SimilarMatch) o1
        SimilarMatch similarMatch2 = (SimilarMatch) o2
        int firstDiffPos1 = firstDiffPosition(query, similarMatch1.term)
        int firstDiffPos2 = firstDiffPosition(query, similarMatch2.term)
        return firstDiffPos2 - firstDiffPos1
    }
    
    private int firstDiffPosition(String s1, String s2) {
        for (int i = 0; i < Math.min(s1.length(), s2.length()); i++) {
            if (Character.toLowerCase(s1.charAt(i)) != Character.toLowerCase(s2.charAt(i))) {
                return i
            }
        }
        return 1000
    }
}
