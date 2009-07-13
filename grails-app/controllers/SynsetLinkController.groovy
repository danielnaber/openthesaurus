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
            
class SynsetLinkController extends BaseController {
    
    def beforeInterceptor = [action: this.&adminAuth]

    def index = { redirect(action:list,params:params) }

    // the delete, save and update actions only accept POST requests
    static def allowedMethods = [delete:'POST', save:'POST', update:'POST']

    def list = {
        if(!params.max) params.max = 10
        [ synsetLinkList: SynsetLink.list( params ) ]
    }

    def show = {
        [ synsetLink : SynsetLink.get( params.id ) ]
    }

    def delete = {
        def synsetLink = SynsetLink.get( params.id )
        if(synsetLink) {
            synsetLink.delete()
            flash.message = "SynsetLink ${params.id} deleted"
            redirect(action:list)
        }
        else {
            flash.message = "SynsetLink not found with id ${params.id}"
            redirect(action:list)
        }
    }

    def edit = {
        def synsetLink = SynsetLink.get( params.id )

        if(!synsetLink) {
            flash.message = "SynsetLink not found with id ${params.id}"
            redirect(action:list)
        }
        else {
            return [ synsetLink : synsetLink ]
        }
    }

    def update = {
        def synsetLink = SynsetLink.get( params.id )
        if(synsetLink) {
            synsetLink.properties = params
            if(!synsetLink.hasErrors() && synsetLink.save()) {
                flash.message = "SynsetLink ${params.id} updated"
                redirect(action:show,id:synsetLink.id)
            }
            else {
                render(view:'edit',model:[synsetLink:synsetLink])
            }
        }
        else {
            flash.message = "SynsetLink not found with id ${params.id}"
            redirect(action:edit,id:params.id)
        }
    }

    def create = {
        def synsetLink = new SynsetLink()
        synsetLink.properties = params
        return ['synsetLink':synsetLink]
    }

    def save = {
        def synsetLink = new SynsetLink(params)
        if(!synsetLink.hasErrors() && synsetLink.save()) {
            flash.message = "New link between concepts created"
            //redirect(action:show,id:synsetLink.id)
            redirect(controller:"synset",action:edit,id:synsetLink.synset.id)
        }
        else {
            render(view:'create',model:[synsetLink:synsetLink])
        }
    }
}