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

import org.apache.commons.lang.StringUtils;

/**
 * A set of terms and other meta information. This makes
 * up a meaning / concept.
 */
class Synset implements Cloneable {

    boolean isVisible
    Integer originalId		// id from PHP version of OpenThesaurus (if data was imported)
    // NOTE: keep clone() in sync when adding properties!

    static hasMany = [terms:Term,
                      synsetLinks:SynsetLink,
                      categoryLinks:CategoryLink,
                      userEvents:UserEvent]

    static constraints = {
        originalId(nullable:true)
    }

    /**
     * Create a new empty but visible synset.
     */
    Synset() {
        terms = new HashSet()
        isVisible = true
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
    }

    /**
     * Remove the given term from this synset.
     * @throws IllegalArgumentException if term doesn't exist in this synset
     */
    void removeTerm(Term term) {
        if (!terms.contains(term)) {
            throw new IllegalArgumentException("Synset doesn't contain term: ${term}")
        }
        log.info("Deleting term: ${term}")
        for (termLink in term.termLinks) {
            termLink.delete()
        }
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
            if (l.targetSynset.isVisible) {
                allLinks.add(l)
            }
        }
        for (link in synsetLinks) {
            if (link.targetSynset.isVisible) {
                allLinks.add(link)
            }
        }
        return allLinks.sort()
    }

    // NOTE: you need to adapt Diff.java if you make changes here
    String toString() {
        if (terms.size() == 0) {
          return "[empty]"
        }
        return sortedTerms().join(" · ")
    }

    String toUnsortedString() {
        if (terms.size() == 0) {
          return "[empty]"
        }
        return terms.join(" · ")
    }

    /**
     * Detailed string representation used for showing differences in the
     * UserEvent view.
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

    private String toShortStringInternal(int maxSize = 3, boolean addEllipses, boolean addLevel) {
        def terms = sortedTerms()
        if (terms.size() == 0) {
          return "[empty]"
        }
        List enhancedTerms = []
        for (term in terms) {
          List metaInfos = []
          if (term.level && addLevel) {
              metaInfos.add(term.level.shortLevelName)
          }
          List tags = term.tags.sort()
          for (tag in tags) {
              metaInfos.add(tag.shortName ? tag.shortName : tag.name)
          }
          if (metaInfos.size() > 0) {
              enhancedTerms.add(term.word + " (" + StringUtils.join(metaInfos, ", ") + ")")
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
              // additionally, log to logging system:
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
        Synset clone = super.clone()       // will clone trivial types
        // TODO: also make a real deep copy here via copy constructor:
        clone.terms = new HashSet(terms)
        clone.categoryLinks = new HashSet(categoryLinks)
        // calling clone() is not enough:
        clone.synsetLinks = []
        for (link in synsetLinks) {
            clone.addSynsetLink(new SynsetLink(link))
        }
        return clone
    }

}
