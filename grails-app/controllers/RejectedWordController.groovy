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

import com.vionto.vithesaurus.RejectedWord

class RejectedWordController extends BaseController {
    
    def beforeInterceptor = [action: this.&auth]

    def index = { redirect(action:list,params:params) }

    // some actions only accept POST requests:
    static def allowedMethods = [delete:'POST', save:'POST', update:'POST',
                          reject: 'POST', unreject: 'POST']

    /** Add a given word to the list of rejected terms (used from ajax calls). */
    def reject = {
        if (!params.word) {
            throw new Exception("parameter 'word' must be set")
        }
        RejectedWord existingWord = RejectedWord.findByWord(params.word)
        if (existingWord) {
            render(template:"rejectedAgain", model:[id:existingWord.id])
            return
        }
        assert(session.user)
        RejectedWord rejWord = new RejectedWord(word: params.word,
                user: session.user, rejectionDate: new Date())
        if (!rejWord.save()) {
            throw new Exception("Could not save rejection: ${rejWord.errors}")
        }
        render(template:"rejected", model:[id:rejWord.id])
    }

    /** Remove a given word to the list of rejected terms (used from ajax calls). */
    def unreject = {
        if (!params.word) {
            throw new Exception("parameter 'word' must be set")
        }
        List rejectedWords = RejectedWord.findAllByWordIlike(params.word)
        if (rejectedWords.size() > 1) {
            throw new Exception("more than one match for '${params.word}': ${rejectedWord.size()}")
        }
        if (rejectedWords.size() == 1) {
            rejectedWords.get(0).delete()
            render "UNREJECTED"
        } else {
            // This happens if the user selects the approval radio button,
            // but then does not create a concept, and then select the unreject
            // (i.e. neutral) radion button again -> no need to throw an exception:
            render ""
        }
    }
    
    def list = {
        if(!params.max) params.max = 10
        [ rejectedWordList: RejectedWord.list( params ) ]
    }

    def delete = {
        def rejectedWord = RejectedWord.get( params.id )
        if(rejectedWord) {
            rejectedWord.delete()
            flash.message = "RejectedWord ${params.id} deleted"
            redirect(action:list)
        }
        else {
            flash.message = "RejectedWord not found with id ${params.id}"
            redirect(action:list)
        }
    }

    def edit = {
        def rejectedWord = RejectedWord.get( params.id )

        if(!rejectedWord) {
            flash.message = "RejectedWord not found with id ${params.id}"
            redirect(action:list)
        }
        else {
            return [ rejectedWord : rejectedWord ]
        }
    }

    def update = {
        def rejectedWord = RejectedWord.get( params.id )
        if(rejectedWord) {
            rejectedWord.properties = params
            if(!rejectedWord.hasErrors() && rejectedWord.save()) {
                flash.message = "RejectedWord ${params.id} updated"
                redirect(action:list,id:rejectedWord.id)
            }
            else {
                render(view:'edit',model:[rejectedWord:rejectedWord])
            }
        }
        else {
            flash.message = "RejectedWord not found with id ${params.id}"
            redirect(action:edit,id:params.id)
        }
    }

    def create = {
        def rejectedWord = new RejectedWord()
        rejectedWord.properties = params
        return ['rejectedWord':rejectedWord]
    }

    def save = {
        if (!params.rejectionDate) params.rejectionDate = new Date()
        assert(session.user)
        if (!params["user.id"]) params["user.id"] = session.user.id
        def rejectedWord = new RejectedWord(params)
        if(!rejectedWord.hasErrors() && rejectedWord.save()) {
            flash.message = "RejectedWord ${rejectedWord.id} created"
            redirect(action:edit,id:rejectedWord.id)
        }
        else {
            render(view:'create',model:[rejectedWord:rejectedWord])
        }
    }
}