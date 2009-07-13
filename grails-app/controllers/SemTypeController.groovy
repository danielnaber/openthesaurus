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

import com.vionto.vithesaurus.SemType            

class SemTypeController extends BaseController {

    def beforeInterceptor = [action: this.&adminAuth]
    
    def index = { redirect(action:list,params:params) }

    // the delete, save and update actions only accept POST requests
    static def allowedMethods = [delete:'POST', save:'POST', update:'POST']

    def list = {
        if(!params.max) params.max = 10
        [ semTypeList: SemType.list( params ) ]
    }

    def show = {
        [ semType : SemType.get( params.id ) ]
    }

    def delete = {
        def semType = SemType.get( params.id )
        if(semType) {
            semType.delete()
            flash.message = "SemType ${params.id} deleted"
            redirect(action:list)
        }
        else {
            flash.message = "SemType not found with id ${params.id}"
            redirect(action:list)
        }
    }

    def edit = {
        def semType = SemType.get( params.id )

        if(!semType) {
            flash.message = "SemType not found with id ${params.id}"
            redirect(action:list)
        }
        else {
            return [ semType : semType ]
        }
    }

    def update = {
        def semType = SemType.get( params.id )
        if(semType) {
            semType.properties = params
            if(!semType.hasErrors() && semType.save()) {
                flash.message = "SemType ${params.id} updated"
                redirect(action:show,id:semType.id)
            }
            else {
                render(view:'edit',model:[semType:semType])
            }
        }
        else {
            flash.message = "SemType not found with id ${params.id}"
            redirect(action:edit,id:params.id)
        }
    }

    def create = {
        def semType = new SemType()
        semType.properties = params
        return ['semType':semType]
    }

    def save = {
        def semType = new SemType(params)
        if(!semType.hasErrors() && semType.save()) {
            flash.message = "SemType ${semType.id} created"
            redirect(action:show,id:semType.id)
        }
        else {
            render(view:'create',model:[semType:semType])
        }
    }
}