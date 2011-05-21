import javax.servlet.http.HttpServletRequest
import com.vionto.vithesaurus.tools.IpTools

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

/**
 * Helper methods to protect pages by login.
 */
abstract class BaseController {

    /**
     * Used to totally block access.
     */
    def noAccess() {
        log.info("Access denied to no-access area")
        return false
    }

    /**
     * Allows access only for requests coming from 127.0.0.1
     */
    def localHostAuth() {
        if (isLocalHost(request)) {
          return true
        }
        log.info("Access denied to no-access area for host " + IpTools.getRealIpAddress(request) + ", " + request.getRequestURI())
        return false
    }

    public boolean isLocalHost(HttpServletRequest request) {
        String ip = IpTools.getRealIpAddress(request)
        return ip == "127.0.0.1" || ip == "0:0:0:0:0:0:0:1" || ip == "::1"
    }

    /**
     * Redirect and return false if user isn't authenticated. To be used
     * with beforeInterceptor action.
     */
    def auth() {
        if (!session.user) {
            storeParams()
            flash.message = message(code:'user.please.login')
            redirect(controller:'user', action:'login')
            return false
        }
        if (session.user.blocked) {
            flash.message = message(code:'user.please.login')
            log.warn("Denying access to blocked user ($user)")
            return false
        }
     }

    /**
     * Return true if current user is authenticated and
     * has admin permission.
     */
    def isAdmin() {
        boolean isAdmin = false
        if (!session.user) {
            isAdmin = false
        } else {
            if (session.user.hasAdminPermissions()) {
                isAdmin = true
            }
        }
        return isAdmin
    }

    /**
     * Redirect and return false if user isn't authenticated as admin.
     * To be used with beforeInterceptor action.
     */
    def adminAuth() {
        if (!isAdmin()) {
            storeParams()
            flash.message = "You must login with admin-rights to access this area."
            redirect(controller:'user', action:'login')
            return false
        }
    }

    /**
     * Remember request params in the session for useful redirect
     * if login succeeds.
     */
    private void storeParams() {
        def origParams = [controller:controllerName,
                         action:actionName]
        origParams.putAll(params)
        session.origParams = origParams
    }

}
