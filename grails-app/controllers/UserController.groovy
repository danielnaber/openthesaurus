/**
 * OpenThesaurus - web-based thesaurus management tool
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
import com.vionto.vithesaurus.tools.IpTools
import java.security.MessageDigest
import javax.servlet.http.Cookie
import uk.co.smartkey.jforumsecuresso.SecurityTools

class UserController extends BaseController {
    
    public static final String LOGIN_COOKIE_NAME = "loginCookie"

    public static final  String DEFAULT_SALT = "hi234z2ejgrr97otw4ujzt4wt7jtsr4975FERedefef"  // only for old users before per-user-salt was introduced
    
    public static final int LOGIN_COOKIE_AGE = (60*60*24*365)/2   // half a year
    
    def beforeInterceptor = [action: this.&auth, 
                             except: ['login', 'register', 'doRegister', 'confirmRegistration',
                                      'lostPassword', 'requestPasswordReset', 'confirmPasswordReset',
                                      'resetPassword', 'profile']]

    static def allowedMethods = [delete:'POST', save:'POST', update:'POST', doRegister:'POST',
                                 confirmPasswordReset: 'GET', requestPasswordReset:'POST']
    
    static final int MIN_PASSWORD_LENGTH = 4

    def index = {
        redirect(action:list,params:params)
    }

    def profile = {
      ThesaurusUser user = ThesaurusUser.get(params.uid)
      if (!user) {
          throw new Exception("No user for id '${params.uid.encodeAsHTML()}'")
      }
      String visibleName = user.realName ? user.realName : "#" + user.id
      [user:user, visibleName:visibleName]
    }

    def register = {
      []
    }
    
    def doRegister = {
      String salt = getRandomSalt()
      String hashedPassword = md5sum(params.password1, salt)
      def user = new ThesaurusUser(params.userId, hashedPassword, salt, ThesaurusUser.USER_PERM)
      user.realName = params.visibleName
      checkCaptcha(params, user)
      if (!params.userId || params.userId.trim().isEmpty() || !params.userId.contains("@")) {
        log.warn("Registration: user entered invalid email address: '${params.userId}'")
        user.errors.reject('thesaurus.error', [].toArray(), message(code:'user.register.missing.email'))
        render(view:'register', model:[user:user], contentType:"text/html", encoding:"UTF-8")
        return
      }
      if (!params.acceptLicense) {
        log.warn("Registration: user didn't accept license: '${params.userId}'")
        user.errors.reject('thesaurus.error', [].toArray(), message(code:'user.register.missing.license'))
        render(view:'register', model:[user:user], contentType:"text/html", encoding:"UTF-8")
        return
      }
      if (!params.visibleName || params.visibleName.trim().isEmpty()) {
        log.warn("Registration: user entered invalid visible name: '${params.visibleName}'")
        user.errors.reject('thesaurus.error', [].toArray(), message(code:'user.register.missing.visible.name'))
        render(view:'register', model:[user:user], contentType:"text/html", encoding:"UTF-8")
        return
      }
      if (ThesaurusUser.findByRealName(params.visibleName)) {
        log.warn("Registration: user entered existing visible name: '${params.visibleName}'")
        user.errors.reject('thesaurus.error', [].toArray(), message(code:'user.register.user.visible.name.exists'))
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
          body message(code:'user.register.email.body', args:[activationLink], encodeAs: 'Text') 
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

    def changePassword = {
      ThesaurusUser user = session.user
      [user:user]
    }

    def doChangePassword = {
      ThesaurusUser origUser = session.user
      ThesaurusUser user = ThesaurusUser.get(origUser.id)
      checkPasswords(user)
      if (user.errors.allErrors.size() > 0) {
        flash.message = user.errors.allErrors[0].defaultMessage
        render(view:'changePassword', model:[user:user], contentType:"text/html", encoding:"UTF-8")
        return
      }
      savePassword(user, params.password1)
      flash.message = message(code:'user.change.password.changed')
      redirect(action: 'edit')
    }

    private def checkCaptcha(params, ThesaurusUser user) {
      if (ThesaurusConfigurationEntry.findByKey('captcha.question')) {
        List expectedAnswers = ThesaurusConfigurationEntry.findAllByKey('captcha.answer')
        if (expectedAnswers.size() == 0) {
          throw new Exception("No possible captcha answers found")
        }
        boolean foundCorrectAnswer = false
        for (expectedAnswer in expectedAnswers) {
          if (params.cap?.toLowerCase()?.trim() == expectedAnswer.value) {
            foundCorrectAnswer = true
            break
          }
        }
        if (!foundCorrectAnswer) {
          log.warn("Registration failed: user " + user + " entered invalid captcha: '${params.cap}'")
          user.errors.reject('thesaurus.error', [].toArray(), message(code: 'user.register.missing.captcha'))
          render(view: 'register', model: [user: user], contentType: "text/html", encoding: "UTF-8")
        }
      }
    }

    private String getRandomSalt() {
      return Math.random() + Math.random()*0.33 + ""
    }
    
    private checkPasswords(ThesaurusUser user) {
      if (params.password1 != params.password2) {
        log.warn("Registration or password update failed: passwords didn't match")
        user.errors.reject('thesaurus.error', [].toArray(), message(code:'user.register.different.passwords'))
      }
      if (params.password1.length() < MIN_PASSWORD_LENGTH) {
        log.warn("Registration or password update failed: password too short (${params.password1.length()} chars)")
        user.errors.reject('thesaurus.error', [].toArray(), message(code:'user.register.short.password', args:[MIN_PASSWORD_LENGTH]))
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
        log.warn("Confirming registration had happened before for user ${user}, ${params.code}")
        flash.message = message(code:'user.register.account.confirmed.already')
        redirect(url:grailsApplication.config.thesaurus.serverURL)     // go to homepage
      } else {
        if (user.confirmationCode != params.code) {
          throw new Exception("Confirmation code invalid for ${params.userId}, ${params.code} != ${user.confirmationCode}")
        }
        user.confirmationDate = new Date()
        log.info("Confirming registration successful for ${params.userId}, ${params.code}")
        flash.message = message(code:'user.register.account.activated')
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
          ThesaurusUser user = ThesaurusUser.findByUserId(params.userId)
          String salt = user?.salt
          if (salt == null) {
            // user created before per-user salts where introduced
            salt = DEFAULT_SALT
          }
          if (user && user.password != md5sum(params.password, salt)) {
            user = null
          }
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
            if (params.logincookie) {
                addDurationSession(session, response, user)
            }
            user.lastLoginDate = new Date()
            def redirectParams = 
              session.origParams ? session.origParams : [uri:"/"]
            if (redirectParams?.origId) {
                redirectParams.id = redirectParams.origId
            }
            // TODO: there must be a better way for this "redirect after 
            // login" problem (maybe "originalRequestParameters"?)
            boolean forumRedirect = params.returnUrl && isOurOwnUrl(params.returnUrl)
            if (forumRedirect) {
                // no direct redirect because the cookies need to be set first in the user's browser
                // *before* he arrives at the forum page:
                redirect(action:'redirect', params:[url: params.returnUrl])
            } else if (redirectParams?.controller && redirectParams?.action) {
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
            ThesaurusUser userById = ThesaurusUser.findByUserId(params.userId)
            if (userById && userById.password == '__expired__') {
              log.warn("login failed for user ${params.userId} (${IpTools.getRealIpAddress(request)}): account has expired")
              flash.message = message(code:'user.invalid.login.expired', args:[createLink(controller: 'user', action: 'lostPassword', params: [userId: userById.userId])])
              return
            } else {
              ThesaurusUser tmpUser = ThesaurusUser.findByUserId(params.userId)
              log.warn("login failed for user ${params.userId} (${IpTools.getRealIpAddress(request)}), user object: ${tmpUser}, salt: ${tmpUser?.salt}")
              flash.message = message(code:'user.invalid.login')
            }
          }
        }
    }

    boolean isOurOwnUrl(String url) {
        return (url.startsWith("http://www.openthesaurus.de") || url.startsWith("https://www.openthesaurus.de"))
    }

    def redirect = {
        if (isOurOwnUrl(params.url)) {
            redirect(url: params.url)
        } else {
            log.warn("Someone tried to redirect to url '${params.url}', which is not allowed. Showing error message.")
            render "Error: invalid redirect URL"
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
        cleanCookie(response, LOGIN_COOKIE_NAME)
        cleanCookie(response, SecurityTools.FORUM_COOKIE_NAME)
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
          body message(code:'user.lost.password.email.body', args:[params.userId, activationLink], encodeAs: 'Text') 
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
        savePassword(user, params.password1)
        [user: user]
    }

    private void savePassword(ThesaurusUser user, String password) {
        String salt = getRandomSalt()
        user.password = md5sum(password, salt)
        user.salt = salt
        boolean saved = user.validate() && user.save()
        if (!saved) {
          throw new Exception("Could not save new password: ${user.errors}")
        }
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
          int eventCount = UserEvent.countByByUser(user)
          return [ user: user, eventCount: eventCount ]
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
        //TODO: make this work again
        /*ThesaurusUser user = new ThesaurusUser(params)
        user.password = md5sum(params.password)
        if(!user.hasErrors() && user.save()) {
            flash.message = "User ${user.id} created"
            log.info("User ${user.userId} created")
            redirect(action:edit,id:user.id)
        }
        else {
            render(view:'create',model:[user:user])
        }*/
    }

    public static String md5sum(String str, String salt) {
        if (salt == null) {
          // a pseudo-random salt:
          salt = DEFAULT_SALT
        }
        str = str + "/" + salt
        MessageDigest md = MessageDigest.getInstance("MD5")
        md.update(str.getBytes(), 0, str.length())
        byte[] md5sum = md.digest()
        BigInteger bigInt = new BigInteger(1, md5sum)
        return bigInt.toString(16)
    }

    private void cleanCookie(def response, String cookieName) {
      Cookie[] cookies = request.getCookies()
      for (cookie in cookies) {
        if (cookie.getName() == cookieName) {
          cookie.setMaxAge(0)		// effectively deletes the cookie
          cookie.setPath("/")
          response.addCookie(cookie)
          break
        }
      }
    }
    
    private void addDurationSession(def session, def response, ThesaurusUser user) {
      Cookie loginCookie = new Cookie(LOGIN_COOKIE_NAME, session.id)
      loginCookie.setMaxAge(LOGIN_COOKIE_AGE)
      loginCookie.setPath("/")
      response.addCookie(loginCookie)
      DurationSession dSession = new DurationSession(sessionId:session.id, user:user, insertDate:new Date())
      if (!dSession.save()) {
        throw new Exception("could not save duration session: ${dSession.errors}")
      }
    }
    
}
 