package openthesaurus

import com.vionto.vithesaurus.DurationSession

import javax.servlet.http.Cookie


class RestoreSessionInterceptor {

    RestoreSessionInterceptor() {
        matchAll()
    }

    boolean before() {
        restoreSessionIfPossible(session, request)
        return true
    }

    boolean after() { true }

    void afterView() {
        // no-op
    }

    private void restoreSessionIfPossible(def session, def request) {
        if (!session.user) {
            // user doesn't have a login session yet. look at cookies so users can stay logged in (almost) forever:
            DurationSession dSession = getDurationSession(request)
            if (dSession) {
                session.user = dSession.user
            }
        }
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

}
