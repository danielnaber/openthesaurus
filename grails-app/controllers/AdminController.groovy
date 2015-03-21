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
import com.vionto.vithesaurus.*
import com.vionto.vithesaurus.tools.StringTools

class AdminController extends BaseController {
    
    def beforeInterceptor = [action: this.&adminAuth]
    
    def index = {
        final int resultLimit = 10
        def latestUsers = ThesaurusUser.withCriteria {
          order("creationDate", "desc")
          maxResults(resultLimit)
        }
        [latestUsers: latestUsers, resultLimit: resultLimit]
    }

    def checkNormalizedTermIntegrity = {
        int count = runTermIntegrityCheck(false)
        render "<br>Checked ${count} terms."
        render "<form action='updateNormalizedTerms' method='post'>"
        render "  <input type='submit' value='Update Normalized Fields'/>"
        render "</form>"
    }

    def updateNormalizedTerms = {
        if (request.method != 'POST') {
            throw new Exception("Please call using method=POST")
        }
        int count = runTermIntegrityCheck(true)
        render "<br>Ran over ${count} terms."
    }

    private int runTermIntegrityCheck(boolean doUpdate) {
        List terms = Term.list()
        int count = 0
        int found = 0
        for (term in terms) {
            if (!term.synset.isVisible) {
                continue
            }
            String normalizedWord = StringTools.normalize(term.word)
            if (normalizedWord == term.word) {
                normalizedWord = null
            }
            if (normalizedWord != term.word && normalizedWord != term.normalizedWord) {
                render "${found}. Error1: <a href='../term/edit/${term.id}'>'${term.normalizedWord}' should be '${normalizedWord}'</a><br />"
                found++
                if (doUpdate) {
                    log.info("Setting normalizedWord '${term.normalizedWord}' to '${normalizedWord}'")
                    term.normalizedWord = normalizedWord
                    term.save(failOnError: true)
                }
            }
            String normalizedWord2 = StringTools.normalize2(term.word)
            if (normalizedWord2 == term.word || normalizedWord2 == normalizedWord) {
                normalizedWord2 = null
            }
            if (normalizedWord2 != term.normalizedWord2) {
                render "${found}. Error2: <a href='../term/edit/${term.id}'>'${term.normalizedWord2}' should be '${normalizedWord2}'</a><br />"
                found++
                if (doUpdate) {
                    log.info("Setting normalizedWord2 '${term.normalizedWord2}' to '${normalizedWord2}'")
                    term.normalizedWord2 = normalizedWord2
                    term.save(failOnError: true)
                }
            }
            count++
            //if (found > 10) { break }
        }
        count
    }

    def tagging() {
        []
    }

    def prepareTagging() {
        Tag newTag = getTag(true)
        List<Term> terms = getTerms()
        Map termToNew = new HashMap()
        for (term in terms) {
            termToNew.put(term, applyPattern(term.word, params.pattern))
        }
        [terms: terms, termToNew: termToNew, newTag: newTag, pattern: params.pattern]
    }

    def doTagging() {
        Tag newTag = getTag(false)
        List<Term> terms = getTerms()
        for (term in terms) {
            term.word = applyPattern(term.word, params.pattern)
            term.addToTags(newTag)
            term.save(failOnError: true)
        }
        flash.message = "Tagged ${terms.size()} terms"
        redirect(action: 'tagging')
    }

    private Tag getTag(boolean allowCreation) {
        if (params.tags.contains(",")) {
            throw new Exception("Words can only be tagged with one tag: ${params.tags}")
        }
        String tagName = params.tags
        Tag newTag = Tag.findByName(tagName)
        if (!newTag) {
            if (allowCreation) {
                newTag = new Tag()
                newTag.name = tagName
                newTag.created = new Date()
                newTag.createdBy = session.user.userId
                newTag.save(failOnError: true)
            } else {
                throw new Exception("Unknown tag '${params.tags}'")
            }
        }
        return newTag
    }

    private List<Term> getTerms() {
        def c = Term.createCriteria()
        List result = c.list {
            like('word', "%" + params.pattern + "%")
            synset {
                eq('isVisible', true)
            }
        }
        return result
    }

    private applyPattern(String word, String pattern) {
        return word.replaceAll(pattern, "").replaceAll("  +", " ").trim();
    }

}
