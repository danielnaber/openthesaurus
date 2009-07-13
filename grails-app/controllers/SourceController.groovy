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
            
class SourceController extends BaseController {
    
    def beforeInterceptor = [action: this.&adminAuth]
  
    def index = { redirect(action:list,params:params) }

    // the delete, save and update actions only accept POST requests
    static def allowedMethods = [delete:'POST', save:'POST', update:'POST']

    def list = {
        if(!params.max) params.max = 10
        [ sourceList: Source.list( params ) ]
    }

    def show = {
        [ source : Source.get( params.id ) ]
    }

    def delete = {
        def source = Source.get( params.id )
        if(source) {
            source.delete()
            flash.message = "Source ${params.id} deleted"
            redirect(action:list)
        }
        else {
            flash.message = "Source not found with id ${params.id}"
            redirect(action:list)
        }
    }

    def edit = {
        def source = Source.get( params.id )

        if(!source) {
            flash.message = "Source not found with id ${params.id}"
            redirect(action:list)
        }
        else {
            return [ source : source ]
        }
    }

    def update = {
        def source = Source.get( params.id )
        if(source) {
            source.properties = params
            if(!source.hasErrors() && source.save()) {
                flash.message = "Source ${params.id} updated"
                redirect(action:show,id:source.id)
            }
            else {
                render(view:'edit',model:[source:source])
            }
        }
        else {
            flash.message = "Source not found with id ${params.id}"
            redirect(action:edit,id:params.id)
        }
    }

    def create = {
        def source = new Source()
        source.properties = params
        return ['source':source]
    }

    def save = {
        def source = new Source(params)
        if(!source.hasErrors() && source.save()) {
            flash.message = "Source ${source.id} created"
            redirect(action:show,id:source.id)
        }
        else {
            render(view:'create',model:[source:source])
        }
    }
}