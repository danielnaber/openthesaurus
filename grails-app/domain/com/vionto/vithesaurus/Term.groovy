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

import com.vionto.vithesaurus.tools.StringTools
import org.hibernate.ObjectNotFoundException;

/**
 * A term - terms are what synsets are made of.
 */
class Term implements Comparable, Cloneable {

    def grailsApplication

    Synset synset           // synset to which this term belongs
    String word
    String normalizedWord	// normalized version of 'word' for searches (e.g. parentheses and their content removed)
    String normalizedWord2	// normalized version of 'word' for searches (e.g. parentheses around words removed)
    Language language
    TermLevel level             // language level like "colloquial"
    String userComment
    Integer originalId		// id from PHP version of OpenThesaurus (if data was imported)

    /** Allowed term expression. TODO: read from configuration */
    final static String TERM_REGEXP =
        "[ 0-9a-zA-ZöäüÖÄÜßëçèéêáàóòÈÉÁÀÓÒãñíîş\\{\\}\\\"\\?\\*=()\\-\\+/.,'_:<>;%‰°" +
            "\\!\\[\\]²³₀₁₂₃₄₅₆₇₈₉Œ€&#ūαΑβΒγΓδΔεΕζΖηΗθΘιΙκΚλΛμΜνΝξΞοΟπΠρΡσΣτΤυΥφΦχΧψΨωΩάΆέΈίΊήΉύΎϊϋΰΐœţÊ]+"

    static belongsTo = [synset:Synset]
    
    static hasMany = [termLinks:TermLink, tags:Tag]

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
        userComment(nullable:true, size: 0..400)
        normalizedWord(nullable:true)
        normalizedWord2(nullable:true)
        originalId(nullable:true)
    }

    static Tag specialTag
    static boolean specialTagIsSet

    Term() {
        // needed for test cases
    }

    Term(String word, Language language, Synset synset) {
        this.word = word.trim()
        String normalizedWord = StringTools.normalize(this.word)
        if (this.word != normalizedWord) {
          this.normalizedWord = normalizedWord
        }
        String normalizedWord2 = StringTools.normalize2(this.word)
        if (this.word != normalizedWord2) {
          this.normalizedWord2 = normalizedWord2
        }
        this.language = language
        this.synset = synset
    }

    String toString() {
        return word
    }

    void deleteTermLink(TermLink termLink) {
        removeFromTermLinks(termLink)
        termLink.delete(flush:true)
    }

    List termLinkInfos() {
        // a link always goes into one direction, but we also need
        // the other direction (eg. hot->cold, cold->hot):
        List termLinkInfos = []
        for (TermLink link : termLinks) {
            if (!link.term.synset.isVisible) {
                continue
            }
            try {
                termLinkInfos.add(new TermLinkInfo(link.id, this, link.targetTerm, link.linkType.linkName, true))
            } catch (ObjectNotFoundException ignore) {
                // can happen with deleted terms before the 2012-04-21 fix
                log.error("Could not get term link #${link.id} for term '${word}' in synset '${synset}'")
            }
        }
        List reverseLinks = TermLink.findAllByTargetTerm(this)
        for (TermLink link : reverseLinks) {
            if (!link.term.synset.isVisible) {
                continue
            }
            termLinkInfos.add(new TermLinkInfo(link.id, this, link.term, link.linkType.otherDirectionLinkName, false))
        }
        return termLinkInfos
    }

    /**
     * A String representation with all important properties (also used for diffing items).
     */
    String toDetailedString() {
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
        if (tags) {
            List sortedTags = new ArrayList(tags)
            Collections.sort(sortedTags)
            sb.append(" || tags=")
            sb.append(sortedTags.join("|"))
        }
        return sb.toString()
    }

    /**
     * Used to first sort by language, then term level sort value,
     * then by term (alphabetically) as a final criterion.
     */
    int compareTo(Object other) {
        if (!specialTagIsSet) {
            def topSortTag = grailsApplication.config.thesaurus.topSortTag
            if (topSortTag) {
                specialTag = Tag.findByName(topSortTag)
            }
            specialTagIsSet = true  // only init once for better performance
        }
        if (other.language == language) {
            if (specialTag) {
                def term1prefer = tags?.contains(specialTag)
                def term2prefer = other.tags?.contains(specialTag)
                if (term1prefer && !term2prefer) {
                    return -1
                } else if (!term1prefer && term2prefer) {
                    return 1
                } else if (term1prefer && term2prefer) {
                    return word.compareTo(other.word)
                }
            }
            return compareByLevelAndName(this, other)
        } else {
            return language.id - other.language.id
        }
    }

    def compareByLevelAndName(Term term1, Term term2) {
        int sortValue = term1.level?.sortValue ? term1.level.sortValue : 0
        int otherSortValue = term2.level?.sortValue ? term2.level.sortValue : 0
        if (sortValue == otherSortValue) {
            String normalizedWord = StringTools.normalizeForSort(term1.word)
            String otherNormalizedWord = StringTools.normalizeForSort(term2.word)
            int compare = normalizedWord.compareToIgnoreCase(otherNormalizedWord)
            if (compare == 0) {
                // force stable order on words that only differ in case
                return term1.word.compareTo(term2.word)
            } else {
                return compare
            }
        } else {
            return sortValue - otherSortValue
        }
    }

    Object clone() {
        def clone = super.clone()
        clone.id = null
        clone.tags = []
        def tagsToAdd = []
        for (tag in tags) {
            tagsToAdd.add(Tag.get(tag.id))
        }
        for (tag in tagsToAdd) {
            clone.addToTags(tag)
        }
        return clone
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
        return withCriteria {
            or {
                eq('word', word)
                eq('word', normalizedWord)
                // we'd need more to be correct but these are not active for performance reasons:
                //eq('word', normalizedWord2)
                //eq('normalizedWord', normalizedWord)
                //eq('normalizedWord2', normalizedWord2)
            }
            synset {
                eq('isVisible', true)
            }
        }
    }

    void addTags(def session, String... tagNames) {
        for (tag in tagNames) {
            Tag existingTag = Tag.findByName(tag)
            if (existingTag) {
                addToTags(existingTag)
            } else if (tag) {
                Tag newTag = new Tag()
                newTag.name = tag
                newTag.created = new Date()
                newTag.createdBy = session.user.realName
                newTag.save(flush: true, failOnError: true)
                addToTags(newTag)
            }
        }
    }

    static int countVisibleTerms() {
        def c = createCriteria()
        int count = c.count {
            synset {
                eq('isVisible', true)
            }
        }
        return count
    }

    static int countVisibleUniqueTerms() {
        def count = withCriteria {
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
