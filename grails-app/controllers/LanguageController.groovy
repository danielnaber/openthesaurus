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
            
class LanguageController extends BaseController {
    
    def beforeInterceptor = [action: this.&adminAuth]
  
    def index = { redirect(action:list,params:params) }

    // the delete, save and update actions only accept POST requests
    static def allowedMethods = [delete:'POST', save:'POST', update:'POST']

    def list = {
        if(!params.max) params.max = 10
        [ languageList: Language.list( params ) ]
    }

    def show = {
        [ language : Language.get( params.id ) ]
    }

    def delete = {
        def language = Language.get( params.id )
        if(language) {
            language.delete()
            flash.message = "Language ${params.id} deleted"
            redirect(action:list)
        }
        else {
            flash.message = "Language not found with id ${params.id}"
            redirect(action:list)
        }
    }

    def edit = {
        def language = Language.get( params.id )

        if(!language) {
            flash.message = "Language not found with id ${params.id}"
            redirect(action:list)
        }
        else {
            return [ language : language ]
        }
    }

    def update = {
        def language = Language.get( params.id )
        if(language) {
            language.properties = params
            if(!language.hasErrors() && language.save()) {
                flash.message = "Language ${params.id} updated"
                redirect(action:show,id:language.id)
            }
            else {
                render(view:'edit',model:[language:language])
            }
        }
        else {
            flash.message = "Language not found with id ${params.id}"
            redirect(action:edit,id:params.id)
        }
    }

    def create = {
        def language = new Language()
        language.properties = params
        return ['language':language]
    }

    def save = {
        def language = new Language(params)
        if(!language.hasErrors() && language.save()) {
            flash.message = "Language ${language.id} created"
            redirect(action:show,id:language.id)
        }
        else {
            render(view:'create',model:[language:language])
        }
    }
}