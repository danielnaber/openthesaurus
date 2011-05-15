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

import com.vionto.vithesaurus.tools.StringTools;

/**
 * A term - terms are what synsets are made of.
 */
class Term implements Comparable, Cloneable {

    Synset synset           // synset to which this term belongs
    String word
    String normalizedWord	// normalized version of 'word' for searches (e.g. parentheses removed)
    boolean isShortForm     // is the word an abbreviation?
    boolean isAcronym       // is the word an acronym (e.g. AIDS)
    Language language
    TermLevel level             // language level like "colloquial"
    WordGrammar wordGrammar     // base form, plural form, etc.
    String userComment
    Integer originalId		// id from PHP version of OpenThesaurus (if data was imported)

    /** Allowed term expression. TODO: read from configuration */
    final static String TERM_REGEXP =
        "[ 0-9a-zA-ZöäüÖÄÜßëçèéáàóòÈÉÁÀÓÒãñíş\\{\\}\\\"\\?\\*=()\\-\\+/.,'_:<>;%°" +
            "\\!\\[\\]&#αΑβΒγΓδΔεΕζΖηΗθΘιΙκΚλΛμΜνΝξΞοΟπΠρΡσΣτΤυΥφΦχΧψΨωΩ]+"

    static belongsTo = [synset:Synset]
    
    static hasMany = [termLinks:TermLink]

    static constraints = {
        word(matches:TERM_REGEXP,minSize:1,
            validator: {
                if(it.matches("\\s.*") || it.matches(".*\\s") || // should not start or end with whitespace
                        it.matches(".*-\\s[A-Z].*") || // no hyphen followed by space followed by uppercase letter
                        it.matches(".*-\\s[1-9].*") || // or a hyphen followed by digit
                        it.matches(".*\\s{2}.*")) { // and no double-white-space
                    return ['invalid.term', it, it]
                }
            }
        )
        level(nullable:true)
        userComment(nullable:true)
        wordGrammar(nullable:true)
        normalizedWord(nullable:true)
        originalId(nullable:true)
    }

    static mapping = {
        //id generator:'sequence', params:[sequence:'term_seq']
    }

    /*
    TODO: create db index?
    static mapping = {
        table 'term'
        columns {
            word column:'word', index:'word_index'
        }
    }*/

    Term() {
        // TODO: test cases fail if we remove this :-(
    }

    Term(String word, Language language, Synset synset) {
        this.word = word.trim()
        String normalizedWord = StringTools.normalize(this.word)
        if (this.word != normalizedWord) {
          this.normalizedWord = normalizedWord
        }
        this.language = language
        this.synset = synset
    }

    String toString() {
        return word
    }
    
    List termLinkInfos() {
        // a link always goes into one direction, but we also need
        // the other direction (eg. hot->cold, cold->hot):
        List termLinkInfos = []
        for (TermLink link : termLinks) {
            termLinkInfos.add(new TermLinkInfo(this, link.targetTerm, link.linkType.linkName, true))
        }
        List reverseLinks = TermLink.findAllByTargetTerm(this)
        for (TermLink link : reverseLinks) {
            termLinkInfos.add(new TermLinkInfo(this, link.term, link.linkType.otherDirectionLinkName, false))
        }
        return termLinkInfos
    }

    /**
     * A String representation with all important properties.
     */
    String toDetailedString() {
        //return "${word} || abbrev=${isShortForm} | acronym=${isAcronym} | " +
        //    "language=${language.shortForm} | form=${wordGrammar} | " +
        //    "comment=${userComment}"
        StringBuilder sb = new StringBuilder()
        sb.append(word)
        if (level) {
          sb.append(" || level=")
          sb.append(level)
        }
        if (userComment) {
          sb.append(" || comment=")
          sb.append(userComment)
        }
        return sb.toString()
    }

    /**
     * Used to first sort by language, then by term as a second criterion.
     */
    int compareTo(Object other) {
        if (other.language == language) {
            String normalizedWord = StringTools.normalizeForSort(word)
            String otherNormalizedWord = StringTools.normalizeForSort(other.word)
            int compare = normalizedWord.compareToIgnoreCase(otherNormalizedWord)
            if (compare == 0) {
              // force stable order on words that only differ in case
              return word.compareTo(other.word)
          } else {
              return compare
          }
        } else {
            return language.id - other.language.id
        }
    }
    
    Object clone() {
        return super.clone()
    }

    /**
     * Save and log to both logging system and database. Returns true
     * @throws RuntimeException if logging to database didn't work
     */
    def log(LogInfo logInfo) {
        UserTermEvent event = new UserTermEvent(this, logInfo)
        if (!(event.validate() && event.save())) {
            String msg = "Log entry validation or save failed: ${event.errors}"
            throw new RuntimeException(msg)
        }
        // additionally, log to logging system:
        log.info(event)
    }

    /**
     * Save and log to both logging system and database. Returns
     * true on success, false otherwise.
     * @throws RuntimeException if logging to database didn't work
     */
    boolean saveAndLog(LogInfo logInfo) {
        return saveAndLog(logInfo, true)
    }

    /**
     * Save and log to both logging system and database. Returns
     * true on success, false otherwise.
     * @param extendedValidateVar use false to deactivate strict validation
     * @throws RuntimeException if logging to database didn't work
     */
    boolean saveAndLog(LogInfo logInfo, boolean extendedValidateVar) {
        if (logInfo == null) {
            throw new NullPointerException("loginfo may not be null")
        }
        if (extendedValidate() &&
                this.synset.extendedValidate(extendedValidateVar) && save()) {
            // log to database:
            log(logInfo)
            return true
        } else {
            log.warn("could not save term '${word}' to synset ${synset.id}: ${errors}")
            return false
        }
    }

    private boolean extendedValidate() {
        TermValidator validator = new TermValidator(this)
        return validator.extendedValidate()
    }

    /**
     * List terms with the same word as this one.
     */
    List listHomonyms() {
        return Term.withCriteria {
            eq('word', word)
            synset {
                eq('isVisible', true)
            }
        }
    }

    /**
     * List terms with the same word as this one, but only those
     * which are in the same section as this one.
     */
    List listHomonymsInSection() {
        return Term.withCriteria {
            eq('word', word)
            synset {
                eq('isVisible', true)
                eq('section', synset.section)
            }
        }
    }

    static int countVisibleTerms() {
        def c = Term.createCriteria()
        int count = c.count {
            synset {
                eq('isVisible', true)
            }
        }
        return count
    }

    static int countVisibleUniqueTerms() {
        def count = Term.withCriteria {
            synset {
                eq('isVisible', true)
            }
            projections {
                countDistinct("word")
            }
        }
        return count.get(0)
    }
    
}
