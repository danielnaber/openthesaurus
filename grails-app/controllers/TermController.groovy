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

import com.vionto.vithesaurus.*
            
class TermController extends BaseController {
    
    def beforeInterceptor = [action: this.&auth,
                             except: ['edit', 'list']]

    // the delete, save and update actions only accept POST requests
    static def allowedMethods = [delete:'POST', save:'POST', update:'POST']

    def index = { redirect(action:list,params:params) }

    def edit = {
        def term = Term.get( params.id )
        if(!term) {
            flash.message = "Term not found with id ${params.id}"
            redirect(action:list)
        }
        else {
            // a link always goes into one direction, but we also need
            // the other direction (eg. hot->cold, cold->hot):
            List reverseLinks = TermLink.findAllByTargetTerm(term)
            return [ term : term, id: term.id, reverseLinks: reverseLinks ]
        }
    }

    def update = {
        Term term = Term.get( params.id )
        Term termBackup = term.clone()
        if (term) {
            boolean wordWasChanged = params.word != term.word
            if (wordWasChanged && term.synset.containsWord(params.word)) {
                /*term.errors.reject('thesaurus.duplicate.term',
                      [term.encodeAsHTML()].toArray(),
                      'already in concept')*/
                // TODO: "{0}" in error doesn't get substituted:
                term.errors.rejectValue('word', 'thesaurus.duplicate.term')
                render(view:'edit',model:[term:term],
                        contentType:"text/html", encoding:"UTF-8")
                return
            }
            
            // create a term just for validation (we cannot assign the new 
            // properties to variable 'term' as it will then be saved even
            // if it's invalid -- see http://jira.codehaus.org/browse/GRAILS-2480):
            Term updatedTerm = new Term(term.word, term.language, term.synset)
            updatedTerm.properties = params
            updatedTerm.isShortForm = params.wordForm == "abbreviation" ? true : false
            updatedTerm.isAcronym = params.wordForm == "acronym" ? true : false
            if (!updatedTerm.validate()) {
                render(view:'edit',model:[term:updatedTerm, id:term.id],
                        contentType:"text/html", encoding:"UTF-8")
                return
            }

            // validation okay, now change the real term:
            term.properties = params
            term.normalizedWord = Term.normalize(params.word)
            term.isShortForm = params.wordForm == "abbreviation" ? true : false
            term.isAcronym = params.wordForm == "acronym" ? true : false
            term.synset.updatePreferredTerm()
            LogInfo logInfo = new LogInfo(session, request.getRemoteAddr(),
                    termBackup, term, params.changeComment)
            if (!term.hasErrors() && term.saveAndLog(logInfo)) {
                flash.message =message(code:'edit.term.updated', args:[term.encodeAsHTML()])
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

    def list = {
        if(!params.max) params.max = 10
        else params.max = Integer.parseInt(params.max)
        if(!params.offset) params.offset = 0
        else params.offset = Integer.parseInt(params.offset)
        def termList = Term.withCriteria {
          synset {
            eq('isVisible', true)
          }
          order("word", "asc")
          maxResults(20)
          firstResult(params.offset)
        }
        [ termList: termList ]
    }

}
