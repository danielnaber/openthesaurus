package openthesaurus

import com.vionto.vithesaurus.tools.IpTools
import grails.gorm.transactions.Transactional

import javax.servlet.http.HttpServletRequest

@Transactional
class AuthService {

    /**
     * Return true if current user is authenticated and
     * has admin permission.
     */
    def isAdmin(session) {
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
     * Remember request params in the session for useful redirect
     * if login succeeds.
     */
    void storeParams(session, params) {
        def origParams = [controller:params['controller'],
                          action:params['action']]
        origParams.putAll(params)
        session.origParams = origParams
    }

    /**
     * Allows access only for requests coming from 127.0.0.1
     */
    def localHostAuth(HttpServletRequest request) {
        if (IpTools.isLocalHost(request)) {
            return true
        }
        log.info("Access denied to no-access area for host " + IpTools.getRealIpAddress(request) + ", " + request.getRequestURI())
        return false
    }
}
