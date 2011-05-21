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
import com.vionto.vithesaurus.tools.IpTools

class UserController extends BaseController {
    
    def beforeInterceptor = [action: this.&auth, 
                             except: ['login', 'register', 'doRegister', 'confirmRegistration',
                                      'lostPassword', 'requestPasswordReset', 'confirmPasswordReset',
                                      'resetPassword']]

    static def allowedMethods = [delete:'POST', save:'POST', update:'POST', doRegister:'POST',
                                 confirmPasswordReset: 'GET', requestPasswordReset:'POST']
    
    static final int MIN_PASSWORD_LENGTH = 4

    def index = {
        redirect(action:list,params:params)
    }

    def register = {
      []
    }
    
    def doRegister = {
      def user = new ThesaurusUser(params.userId, UserController.md5sum(params.password1),
          ThesaurusUser.USER_PERM)
      user.realName = params.visibleName
      if (!params.userId || params.userId.trim().isEmpty()) {
        user.errors.reject('thesaurus.error', [].toArray(), 
            message(code:'user.register.missing.email'))
        render(view:'register', model:[user:user], contentType:"text/html", encoding:"UTF-8")
        return
      }
      if (!params.visibleName || params.visibleName.trim().isEmpty()) {
        user.errors.reject('thesaurus.error', [].toArray(), 
            message(code:'user.register.missing.visible.name'))
        render(view:'register', model:[user:user], contentType:"text/html", encoding:"UTF-8")
        return
      }
      if (ThesaurusUser.findByRealName(params.visibleName)) {
        user.errors.reject('thesaurus.error', [].toArray(),
            message(code:'user.register.user.visible.name.exists'))
        render(view:'register', model:[user:user], contentType:"text/html", encoding:"UTF-8")
        return
      }
      if (!ThesaurusUser.findByUserId(params.userId)) {
        checkPasswords(user)
        if (user.errors.allErrors.size() > 0) {
          render(view:'register', model:[user:user], contentType:"text/html", encoding:"UTF-8")
          return
        }
        log.info("Creating user: " + params.userId)
        user.confirmationDate = null
        // generate a random code:
        user.confirmationCode = getRandomCode()
        if (!user.validate()) {
          log.error("User validation failed: ${user.errors}")
        } else {
          boolean saved = user.save()
          if (!saved) {
            throw new Exception("Could not save user: ${user.errors}")
          }
        }
        String activationLink = grailsApplication.config.thesaurus.serverURL + "/user/confirmRegistration?userId=${user.id}&code=${user.confirmationCode}"
        sendMail {
          from message(code:'user.register.email.from')
          to params.userId
          subject message(code:'user.register.email.subject')     
          body message(code:'user.register.email.body', args:[activationLink]) 
        }
        log.info("Sent registration mail to ${params.userId}, code ${user.confirmationCode}")
        if (params.subscribeToMailingList) {
          sendMail {
            from params.userId
            to message(code:'user.register.email.mailinglist.to')
            subject message(code:'user.register.email.mailinglist.subject')
            body ''
          }
          String ip = IpTools.getRealIpAddress(request)
          log.info("Sent mailing list registration request mail to " + message(code:'user.register.email.mailinglist.to') + " with From: " + params.userId + ", User IP: " + ip)
        }
      } else {
        user.errors.reject('thesaurus.error', [].toArray(), 
            message(code:'user.register.user.exists'))
        render(view:'register', model:[user:user], contentType:"text/html", encoding:"UTF-8")
        return
      }
      [email: params.userId]
    }

    private checkPasswords(ThesaurusUser user) {
      if (params.password1 != params.password2) {
        user.errors.reject('thesaurus.error', [].toArray(), 
            message(code:'user.register.different.passwords'))
      }
      if (params.password1.length() < MIN_PASSWORD_LENGTH) {
        user.errors.reject('thesaurus.error', [].toArray(), 
            message(code:'user.register.short.password', args:[MIN_PASSWORD_LENGTH]))
      }
    }
    
    private String getRandomCode() {
      StringBuilder code = new StringBuilder()
      for (int i = 0; i < 1; i++) {
        String partialCode = Math.random() + ""
        code.append(partialCode.replace(".", ""))
      }
      return code.toString()
    }
    
    // called when clicking on the link in the email
    def confirmRegistration = {
      if (!params.userId || !params.code) {
        throw new Exception("Parameters userId and/or code missing")
      }
      log.info("Confirming registration for ${params.userId}, ${params.code}")
      def user = ThesaurusUser.get(params.userId)
      if (!user) {
        throw new Exception("User not found for id ${params.userId}")
      }
      if (user.confirmationDate) {
        log.warn("Confirming registration had happened before for ${params.userId}, ${params.code}")
        //FIXME: i18n
        flash.message = "Your user account has already been confirmed before"
        redirect(url:grailsApplication.config.thesaurus.serverURL)     // go to homepage
      } else {
        if (user.confirmationCode != params.code) {
          throw new Exception("Confirmation code invalid for ${params.userId}, ${params.code} != ${user.confirmationCode}")
        }
        user.confirmationDate = new Date()
        log.info("Confirming registration successful for ${params.userId}, ${params.code}")
        //FIXME: i18n
        //flash.message = "Your user account has been confirmed. You may now <a href='login'>log in</a>."
        flash.message = "Ihr Account wurde aktiviert - Sie können sich jetzt <a href='user/login'>einloggen</a>."
        redirect(url:grailsApplication.config.thesaurus.serverURL)     // go to homepage
      }
    }
    
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
            if (user.blocked) {
              log.warn("login failed for user ${params.userId} (${IpTools.getRealIpAddress(request)}): user is blocked")
              // deliberately show same message as otherwise... 
              flash.message = message(code:'user.invalid.login')
              return
            }
            if (!user.confirmationDate) {
              log.warn("login failed for user ${params.userId} (${IpTools.getRealIpAddress(request)}): account not confirmed")
              flash.message = message(code:'user.unconfirmed.login')
              return
            }
            log.info("login successful for user ${user} (${IpTools.getRealIpAddress(request)})")
            flash.message = message(code:'user.logged.in')
            session.user = user
            user.lastLoginDate = new Date()
            def redirectParams = 
              session.origParams ? session.origParams : [uri:"/"]
            if (redirectParams?.origId) {
                redirectParams.id = redirectParams.origId
            }
            // TODO: there must be a better way for this "redirect after 
            // login" problem (maybe "originalRequestParameters"?)
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
                redirect(url:grailsApplication.config.thesaurus.serverURL)     // go to homepage
            }
          } else {
            log.warn("login failed for user ${params.userId} (${IpTools.getRealIpAddress(request)})")
            flash.message = message(code:'user.invalid.login')
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
        flash.message = message(code:'user.logged.out')
        redirect(url:grailsApplication.config.thesaurus.serverURL)     // go to homepage
    }
    
    def lostPassword = {
        []
    }
    
    def requestPasswordReset = {
        ThesaurusUser user = ThesaurusUser.findByUserId(params.userId)
        if (!user) {
          flash.message = message(code:'user.lost.password.invalid.user')
          render(view:'lostPassword', model:[userId:params.userId], contentType:"text/html", encoding:"UTF-8")
          log.warn("Requesting password reset for unknown user '${params.userId}'")
          return
        }
        String code = getRandomCode()
        user.confirmationCode = code
        boolean saved = user.save()
        if (!saved) {
          throw new Exception("Could not save user: " + user.errors)
        }
        String activationLink = grailsApplication.config.thesaurus.serverURL + "/user/confirmPasswordReset?userId=${user.id}&code=${user.confirmationCode}"
        sendMail {    
          from message(code:'user.register.email.from')
          to params.userId
          subject message(code:'user.lost.password.email.subject')     
          body message(code:'user.lost.password.email.body', args:[params.userId, activationLink]) 
        }
        log.info("Sent password reset mail to ${params.userId}, code ${user.confirmationCode}")
        [email: params.userId]
    }
    
    def confirmPasswordReset = {
        ThesaurusUser user = ThesaurusUser.get(params.userId)
        if (!user) {
          throw new Exception("No user found: '${params.userId}'")
        }
        checkPasswordResetConfirmation(user)
        [user: user]
    }
    
    def resetPassword = {
        if (!params.userId) {
          throw new Exception("Missing parameter 'userId'")
        }
        ThesaurusUser user = ThesaurusUser.get(Long.parseLong(params.userId))
        if (!user) {
          throw new Exception("No user found: '${params.userId}'")
        }
        checkPasswordResetConfirmation(user)
        checkPasswords(user)
        if (user.errors.allErrors.size() > 0) {
          render(view:'confirmPasswordReset', model:[user:user], contentType:"text/html", encoding:"UTF-8")
          return
        }
        log.info("Setting user password for '${user.userId}'")
        user.password = md5sum(params.password1)
        user.confirmationCode = ""
        boolean saved = user.validate() && user.save()
        if (!saved) {
          throw new Exception("Could not save new password: ${user.errors}")
        }
        [user: user]
    }
    
    private checkPasswordResetConfirmation(ThesaurusUser user) {
        if (!user.confirmationCode || user.confirmationCode == "") {
          log.warn("Empty/null confirmation code in database for user '${params.userId}' doesn't allow password reset")
          throw new Exception("Invalid code '${params.code}' for user '${params.userId}'")
        }
        if (user.confirmationCode != params.code) {
          log.warn("Invalid code '${params.code}' for user '${params.userId}', expected ${user.confirmationCode}")
          throw new Exception("Invalid code '${params.code}' for user '${params.userId}'")
        }
    }
    
    def list = {
        if (!isAdmin()) {
            render "Access denied"
            return
        }
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
        if(session.user) {
          ThesaurusUser user = session.user
          return [ user : user ]
        } else {
          flash.message = "User not found with id ${params.id}"
          redirect(action:list)
        }
    }

    def update = {
        if (session.user) {
            ThesaurusUser user = session.user
            //TODO: make this work again
            /*String passwordBackup = user.password
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
            }*/
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
        // a pseudo-random salt:
        final String salt = "hi234z2ejgrr97otw4ujzt4wt7jtsr4975FERedefef"
        str = str + "/" + salt
        MessageDigest md = MessageDigest.getInstance("MD5")
        md.update(str.getBytes(), 0, str.length())
        byte[] md5sum = md.digest()
        BigInteger bigInt = new BigInteger(1, md5sum)
        return bigInt.toString(16)
    }

}
 