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

import com.vionto.vithesaurus.Synset

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
     * If extendedValidate() is exectuted without params
     * no extended valdation will be obtained.
     */
    public boolean extendedValidate() {
        extendedValidate(false)
    }

    /**
     * Makes an extended validation for synsets.
     * @param A boolean value, if a full validation should be executed.
     * @return True if validation didn't fail.
     */
    private boolean extendedValidate(boolean fullValidation) {
        if (fullValidation) {
            // some simple assertions
            assert (synset)
            //assert (synset.preferredCategory)
            //assert (synset.categoryLinks)
            //assert (synset.synsetPreferredTerm)
            assert (synset.terms)
            //assert (synset.section)
            assert (synset.terms.size() > 0)
            assert (synset.terms.size() >= synset.preferredTermLinks.size())
            // validate the synset components in detail
            validateTerms()
            //validatePreferredTerm()
            //validatePreferredTermLinks()
            validateCategoryLinks()
            validateSynsetLinks()
            validateNonSelfReference()
        } else {
            // nothing is done here.
        }
        return true
    }

    /**
     * Checks if synset contains duplicated terms. It's a comparsion
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
     * Checks if the synset.synsetPreferredTerm can be found as term in
     * the synset.terms list. If not an exception will be thrown.
     * @throws IllegalArgumentException
     */
    private void validatePreferredTerm() {
        def found = false
        for (term in synset.terms) {
            if (term.word.equals(synset.synsetPreferredTerm)) {
                found = true
                break
            }
        }
        if (!found) {
            throw new IllegalArgumentException("[${synset.id}] Linked terms " +
                    "don't contain annotated preferredTerm: " +
                    "${synset.synsetPreferredTerm}")
        }
    }

    /**
     * Checks if all preferredTerms are also linked and therefore listed
     * in the synset.terms list. If not an exception will be thrown.
     * Checks if the number of languages is equal to the number of preferred
     * terms. If not an exception is thrown.
     * @throws IllegalArgumentException
     */
    private void validatePreferredTermLinks() {
        for (preferredTermLink in synset.preferredTermLinks) {
            if (!synset.terms.contains(preferredTermLink.term)) {
                throw new IllegalArgumentException("[${synset.id}] " +
                        "Preferred Term Link '${preferredTermLink.term}' " +
                        "refers to unbound term")
            }
        }
        List languages = []
        for (term in synset.terms) {
            if (!languages.contains(term.language)) {
                languages.add(term.language)
            }
        }
        if (languages.size() != synset.preferredTermLinks.size()) {
            throw new IllegalArgumentException("[${synset.id}] " +
                    "Number of preferred terms (${synset.preferredTermLinks.size()}) " +
                    "is not equal to number of languages in " +
                    "synset (${languages.size()})")
        }
    }

    /**
     * If the synset category is the category 'Unknown' there should be no
     * other category or an exception will be thrown.
     * Checks for duplicate links, duplicated listed category and checks
     * if the synset preferredCategory is part of the synset categories. If
     * some of them fail an exception will be thrown.
     * @throws IllegalArgumentException
     */
    private void validateCategoryLinks() {
        List categoryLinkSet = []
        List categories = []
        if (synset.preferredCategory?.categoryName == CATEGORY_UNKNOWN
                && synset.categoryLinks.size() > 1) {
            throw new IllegalArgumentException("[${synset.id}] If Category " +
                    "is $CATEGORY_UNKNOWN there should be no other category")
        }

        for (categoryLink in synset.categoryLinks) {
            if (!categoryLinkSet.contains(categoryLink)) {
                categoryLinkSet.add(categoryLink)
            } else {
                throw new IllegalArgumentException("[${synset.id}] " +
                        "Duplicate CategoryLink: $categoryLink")
            }
            if (!categories.contains(categoryLink.category)) {
                categories.add(categoryLink.category)
            } else {
                throw new IllegalArgumentException("[${synset.id}] Category: " +
                        "'${categoryLink.category}' listed twice or more")
            }
        }
        /*if (synset.preferredCategory) {
          if (!categories.contains(synset.preferredCategory)) {
            throw new IllegalArgumentException("[${synset.id}] Preferred " +
                    "Category '${synset.preferredCategory}' is not linked to synset")
          }
        }*/
    }

    /**
     * Checks if the sysnet is linked to another synset twice. If so
     * an exception will be thrown.
     * @throws IllegalArgumentException
     */
    private void validateSynsetLinks() {
        List synsetLinkSet = []
        for (synsetLink in synset.synsetLinks) {
            if (!synsetLinkSet.contains(synsetLink)) {
                synsetLinkSet.add(synsetLink)
            } else {
                throw new IllegalArgumentException("[${synset.id}] " +
                        "Duplicate SynsetLink: $synsetLink")
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