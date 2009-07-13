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
            
class LinkTypeController extends BaseController {
    
    def beforeInterceptor = [action: this.&adminAuth]
  
    def index = { redirect(action:list,params:params) }

    // the delete, save and update actions only accept POST requests
    static def allowedMethods = [delete:'POST', save:'POST', update:'POST']

    def list = {
        if(!params.max) params.max = 10
        [ linkTypeList: LinkType.list( params ) ]
    }

    def show = {
        [ linkType : LinkType.get( params.id ) ]
    }

    def delete = {
        def linkType = LinkType.get( params.id )
        if(linkType) {
            linkType.delete()
            flash.message = "LinkType ${params.id} deleted"
            redirect(action:list)
        }
        else {
            flash.message = "LinkType not found with id ${params.id}"
            redirect(action:list)
        }
    }

    def edit = {
        def linkType = LinkType.get( params.id )

        if(!linkType) {
            flash.message = "LinkType not found with id ${params.id}"
            redirect(action:list)
        }
        else {
            return [ linkType : linkType ]
        }
    }

    def update = {
        def linkType = LinkType.get( params.id )
        if(linkType) {
            linkType.properties = params
            if(!linkType.hasErrors() && linkType.save()) {
                flash.message = "LinkType ${params.id} updated"
                redirect(action:show,id:linkType.id)
            }
            else {
                render(view:'edit',model:[linkType:linkType])
            }
        }
        else {
            flash.message = "LinkType not found with id ${params.id}"
            redirect(action:edit,id:params.id)
        }
    }

    def create = {
        def linkType = new LinkType()
        linkType.properties = params
        return ['linkType':linkType]
    }

    def save = {
        def linkType = new LinkType(params)
        if(!linkType.hasErrors() && linkType.save()) {
            flash.message = "LinkType ${linkType.id} created"
            redirect(action:show,id:linkType.id)
        }
        else {
            render(view:'create',model:[linkType:linkType])
        }
    }
}