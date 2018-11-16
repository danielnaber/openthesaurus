package openthesaurus

import com.vionto.vithesaurus.DurationSession
import uk.co.smartkey.jforumsecuresso.SecurityTools

import javax.servlet.http.Cookie


class SSOForForumInterceptor {

    SSOForForumInterceptor() {
        matchAll()
    }

    boolean before() {
        if (session.user) {
            int cookieMaxAge
            DurationSession dSession = getDurationSession(request)
            if (dSession) {
                // user has checked the box to stay logged in, so do that for the forum, too
                cookieMaxAge = UserController.LOGIN_COOKIE_AGE
            } else {
                cookieMaxAge = -1  // end of browser session
            }
            setForumCookie(session, response, cookieMaxAge)
        }

        return true
    }

    boolean after() { true }

    void afterView() {
        // no-op
    }

    private DurationSession getDurationSession(request) {
        Cookie[] cookies = request.getCookies()
        for (cookie in cookies) {
            // "loginCookie" is the long-term cookie used to identify users
            // so they don't have to re-login on each visit:
            if (cookie.getName() == UserController.LOGIN_COOKIE_NAME) {
                DurationSession dSession = DurationSession.findBySessionId(cookie.getValue())
                if (dSession) {
                    log.debug("Using user's old session found in cookie: ${dSession.user}")
                    return dSession
                }
                break
            }
        }
        return null
    }

    private def setForumCookie(session, response, int cookieMaxAge) {
        String encryptedData = SecurityTools.getInstance().encryptCookieValues(session.user.userId, session.user.realName)
        Cookie cookie = new Cookie(SecurityTools.FORUM_COOKIE_NAME, encryptedData)
        cookie.maxAge = cookieMaxAge
        cookie.path = "/"
        response.addCookie(cookie)
    }
}
