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
 * Synset validator that checks several logical constraints.
 */
class SynsetValidator {

    Synset synset

    private final String CATEGORY_UNKNOWN = 'Unknown'

    /**
     * The constructor of the class.
     * @param The synset to be validated extended.
     */
    public SynsetValidator(Synset synset) {
        this.synset = synset
    }

    /**
     * Makes an extended validation for synsets.
     * @param A boolean value, if a full validation should be executed.
     * @return True if validation didn't fail.
     */
    public boolean extendedValidate(boolean fullValidation) {
        if (fullValidation) {
            // some simple assertions
            assert (synset)
            assert (synset.terms)
            assert (synset.terms.size() > 0)
            // validate the synset components in detail
            validateTerms()
            validateCategoryLinks()
            validateSynsetLinks()
            validateNonSelfReference()
        } else {
            // nothing is done here.
        }
        return true
    }

    /**
     * Checks if synset contains duplicated terms. It's a comparison
     * of the 'terms.word' and therefore a String compare. If there is a
     * duplicated entry an exception will be thrown.
     * @throws IllegalArgumentException
     */
    private void validateTerms(){
        List termSet = []
        for (term in synset.terms) {
            if(!termSet.contains(term)) {
                termSet.add(term.word)
            } else {
                throw new IllegalArgumentException(
                        "[${synset.id}] Duplicate Term: $term")
            }
        }
    }

    /**
     * Checks for duplicate links and duplicated listed categories.
     * @throws IllegalArgumentException
     */
    private void validateCategoryLinks() {
        List categoryLinkSet = []
        List categories = []

        for (categoryLink in synset.categoryLinks) {
            if (!categoryLinkSet.contains(categoryLink)) {
                categoryLinkSet.add(categoryLink)
            } else {
                throw new IllegalArgumentException("[${synset.id}] " + "Duplicate CategoryLink: $categoryLink")
            }
            if (!categories.contains(categoryLink.category)) {
                categories.add(categoryLink.category)
            } else {
                throw new IllegalArgumentException("[${synset.id}] Category: " +
                        "'${categoryLink.category}' listed twice or more")
            }
        }
    }

    /**
     * Checks if the synset is linked to another synset twice. If so an exception will be thrown.
     * @throws IllegalArgumentException
     */
    private void validateSynsetLinks() {
        List synsetLinkSet = []
        for (synsetLink in synset.synsetLinks) {
            if (!synsetLinkSet.contains(synsetLink)) {
                synsetLinkSet.add(synsetLink)
            } else {
                throw new IllegalArgumentException("[${synset.id}] " + "Duplicate SynsetLink: $synsetLink")
            }
        }
    }

    /**
     * Checks if the synset is linked to itself, if so an exception will
     * be thrown.
     * @throws IllegalArgumentException
     */
    private void validateNonSelfReference() {
        for (synsetLink in synset.synsetLinks) {
            if ((synset.id == synsetLink.targetSynset.id)) {
                throw new IllegalArgumentException("[${synset.id}] " +
                        "Synset should not reference to itself.")
            }
        }
    }

}