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
            
class CategoryController extends BaseController {
    
    def beforeInterceptor = [action: this.&adminAuth]
    
    def index = { redirect(action:list,params:params) }

    // the delete, save and update actions only accept POST requests
    static def allowedMethods = [delete:'POST', save:'POST', update:'POST']

    def list = {
        if(!params.max) params.max = 10
        [ categoryList: Category.list( params ) ]
    }

    def show = {
        [ category : Category.get( params.id ) ]
    }

    def delete = {
        def category = Category.get( params.id )
        if(category) {
            category.delete()
            flash.message = "Category ${params.id} deleted"
            redirect(action:list)
        }
        else {
            flash.message = "Category not found with id ${params.id}"
            redirect(action:list)
        }
    }

    def edit = {
        def category = Category.get( params.id )

        if(!category) {
            flash.message = "Category not found with id ${params.id}"
            redirect(action:list)
        }
        else {
            return [ category : category ]
        }
    }

    def update = {
        def category = Category.get( params.id )
        if(category) {
            category.properties = params
            if(!category.hasErrors() && category.save()) {
                flash.message = "Category ${params.id} updated"
                redirect(action:show,id:category.id)
            }
            else {
                render(view:'edit',model:[category:category])
            }
        }
        else {
            flash.message = "Category not found with id ${params.id}"
            redirect(action:edit,id:params.id)
        }
    }

    def create = {
        def category = new Category()
        category.properties = params
        return ['category':category]
    }

    def save = {
        def category = new Category(params)
        if(!category.hasErrors() && category.save()) {
            flash.message = "Category ${category.id} created"
            redirect(action:show,id:category.id)
        }
        else {
            render(view:'create',model:[category:category])
        }
    }
}