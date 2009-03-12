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
package com.vionto.vithesaurus

/**
 * A simple Synset with no Hibernate dependency.
 * Used by ExportController for fast export.
 */
public class ExportSimpleSynset {

    int id
    long sectionId
    long sourceId
    String userComment
    String originalURI
    String synsetPreferredTerm
    List terms = []
    List catUris = []
    List catLinks = []
    Map preferredTermLinks = new HashMap()
    SimpleCategory preferredCategory
    
    void addToCategoryLinks(SimpleCategoryLink catLink) {
        catLinks.add(catLink)
    }
    
    void setPreferredTerm(String langCode, String prefTerm) {
        preferredTermLinks.put(langCode, prefTerm)
        synsetPreferredTerm = prefTerm
    }
    
    void addTerm(SimpleTerm term) {
        terms.add(term)
    }
    
    void addCategoryUri(String uri) {
        catUris.add(uri)
    }
 
    boolean containsWord(String word) {
        for (term in terms) {
            if (term.word == word) {
                return true
            }
        }
        return false
    }
    
}
