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
            
class LevelController  extends BaseController {

    def beforeInterceptor = [action: this.&adminAuth]
  
    def index = { redirect(action:list,params:params) }

    // the delete, save and update actions only accept POST requests
    static def allowedMethods = [delete:'POST', save:'POST', update:'POST']

    def list = {
        if(!params.max) params.max = 10
        [ levelList: Level.list( params ) ]
    }

    def show = {
        [ level : Level.get( params.id ) ]
    }

    def delete = {
        def level = Level.get( params.id )
        if(level) {
            level.delete()
            flash.message = "Level ${params.id} deleted"
            redirect(action:list)
        }
        else {
            flash.message = "Level not found with id ${params.id}"
            redirect(action:list)
        }
    }

    def edit = {
        def level = Level.get( params.id )

        if(!level) {
            flash.message = "Level not found with id ${params.id}"
            redirect(action:list)
        }
        else {
            return [ level : level ]
        }
    }

    def update = {
        def level = Level.get( params.id )
        if(level) {
            level.properties = params
            if(!level.hasErrors() && level.save()) {
                flash.message = "Level ${params.id} updated"
                redirect(action:show,id:level.id)
            }
            else {
                render(view:'edit',model:[level:level])
            }
        }
        else {
            flash.message = "Level not found with id ${params.id}"
            redirect(action:edit,id:params.id)
        }
    }

    def create = {
        def level = new TermLevel()
        level.properties = params
        return ['level':level]
    }

    def save = {
        def level = new TermLevel(params)
        if(!level.hasErrors() && level.save()) {
            flash.message = "Level ${level.id} created"
            redirect(action:show,id:level.id)
        }
        else {
            render(view:'create',model:[level:level])
        }
    }
}