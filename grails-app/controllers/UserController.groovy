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
import java.security.MessageDigest
            
class UserController extends BaseController {
    
    def beforeInterceptor = [action: this.&auth, except: ['login']]
  
    def index = {
        redirect(action:list,params:params)
    }

    // the delete, save and update actions only accept POST requests
    def allowedMethods = [delete:'POST', save:'POST', update:'POST']

    /**
     * Show login page for GET request, handle login (authenticate + redirect)
     * otherwise.
     */
    def login = {
        if (request.method == 'GET') {
          // show login page
          session.user = null
          if (params.controllerName && params.actionName) {
              session.controllerName = params.controllerName
              session.actionName = params.actionName
          }
          if (params.controllerName && params.actionName) {
              session.origId = params.origId
          }
          if (params.q) {
              session.origQuery = params.q
          }
          ThesaurusUser user = new ThesaurusUser()
        } else {
          ThesaurusUser user = 
              ThesaurusUser.findByUserIdAndPassword(params.userId, md5sum(params.password))
          if (user) {
            log.info("login successful for user ${user}")
            flash.message = "Successfully logged in as '${user.userId.encodeAsHTML()}'"
            session.user = user
            user.lastLoginDate = new Date()
            def redirectParams = 
              session.origParams ? session.origParams : [uri:"/"]
            if (redirectParams?.origId) {
                redirectParams.id = redirectParams.origId
            }
            // TODO: there must be a better way for this "redirect after 
            // login" problem:
            if (redirectParams?.controller && redirectParams?.action) {
                redirect(controller:redirectParams?.controller,
                        action: redirectParams?.action, params:redirectParams)
            } else if (session.controllerName && session.actionName && session.origId) {
                // useful redirect if someone is on content page with an id, 
                // like "jthesaurus/synset/edit/123":
                redirect(controller:session.controllerName,
                        action: session.actionName, params:[id:session.origId])
            } else if (session.controllerName && session.actionName) {
                if (session.origQuery) {
                    redirect(controller:session.controllerName,
                            action: session.actionName,
                            params:[q:session.origQuery])
                } else {
                    redirect(controller:session.controllerName,
                            action: session.actionName)
                }
            } else {
                redirect(uri:"")        // got to homepage
            }
          } else {
            log.warn("login failed for user ${params.userId} (${request.getRemoteAddr()})")
            flash.message = "Invalid user id and/or password. " +
              "Please also make sure cookies are enabled."
          }
        }
    }
    
    /**
     * Logout by setting the session values to null, then redirect to homepage.
     */
    def logout = {
        log.info("logout of user ${session.user}")
        session.user = null
        session.controllerName = null
        session.actionName = null
        flash.message = "Successfully logged out"
        redirect(uri:"")
    }
    
    def list = {
        if(!params.max) params.max = 10
        [ userList: ThesaurusUser.list( params ) ]
    }

    def delete = {
        if (!isAdmin()) {
            render "Access denied"
            return
        }
        ThesaurusUser user = ThesaurusUser.get( params.id )
        if (user) {
            log.info("Deleting user ${user.userId}")
            user.delete()
            flash.message = "User ${params.id} deleted"
            redirect(action:list)
        }
        else {
            flash.message = "User not found with id ${params.id}"
            redirect(action:list)
        }
    }

    def edit = {
        ThesaurusUser user = ThesaurusUser.get( params.id )
        if (!isAdmin() && user.id != session?.user?.id) {
            render "Access denied"
            return
        }

        if(!user) {
            flash.message = "User not found with id ${params.id}"
            redirect(action:list)
        }
        else {
            return [ user : user ]
        }
    }

    def update = {
        ThesaurusUser user = ThesaurusUser.get( params.id )
        if (!isAdmin() && user.id != session?.user?.id) {
            // a user may only edit his own account
            render "Access denied"
            return
        }
        if (user) {
            // only the admin may change a user's permission level:
            if (!isAdmin() && user.permission == ThesaurusUser.USER_PERM && 
                    params.permission != ThesaurusUser.USER_PERM) {
                flash.message = "Permission may not be changed"
                redirect(action:edit,id:params.id)
                return
            }
            String passwordBackup = user.password
            user.properties = params
            if (params.password != "") {
                user.password = md5sum(params.password)
            } else {
                user.password = passwordBackup
            }
            if(!user.hasErrors() && user.save()) {
                log.info("Updated user ${user.userId}")
                flash.message = "User ${params.id} updated"
                redirect(action:edit,id:user.id)
            }
            else {
                render(view:'edit',model:[user:user])
            }
        }
        else {
            flash.message = "User not found with id ${params.id}"
            redirect(action:edit,id:params.id)
        }
    }

    def create = {
        if (!isAdmin()) {
            render "Access denied"
            return
        }
        ThesaurusUser user = new ThesaurusUser()
        user.properties = params
        return ['user':user]
    }

    def save = {
        if (!isAdmin()) {
            render "Access denied"
            return
        }
        ThesaurusUser user = new ThesaurusUser(params)
        user.password = md5sum(params.password)
        if(!user.hasErrors() && user.save()) {
            flash.message = "User ${user.id} created"
            log.info("User ${user.userId} created")
            redirect(action:edit,id:user.id)
        }
        else {
            render(view:'create',model:[user:user])
        }
    }

    public static String md5sum(String str) {
        MessageDigest md = MessageDigest.getInstance("MD5")
        md.update(str.getBytes(), 0, str.length())
        byte[] md5sum = md.digest()
        BigInteger bigInt = new BigInteger(1, md5sum)
        return bigInt.toString(16)
    }

}
 