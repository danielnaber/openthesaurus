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

import com.vionto.vithesaurus.WordGrammar            

class WordGrammarController extends BaseController {
    
    def beforeInterceptor = [action: this.&adminAuth ]
    
    def index = { redirect(action:list,params:params) }

    // the delete, save and update actions only accept POST requests
    static def allowedMethods = [delete:'POST', save:'POST', update:'POST']

    def list = {
        if(!params.max) params.max = 10
        [ wordGrammarList: WordGrammar.list( params ) ]
    }

    def show = {
        [ wordGrammar : WordGrammar.get( params.id ) ]
    }

    def delete = {
        def wordGrammar = WordGrammar.get( params.id )
        if(wordGrammar) {
            wordGrammar.delete()
            flash.message = "WordGrammar ${params.id} deleted"
            redirect(action:list)
        }
        else {
            flash.message = "WordGrammar not found with id ${params.id}"
            redirect(action:list)
        }
    }

    def edit = {
        def wordGrammar = WordGrammar.get( params.id )

        if(!wordGrammar) {
            flash.message = "WordGrammar not found with id ${params.id}"
            redirect(action:list)
        }
        else {
            return [ wordGrammar : wordGrammar ]
        }
    }

    def update = {
        def wordGrammar = WordGrammar.get( params.id )
        if(wordGrammar) {
            wordGrammar.properties = params
            if(!wordGrammar.hasErrors() && wordGrammar.save()) {
                flash.message = "WordGrammar ${params.id} updated"
                redirect(action:show,id:wordGrammar.id)
            }
            else {
                render(view:'edit',model:[wordGrammar:wordGrammar])
            }
        }
        else {
            flash.message = "WordGrammar not found with id ${params.id}"
            redirect(action:edit,id:params.id)
        }
    }

    def create = {
        def wordGrammar = new WordGrammar()
        wordGrammar.properties = params
        return ['wordGrammar':wordGrammar]
    }

    def save = {
        def wordGrammar = new WordGrammar(params)
        if(!wordGrammar.hasErrors() && wordGrammar.save()) {
            flash.message = "WordGrammar ${wordGrammar.id} created"
            redirect(action:show,id:wordGrammar.id)
        }
        else {
            render(view:'create',model:[wordGrammar:wordGrammar])
        }
    }
}