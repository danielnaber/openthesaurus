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

class TermLinkTypeController extends BaseController {
  
    def beforeInterceptor = [action: this.&adminAuth]
    
    def index = { redirect(action:list,params:params) }

    // the delete, save and update actions only accept POST requests
    static def allowedMethods = [delete:'POST', save:'POST', update:'POST']

    def list = {
        if(!params.max) params.max = 10
        [ termLinkTypeInstanceList: TermLinkType.list( params ) ]
    }

    def show = {
        def termLinkTypeInstance = TermLinkType.get( params.id )

        if(!termLinkTypeInstance) {
            flash.message = "TermLinkType not found with id ${params.id}"
            redirect(action:list)
        }
        else { return [ termLinkTypeInstance : termLinkTypeInstance ] }
    }

    def delete = {
        def termLinkTypeInstance = TermLinkType.get( params.id )
        if(termLinkTypeInstance) {
            termLinkTypeInstance.delete()
            flash.message = "TermLinkType ${params.id} deleted"
            redirect(action:list)
        }
        else {
            flash.message = "TermLinkType not found with id ${params.id}"
            redirect(action:list)
        }
    }

    def edit = {
        def termLinkTypeInstance = TermLinkType.get( params.id )

        if(!termLinkTypeInstance) {
            flash.message = "TermLinkType not found with id ${params.id}"
            redirect(action:list)
        }
        else {
            return [ termLinkTypeInstance : termLinkTypeInstance ]
        }
    }

    def update = {
        def termLinkTypeInstance = TermLinkType.get( params.id )
        if(termLinkTypeInstance) {
            termLinkTypeInstance.properties = params
            if(!termLinkTypeInstance.hasErrors() && termLinkTypeInstance.save()) {
                flash.message = "TermLinkType ${params.id} updated"
                redirect(action:show,id:termLinkTypeInstance.id)
            }
            else {
                render(view:'edit',model:[termLinkTypeInstance:termLinkTypeInstance])
            }
        }
        else {
            flash.message = "TermLinkType not found with id ${params.id}"
            redirect(action:edit,id:params.id)
        }
    }

    def create = {
        def termLinkTypeInstance = new TermLinkType()
        termLinkTypeInstance.properties = params
        return ['termLinkTypeInstance':termLinkTypeInstance]
    }

    def save = {
        def termLinkTypeInstance = new TermLinkType(params)
        if(!termLinkTypeInstance.hasErrors() && termLinkTypeInstance.save()) {
            flash.message = "TermLinkType ${termLinkTypeInstance.id} created"
            redirect(action:show,id:termLinkTypeInstance.id)
        }
        else {
            render(view:'create',model:[termLinkTypeInstance:termLinkTypeInstance])
        }
    }
}
