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
 * Match of a Levenshtein comparison.
 */
class SimilarMatch implements Comparable {
  int dist
  String term

  public String toString() {
    return term + "/" + dist
  }
  
  public int compareTo(Object o) {
    SimilarMatch other = (SimilarMatch) o
    if (other.dist == dist) {
      return term.compareToIgnoreCase(other.term)		// alphabetical order
    }
    return dist - other.dist      // lowest distance value comes first when sorting
  }
  
}
