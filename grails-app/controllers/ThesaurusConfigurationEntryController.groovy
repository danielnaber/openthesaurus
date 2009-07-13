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

import com.vionto.vithesaurus.ThesaurusConfigurationEntry            

class ThesaurusConfigurationEntryController extends BaseController {
    
    def beforeInterceptor = [action: this.&adminAuth]
    
    def index = { redirect(action:list,params:params) }

    // the delete, save and update actions only accept POST requests
    static def allowedMethods = [delete:'POST', save:'POST', update:'POST']

    def list = {
        if(!params.max) params.max = 10
        [ thesaurusConfigurationEntryList: ThesaurusConfigurationEntry.list( params ) ]
    }

    def show = {
        def thesaurusConfigurationEntry = ThesaurusConfigurationEntry.get( params.id )

        if(!thesaurusConfigurationEntry) {
            flash.message = "ThesaurusConfigurationEntry not found with id ${params.id}"
            redirect(action:list)
        }
        else { return [ thesaurusConfigurationEntry : thesaurusConfigurationEntry ] }
    }

    def delete = {
        def thesaurusConfigurationEntry = ThesaurusConfigurationEntry.get( params.id )
        if(thesaurusConfigurationEntry) {
            thesaurusConfigurationEntry.delete()
            flash.message = "ThesaurusConfigurationEntry ${params.id} deleted"
            redirect(action:list)
        }
        else {
            flash.message = "ThesaurusConfigurationEntry not found with id ${params.id}"
            redirect(action:list)
        }
    }

    def edit = {
        def thesaurusConfigurationEntry = ThesaurusConfigurationEntry.get( params.id )

        if(!thesaurusConfigurationEntry) {
            flash.message = "ThesaurusConfigurationEntry not found with id ${params.id}"
            redirect(action:list)
        }
        else {
            return [ thesaurusConfigurationEntry : thesaurusConfigurationEntry ]
        }
    }

    def update = {
        def thesaurusConfigurationEntry = ThesaurusConfigurationEntry.get( params.id )
        if(thesaurusConfigurationEntry) {
            thesaurusConfigurationEntry.properties = params
            if(!thesaurusConfigurationEntry.hasErrors() && thesaurusConfigurationEntry.save()) {
                flash.message = "ThesaurusConfigurationEntry ${params.id} updated"
                redirect(action:show,id:thesaurusConfigurationEntry.id)
            }
            else {
                render(view:'edit',model:[thesaurusConfigurationEntry:thesaurusConfigurationEntry])
            }
        }
        else {
            flash.message = "ThesaurusConfigurationEntry not found with id ${params.id}"
            redirect(action:edit,id:params.id)
        }
    }

    def create = {
        def thesaurusConfigurationEntry = new ThesaurusConfigurationEntry()
        thesaurusConfigurationEntry.properties = params
        return ['thesaurusConfigurationEntry':thesaurusConfigurationEntry]
    }

    def save = {
        def thesaurusConfigurationEntry = new ThesaurusConfigurationEntry(params)
        if(!thesaurusConfigurationEntry.hasErrors() && thesaurusConfigurationEntry.save()) {
            flash.message = "ThesaurusConfigurationEntry ${thesaurusConfigurationEntry.id} created"
            redirect(action:show,id:thesaurusConfigurationEntry.id)
        }
        else {
            render(view:'create',model:[thesaurusConfigurationEntry:thesaurusConfigurationEntry])
        }
    }
}