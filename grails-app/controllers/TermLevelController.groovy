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

import com.vionto.vithesaurus.TermLevel
 
class TermLevelController extends BaseController {

    def beforeInterceptor = [action: this.&adminAuth]
  
    def index = { redirect(action:list,params:params) }

    // the delete, save and update actions only accept POST requests
    static def allowedMethods = [delete:'POST', save:'POST', update:'POST']

    def list = {
        if(!params.max) params.max = 10
        [ termLevelInstanceList: TermLevel.list( params ) ]
    }

    def show = {
        def termLevelInstance = TermLevel.get( params.id )

        if(!termLevelInstance) {
            flash.message = "TermLevel not found with id ${params.id}"
            redirect(action:list)
        }
        else { return [ termLevelInstance : termLevelInstance ] }
    }

    def delete = {
        def termLevelInstance = TermLevel.get( params.id )
        if(termLevelInstance) {
            termLevelInstance.delete()
            flash.message = "TermLevel ${params.id} deleted"
            redirect(action:list)
        }
        else {
            flash.message = "TermLevel not found with id ${params.id}"
            redirect(action:list)
        }
    }

    def edit = {
        def termLevelInstance = TermLevel.get( params.id )

        if(!termLevelInstance) {
            flash.message = "TermLevel not found with id ${params.id}"
            redirect(action:list)
        }
        else {
            return [ termLevelInstance : termLevelInstance ]
        }
    }

    def update = {
        def termLevelInstance = TermLevel.get( params.id )
        if(termLevelInstance) {
            termLevelInstance.properties = params
            if(!termLevelInstance.hasErrors() && termLevelInstance.save()) {
                flash.message = "TermLevel ${params.id} updated"
                redirect(action:show,id:termLevelInstance.id)
            }
            else {
                render(view:'edit',model:[termLevelInstance:termLevelInstance])
            }
        }
        else {
            flash.message = "TermLevel not found with id ${params.id}"
            redirect(action:edit,id:params.id)
        }
    }

    def create = {
        def termLevelInstance = new TermLevel()
        termLevelInstance.properties = params
        return ['termLevelInstance':termLevelInstance]
    }

    def save = {
        def termLevelInstance = new TermLevel(params)
        if(!termLevelInstance.hasErrors() && termLevelInstance.save()) {
            flash.message = "TermLevel ${termLevelInstance.id} created"
            redirect(action:show,id:termLevelInstance.id)
        }
        else {
            render(view:'create',model:[termLevelInstance:termLevelInstance])
        }
    }
}
