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
        "[ 0-9a-zA-ZöäüÖÄÜßëçèéêáàóòÈÉÁÀÓÒãñíîş\\{\\}\\\"\\?\\*=()\\-\\+/.,'_:<>;%°" +
            "\\!\\[\\]²³&#αΑβΒγΓδΔεΕζΖηΗθΘιΙκΚλΛμΜνΝξΞοΟπΠρΡσΣτΤυΥφΦχΧψΨωΩœ]+"

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
        userComment(nullable:true, size: 0..255)
        wordGrammar(nullable:true)
        normalizedWord(nullable:true)
        originalId(nullable:true)
    }

    static mapping = {
    }

    Term() {
        // needed for test cases
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

    void deleteTermLink() {
        List termLinks = TermLink.withCriteria {
            or {
                eq('term', this)
                eq('targetTerm', this)
            }
        }
        if (termLinks.size() > 1) {
            throw new Exception("More than one term link for term ${this}: ${termLinks}")
        }
        if (termLinks.size() == 1) {
            def termLink = termLinks.get(0)
            removeFromTermLinks(termLink)
            termLink.delete(flush:true)
        }
    }

    List termLinkInfos() {
        // a link always goes into one direction, but we also need
        // the other direction (eg. hot->cold, cold->hot):
        List termLinkInfos = []
        for (TermLink link : termLinks) {
            try {
                termLinkInfos.add(new TermLinkInfo(link.id, this, link.targetTerm, link.linkType.linkName, true))
            } catch (org.hibernate.ObjectNotFoundException e) {
                // can happen with deleted terms before the 2012-04-21 fix
                log.error("Could not get term link #${link.id} for term '${word}' in synset '${synset}'")
            }
        }
        List reverseLinks = TermLink.findAllByTargetTerm(this)
        for (TermLink link : reverseLinks) {
            termLinkInfos.add(new TermLinkInfo(link.id, this, link.term, link.linkType.otherDirectionLinkName, false))
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
     * Log to both logging system and database. Returns true
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
            throw new NullPointerException("logInfo may not be null")
        }
        TermValidator validator = new TermValidator(this)
        validator.extendedValidate()
        if (this.synset.extendedValidate(extendedValidateVar) && save()) {
            // log to database:
            log(logInfo)
            return true
        } else {
            log.warn("could not save term '${word}' to synset ${synset.id}: ${errors}")
            return false
        }
    }

    void extendedValidate() {
        TermValidator validator = new TermValidator(this)
        validator.extendedValidate()
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
