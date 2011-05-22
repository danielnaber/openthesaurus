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
package com.vionto.vithesaurus;

import com.vionto.vithesaurus.SynsetValidator

/**
 * A set of terms and other meta information. This makes
 * up a meaning / concept.
 */
class Synset implements Cloneable {

    boolean isVisible
    Source source   // Note: there's also sources for cases there are more sources
    String originalURI      // used to track the original source and its ID
    String userComment
    // The preferred term for the synset (not per language). This causes
    // redundancy, but we need it to sort by preferred term (also see
    // PREFERRED_TERM_LANGS):
    String synsetPreferredTerm
    Category preferredCategory
    Section section
    int evaluation
    Integer importStatus    // != null -> automatically imported
    Integer originalId		// id from PHP version of OpenThesaurus (if data was imported)
    // NOTE: keep clone() in sync when adding properties!

    static mapping = {
        //id generator:'sequence', params:[sequence:'synset_seq']
        userComment(type:'text')
    }

    static hasMany = [terms:Term,
                      semTypeLinks:SemTypeLink,
                      synsetLinks:SynsetLink,
                      synsetLinkSuggestions:SynsetLinkSuggestion,
                      categoryLinks:CategoryLink,
                      userEvents:UserEvent,
                      preferredTermLinks:PreferredTermLink,
                      sources:SourceLink]

    static constraints = {
        userComment(nullable:true)
        source(nullable:true)
        originalURI(nullable:true)
        section(nullable:true)
        synsetPreferredTerm(nullable:true)
        importStatus(nullable:true)
        originalId(nullable:true)
        preferredCategory(nullable:true)
    }

    // prepended to get a display "id":
    final static String URI_PREFIX = ""

    // the preferred term is taken from this languages (i.e. English is used
    // if there is an English term, only then German is used etc):
    final static def PREFERRED_TERM_LANGS = ["en", "de", "fr", "it"]

    /**
     * Create a new empty but visible synset.
     */
    Synset() {
        terms = new HashSet()
        isVisible = true
        evaluation = 0
    }

    /**
     * Add the given term to this synset.
     * @throws IllegalArgumentException if a term with the same word
     *  (case-sensitive) already exists in this synset
     */
    void addTerm(Term term) {
        if (containsWord(term.word)) {
            throw new IllegalArgumentException("Synset already contains word: ${term.word}")
        }
        terms.add(term)
        if (terms.size() == 1) {
            // the first term, so make it the preferred term:
            setPreferredTerm(term.language, term)
        }
    }

    /**
     * Remove the given term from this synset.
     * @throws IllegalArgumentException if term doesn't exist in this synset
     */
    void removeTerm(Term term) {
        if (!terms.contains(term)) {
            throw new IllegalArgumentException("Synset doesn't contain term: ${term}")
        }
        Set sameLanguageTerms = terms.findAll { it.language == term.language }
        Term prefTerm = preferredTerm(term.language)
        if (prefTerm && prefTerm.word == term.word) {
            // we usually cannot delete the preferred term, unless
            // it is the only term in its language:
            if (sameLanguageTerms.size() == 1) {
                PreferredTermLink toDelete = null
                for (link in preferredTermLinks) {
                    if (link.term == term) {
                        toDelete = link
                        break
                    }
                }
                if (toDelete) {
                    preferredTermLinks.remove(toDelete)
                    toDelete.delete()
                }
            } else {
                throw new IllegalArgumentException("Cannot delete the preferred term: ${term}")
            }
        }
        log.info("Deleting term: ${term}")
        terms.remove(term)
        term.delete()
    }

    /**
     * Add the given category link to this synset.
     * @throws IllegalArgumentException if this categoryLink already exists
     */
    void addCategoryLink(CategoryLink categoryLink) {
        if (categoryLinks && categoryLinks.contains(categoryLink)) {
            throw new IllegalArgumentException("Synset already contain category " +
                    "link: ${categoryLink}")
        }
        if (!categoryLinks) {
            categoryLinks = []
        }
        categoryLinks.add(categoryLink)
        if (categoryLinks.size() == 1) {
            // first category, make it the preferred category:
            preferredCategory = categoryLink.category
        }
    }

    /**
     * Remove the given category link from this synset.
     * @throws IllegalArgumentException if this categoryLink doesn't exists
     * TODO: rename to removeCategoryLink
     */
    void removeLink(CategoryLink categoryLink) {
        if (!categoryLinks.contains(categoryLink)) {
            throw new IllegalArgumentException("Synset doesn't contain category " +
                    "link: ${categoryLink}")
        }
        log.info("Deleting category link: ${categoryLink}")
        categoryLinks.remove(categoryLink)
        categoryLink.delete()
    }

    /**
     * Add the given synset link to this synset.
     * @throws IllegalArgumentException if this synsetLink already exists
     */
    void addSynsetLink(SynsetLink synsetLink) {
        if (synsetLinks && synsetLinks.contains(synsetLink)) {
            throw new IllegalArgumentException("Synset already contain synset " +
                    "link: ${synsetLink}")
        }
        if (!synsetLinks) {
            synsetLinks = []
        }
        synsetLinks.add(synsetLink)
    }

    /**
     * Remove the given link from this synset.
     * @throws IllegalArgumentException if link doesn't exist in this synset
     */
    void removeLink(SynsetLink synsetLink) {
        if (!synsetLinks.contains(synsetLink)) {
            throw new IllegalArgumentException("Synset doesn't contain link: ${synsetLink}")
        }
        log.info("Deleting synset link: ${synsetLink}")
        synsetLinks.remove(synsetLink)
        synsetLink.delete()
    }

    /**
     * Add the given synset link suggestion to this synset.
     * @throws IllegalArgumentException if this synsetLinkSuggestion already exists
     */
    void addSynsetLinkSuggestion(SynsetLinkSuggestion synsetLinkSuggestion) {
        if (synsetLinkSuggestion && synsetLinkSuggestions.contains(synsetLinkSuggestion)) {
            throw new IllegalArgumentException("Synset already contain synset " +
                    "link suggestion: ${synsetLinkSuggestion}")
        }
        if (!synsetLinkSuggestions) {
            synsetLinkSuggestions = []
        }
        log.info("Adding synset link suggestion: ${synsetLinkSuggestion}")
        synsetLinkSuggestions.add(synsetLinkSuggestion)
    }

    /**
     * Remove the given linkSuggestion from this synset.
     * @throws IllegalArgumentException if linkSuggestion doesn't exist in this synset
     */
    void removeLink(SynsetLinkSuggestion synsetLinkSuggestion) {
        if (!synsetLinkSuggestions.contains(synsetLinkSuggestion)) {
            throw new IllegalArgumentException("Synset doesn't contain link suggestion:"
                    + "${synsetLinkSuggestion}")
        }
        log.info("Deleting synset link suggestion: ${synsetLinkSuggestion}")
        synsetLinkSuggestions.remove(synsetLinkSuggestion)
        synsetLinkSuggestion.delete()
    }

    /**
     * Sets a term as the preferred term for the given language,
     * removing the old preferred term if there was one.
     */
    void setPreferredTerm(Language lang, Term term) {
        PreferredTermLink linkToDelete = null
        // first delete existing preferred term for this language, if any:
        for (link in preferredTermLinks) {
            if (link.language == lang) {
                linkToDelete = link
                break
            }
        }
        if (linkToDelete) {
            linkToDelete.delete()
            preferredTermLinks.remove(linkToDelete)
        }
        // now add the new preferred term:
        addToPreferredTermLinks(new PreferredTermLink(language:lang, term:term))
        // set the non-language-specific preferred Term by taking it
        // from the "best" language we have:
        updatePreferredTerm()
    }

    /**
     * Set the preferred term used for sorting to one of the preferred
     * terms per language, preferring English over German etc.
     */
    void updatePreferredTerm() {
        for (bestLanguage in PREFERRED_TERM_LANGS) {
            Language prefTermLang = Language.findByShortForm(bestLanguage)
            if (prefTermLang && hasPreferredTerm(prefTermLang)) {
                synsetPreferredTerm = preferredTerm(prefTermLang)
                log.debug("preferred term for ${id} set to ${synsetPreferredTerm}")
                break
            }
        }
    }

    /**
     * Gets the preferred term.
     */
    String preferredTerm() {
        return synsetPreferredTerm
    }

    /**
     * Gets all terms expect the preferred term.
     */
    List otherTerms() {
        String preferredTerm = preferredTerm()
        List otherTermList = []
        for (term in terms) {
            if (preferredTerm == null) {
                otherTermList.add(term)
            } else if (term.word != preferredTerm) {
                otherTermList.add(term)
            }
        }
        return otherTermList
    }

    /**
     * Returns true if the synset contains the given term (case-sensitive).
     */
    boolean containsWord(String word) {
        for (term in terms) {
          if (term.word == word) {
            return true
          }
        }
        return false
    }

    /**
     * Returns true if the synset contains the given term (case-insensitive).
     */
    boolean containsWordIgnoreCase(String word) {
        word = word.toLowerCase()
        for (term in terms) {
          if (term.word.toLowerCase() == word) {
            return true
          }
        }
        return false
    }

    /**
     * Returns true if the synset has a preferred term for the given language.
     */
    boolean hasPreferredTerm(Language lang) {
        for (link in preferredTermLinks) {
            if (link.language == lang) {
                return true
            }
        }
        return false
    }

    /**
     * Gets the preferred term for a given language. Returns null if there
     * is not preferred term for for that language.
     */
    Term preferredTerm(Language language) {
        for (link in preferredTermLinks) {
            if (link.language == language) {
                return link.term
            }
        }
        return null
    }

    /**
     * Return true if this synset contains the given link to another synset.
     */
    boolean containsSynsetLink(SynsetLink link) {
        for (synsetLink in synsetLinks) {
            if (link == synsetLink) {
                return true
            }
        }
        return false
    }

    /**
     * Return true if this synset contains the given link to a category.
     */
    boolean containsCategoryLink(CategoryLink link) {
        for (categoryLink in categoryLinks) {
            if (link == categoryLink) {
                return true
            }
        }
        return false
    }

    /**
     * Get a sorted list of all terms.
     */
    List sortedTerms() {
        return terms.sort()
    }

    /**
     * Get a sorted list of all links to and from other synsets.
     */
    List sortedSynsetLinks() {
        List allLinks = new ArrayList()
        List incomingLinks = SynsetLink.findAllByTargetSynset(this)
        for (incomingLink in incomingLinks) {
            // add links that point to this synset with its type
            // reversed to the other direction (e.g. hypernym -> hyponym):
            LinkType tempLinkType =
                new LinkType(linkName: incomingLink.linkType.otherDirectionLinkName)
            SynsetLink l = new SynsetLink(incomingLink)
            l.id = incomingLink.id
            l.linkType = tempLinkType
            // change direction:
            l.synset = incomingLink.targetSynset
            l.targetSynset = incomingLink.synset
            allLinks.add(l)
        }
        allLinks.addAll(synsetLinks)
        return allLinks.sort()
    }

    /**
     * Get a sorted list of all links to other synsets.
     */
    List sortedSynsetLinkSuggestions() {
        List allLinks = new ArrayList()
        List incomingLinks = SynsetLinkSuggestion.findAllByTargetSynset(this)
        for (incomingLink in incomingLinks) {
            // add links that point to this synset with its type
            // reversed to the other direction (e.g. hypernym -> hyponym):
            LinkType tempLinkType =
                new LinkType(linkName: incomingLink.linkType.otherDirectionLinkName)
            SynsetLinkSuggestion l = new SynsetLinkSuggestion(incomingLink)
            l.id = incomingLink.id
            l.linkType = tempLinkType
            // change direction:
            l.synset = incomingLink.targetSynset
            l.targetSynset = incomingLink.synset
            allLinks.add(l)
        }
        allLinks.addAll(synsetLinkSuggestions)
        return allLinks.sort()
    }

    // not called "getGeneratedURI" because Grails assumes a property then
    // and gets confused:
    String generatedURI() {
        return URI_PREFIX + id
    }

    // NOTE: you need to adapt Diff.java if you make changes here
    String toString() {
        if (terms.size() == 0) {
          return "[empty]"
        }
        return sortedTerms().join(" · ")
    }

    /**
     * Detailed string representation used for showing differences in the
     * UserEvent view, thus doesn't contain properties that cannot
     * be modified like "source" etc.
     */
    String toDetailedString() {
        // the "|" at the beginning works around a bug in the diff
        // algorithm with additions at the start of the string:
        StringBuilder sb = new StringBuilder("| ")
        if (terms.size() == 0) {
          sb.append("[empty]")
        } else {
          int pos = 0
          for (term in terms.sort()) {
            sb.append(term)
            if (term.level) {
              sb.append(" (")
              sb.append(term.level.shortLevelName)
              sb.append(")")
            }
            if (pos < terms.size() - 1) {
              sb.append(" · ")
            }
            pos++
          }
        }
        if (isVisible) {
          sb.append(" || visible")
        } else {
          sb.append(" || INVISIBLE")
        }
        if (userComment) {
          sb.append(" || comment=${userComment}")
        }

        /*if (preferredTermLinks) {
            sb.append(" preferredTerms=")
            int prefLinkCount = 0
            for (link in preferredTermLinks.sort()) {
                if (prefLinkCount > 0) {
                    sb.append("|")
                }
                // show eg. "en:house|de:Haus|"
                sb.append(link.language.shortForm)
                sb.append(":")
                sb.append(link.term)
                prefLinkCount++
            }
            sb.append(" ||")
        }*/
        //sb.append(" preferredCategory=")
        //sb.append(preferredCategory)
        //sb.append(" ||")
        //sb.append(" section=")
        //sb.append(section)
        //sb.append(" ||")

        int categoryLinkCount = 0
        if (categoryLinks && categoryLinks.size() > 0) {
          sb.append(" || categories=")
          for (categoryLink in categoryLinks.sort()) {
            if (categoryLinkCount > 0) {
                sb.append("|")
            }
            sb.append(categoryLink.category)
            categoryLinkCount++
          }
        }
        return sb.toString()
    }

    private String getLinkString(def links, int evalMode) {
        StringBuilder sb = new StringBuilder()
        for (link in links.sort()) {
            if (link.evaluationStatus == evalMode) {
                // show eg. "hypernym:blah | hypernym:blubb |"
                sb.append(link.linkType)
                sb.append(":")
                if (link.targetSynset.synsetPreferredTerm) {
                    sb.append(link.targetSynset.synsetPreferredTerm)
                } else {
                    sb.append(link.targetSynset.toShortString())
                }
                sb.append(" | ")
            }
        }
        return sb.toString()
    }

    private String toShortStringInternal(int maxSize = 3, boolean addEllipses, boolean addLevel) {
        def terms = sortedTerms()
        if (terms.size() == 0) {
          return "[empty]"
        }
        List enhancedTerms = []
        for (term in terms) {
          if (term.level && addLevel) {
              enhancedTerms.add(term.word + " (" + term.level.shortLevelName + ")")
          } else {
            enhancedTerms.add(term.word)
          }
          if (enhancedTerms.size() >= maxSize) {
              break
          }
        }
        String termStr = enhancedTerms.join(" · ")
        String suffix = ""
        if (addEllipses) {
          suffix = terms.size() > maxSize ? " · ..." : ""
        }
        return termStr + suffix
    }

    /**
     * A string representation that includes the short term level (if any), limited by the number of terms (default: 3)
     */
    String toShortStringWithShortLevel(int maxSize = 3, boolean addEllipses) {
        return toShortStringInternal(maxSize, addEllipses, true)
    }

    /**
     * A string representation limited by the number of terms (default: 3)
     */
    String toShortString(int maxSize = 3, boolean addEllipses = true) {
        return toShortStringInternal(maxSize, addEllipses, false)
    }

    /**
     * Save and log to both logging system and database. Returns true
     * true on success, false otherwise.
     */
    boolean saveAndLog(LogInfo logInfo) {
        return saveAndLog(logInfo, true)
    }

    /**
     * Save and log to both logging system and database. Returns true
     * true on success, false otherwise.
     * @param extendedValidateVar use false to deactivate strict validation
     */
    boolean saveAndLog(LogInfo logInfo, boolean extendedValidateVar) {
        if (logInfo == null) {
            throw new NullPointerException("loginfo may not be null")
        }
        if (extendedValidate(extendedValidateVar) && save()) {
            // log to database:
            UserSynsetEvent event = new UserSynsetEvent(this, logInfo)
              if (!(event.validate() && event.save())) {
                  log.error("Log entry validation failed: ${event.errors}")
                  return false
              }
              // additonally, log to logging system:
              log.info("UserEvent: " + event)
              return true
        } else {
            log.warn("could not save synset '${this}' with id ${this.id}")
            return false
        }
    }

    public boolean extendedValidate(boolean extendedValidation) {
        SynsetValidator validator = new SynsetValidator(this)
        return validator.extendedValidate(extendedValidation)
    }

    Object clone() {
        Synset clone = new Synset()
        clone = super.clone()       // will clone trivial types
        // TODO: also make a real deep copy here via copy constructor:
        clone.terms = new HashSet(terms)
        clone.preferredTermLinks = new HashSet(preferredTermLinks)
        clone.categoryLinks = new HashSet(categoryLinks)
        // calling clone() is not enough:
        clone.synsetLinks = []
        for (link in synsetLinks) {
            clone.addSynsetLink(new SynsetLink(link))
        }
        clone.semTypeLinks = new HashSet(semTypeLinks)
        return clone
    }

}
