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

/**
 * Compare so that terms with a length similar to the query come first.
 */
class SimilarLengthComparator implements Comparator {

    String query

    SimilarLengthComparator(query) {
        this.query = query
    }

    @Override
    int compare(Object o1, Object o2) {
        SimilarMatch similarMatch1 = (SimilarMatch) o1
        SimilarMatch similarMatch2 = (SimilarMatch) o2
        int dist1 = Math.abs(similarMatch1.term.length() - query.length())
        int dist2 = Math.abs(similarMatch2.term.length() - query.length())
        return dist1 - dist2
    }
}
