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

import com.vionto.vithesaurus.Term

class TermValidator {

    Term term
    String word

    /**
     * The constructor of the class.
     * @param The term to be validated extended.
     */
    public TermValidator(Term t) {
        this.term = t
        this.word = t.word
    }

    /**
     * A constructor for validatidation of not yet stored terms.
     * @param A string to be validated.
     */
     public TermValidator(String w) {
        this.word = w
     }

    /**
     * Extended Validation for a term.
     * @return True, if validation didn't throw an exception.
     */
    public boolean extendedValidate() {
        assert (word.length() >= 1)
        if (term) {
            validateWordForm()
        }
        validateBrackets()
        validateTermRegex()
        return true
    }

    /**
     * Checks the correct word form of a term.
     * @throws IllegalArgumentException
     */
    private void validateWordForm() {
        if (term.isShortForm && term.isAcronym) {
            throw new IllegalArgumentException("[$word] Should not be " +
                    "both: shortform and acronym")
        }
    }

    /**
     * Checks if all opening brackets are properly closed. If not an
     * exception will be thrown.
     * @throws IllegalArgumentException
     */
    private void validateBrackets() {
        int parenthesis = word.count("(") - word.count(")")
        int square = word.count("[") - word.count("]")
        int braces = word.count("{") - word.count("}")
        //int arrowBrackets = word.count("<") - word.count(">")
        if (parenthesis != 0 || square != 0 || braces != 0) {
            throw new IllegalArgumentException("[$word] Number of opening and " +
                    "closing brackets must be the same ")
        }
    }

    /**
     * Copies of the regex that are checked with a validator in the
     * term domain class.
     * @throws IllegalArgumentException
     */
    private void validateTermRegex() {

        if(word.matches("\\s.*") || word.matches(".*\\s")) {
            throw new IllegalArgumentException("[$word] Term should not start or end with whitespace")
        }
        if (word.matches(".*-\\s[A-Z].*") || word.matches(".*-\\s[1-9].*")) {
            throw new IllegalArgumentException("[$word] No hyphen followed by space followed by uppercaseletter or followed by digit")
        }
        if (word.matches(".*\\s{2}.*")) {
            throw new IllegalArgumentException("[$word] Term should not contain double-white-space")
        }

    }
}