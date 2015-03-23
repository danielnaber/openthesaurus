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
import com.vionto.vithesaurus.tools.IpTools

class TermController extends BaseController {
    
    def beforeInterceptor = [action: this.&auth,
                             except: ['edit', 'list', 'antonyms']]

    // the delete, save and update actions only accept POST requests
    static def allowedMethods = [delete:'POST', save:'POST', update:'POST']

    def index = { redirect(action:list,params:params) }

    def antonyms = {
        if(!params.max) params.max = 20
        else params.max = Integer.parseInt(params.max)
        if(!params.offset) params.offset = 0
        else params.offset = Integer.parseInt(params.offset)
        TermLinkType antonymType = TermLinkType.findByLinkName("Antonym")
        List termLinks = TermLink.withCriteria {
            eq('linkType', antonymType)
            term {
                order("word", "asc")
            }
            maxResults(params.max)
            firstResult(params.offset)
        }
        int matchCount = TermLink.count()
        [termLinks: termLinks, matchCount: matchCount]
    }
    
    def edit = {
        def term = Term.get(params.id)
        if (!term) {
            flash.message = "Term not found with id ${params.id}"
            redirect(action:list)
        } else {
            List termLinkInfos = term.termLinkInfos()
            return [ term : term, id: term.id, termLinkInfos: termLinkInfos, readOnlyMode: readOnlyMode() ]
        }
    }

    def update = {
        Term term = Term.get(params.id)
        Term termBackup = term.clone()
        if (term) {
            boolean wordWasChanged = params.word != term.word
            if (wordWasChanged && term.synset.containsWord(params.word)) {
                term.errors.rejectValue('word', 'thesaurus.duplicate.term.noparam')
                List termLinkInfos = term.termLinkInfos()
                render(view:'edit',model:[term:term, termLinkInfos:termLinkInfos, id:term.id],
                        contentType:"text/html", encoding:"UTF-8")
                return
            }
            term.tags.toList().each { term.removeFromTags(it) }
            String[] tags = params.tags.split(",\\s*")
            term.addTags(session, tags)
            saveAntonym(params, term)
            // create a term just for validation (we cannot assign the new 
            // properties to variable 'term' as it will then be saved even
            // if it's invalid -- see http://jira.codehaus.org/browse/GRAILS-2480):
            Term updatedTerm = new Term(term.word, term.language, term.synset)
            if (!updatedTerm.validate()) {
                render(view:'edit',model:[term:updatedTerm, id:term.id],
                        contentType:"text/html", encoding:"UTF-8")
                return
            }

            // validation okay, now change the real term:
            term.word = params.word
            term.userComment = params.userComment
            if (params['level.id'] && params['level.id'] != 'null') {
                term.level = TermLevel.get(params['level.id'])
            } else {
                term.level = null
            }
            String normalizedWord = StringTools.normalize(params.word)
            if (normalizedWord != params.word) {
                term.normalizedWord = normalizedWord
            } else {
                term.normalizedWord = null
            }
            String normalizedWord2 = StringTools.normalize2(params.word)
            if (normalizedWord2 != params.word) {
                term.normalizedWord2 = normalizedWord2
            } else {
                term.normalizedWord2 = null
            }
            LogInfo logInfo = new LogInfo(session, IpTools.getRealIpAddress(request),
                    termBackup, term, params.changeComment)
            if (!term.hasErrors() && term.saveAndLog(logInfo)) {
                flash.message = message(code:'edit.term.updated', args:[term])
                redirect(controller:'synset',action:edit,id:term.synset.id)
            }
            else {
                render(view:'edit',model:[term:term],
                        contentType:"text/html", encoding:"UTF-8")
            }
        }
        else {
            flash.message = "Term not found with id ${params.id}"
            redirect(action:edit,id:params.id)
        }
    }

    private def saveAntonym(params, Term term) {
        for (key in params.keySet()) {   // delete antonym links
            if (key.startsWith("deleteExistingTermLink_Antonym_") && params[key]) {
                long termLinkId = Long.parseLong(params[key])
                TermLink termLinkToDelete = TermLink.get(termLinkId)
                if (!termLinkToDelete) {
                    throw new Exception("No term link found with id ${termLinkId}")
                }
                logTermLink("deleting link", termLinkToDelete)
                term.deleteTermLink(termLinkToDelete)
            }
        }
        if (params.targetAntonymTermId) {  // add another antonym link
            TermLinkType antonymType = TermLinkType.findByLinkName("Antonym")
            if (!antonymType) {
                throw new Exception("No 'Antonym' link type found, please configure it")
            }
            Term otherTerm = Term.get(params.targetAntonymTermId)
            if (!otherTerm) {
                throw new Exception("No term found with id ${params.targetAntonymTermId}")
            }
            TermLink termLink = new TermLink(term, otherTerm, antonymType)
            if (!termLink.save()) {
                throw new Exception("Could not save link: ${synsetLink.errors}, status $evalStatus")
            }
            logTermLink("linking", termLink)
        }
    }

    private logTermLink(String actionName, TermLink termLink) {
        String logText =
            "$actionName:<br/><br/>${termLink.term} (${termLink.term.synset.toShortString()})<br/>" +
            "<b>${termLink.linkType.verbName}</b><br/>" +
            "${termLink.targetTerm} (${termLink.targetTerm.synset.toShortString()})"
        LogInfo linkLogInfo = new LogInfo(session, IpTools.getRealIpAddress(request), termLink,
                logText, params.changeComment)
        termLink.term.log(linkLogInfo)
    }

    def ajaxSearch = {
        List terms = Term.withCriteria {
          synset {
            eq('isVisible', true)
          }
          or {
            eq('word', params.q)
            eq('normalizedWord', params.q)
          }
        }
        [terms: terms]
    }

    /**
     * List the terms of a category.
     */
    def list = {
        if(!params.max) params.max = 20
        else params.max = Integer.parseInt(params.max)
        if(!params.offset) params.offset = 0
        else params.offset = Integer.parseInt(params.offset)

        def matchCountResult = Term.withCriteria {
          synset {
            eq('isVisible', true)
          }
          if (params.levelId) {
            level {
              eq("id", Long.parseLong(params.levelId))
            }
          } else if (params.categoryId) {
            synset {
              categoryLinks {
                category {
                  eq("id", Long.parseLong(params.categoryId))
                }
              }
            }
          }
          projections {
            countDistinct("word")
          }
        }
        def matchCount = matchCountResult.get(0)
        def matches = Term.withCriteria {
          synset {
            eq('isVisible', true)
          }
          if (params.levelId) {
            level {
              eq("id", Long.parseLong(params.levelId))
            }
          } else if (params.categoryId) {
            synset {
              categoryLinks {
                category {
                  eq("id", Long.parseLong(params.categoryId))
                }
              }
            }
          }
          order("word", "asc")
          maxResults(params.max)
          firstResult(params.offset)
        }
        if (params.levelId) {
          TermLevel termLevel = TermLevel.get(params.levelId)
          render(view:'levelList',model:[matches: matches, termLevel: termLevel, matchCount: matchCount], contentType:"text/html", encoding:"UTF-8")
          return
        } else if (params.categoryId) {
          Category category = Category.get(params.categoryId)
          render(view:'categoryList',model:[matches: matches, category: category, matchCount: matchCount], contentType:"text/html", encoding:"UTF-8")
          return
        }
        [ termList: matches ]
    }

}
