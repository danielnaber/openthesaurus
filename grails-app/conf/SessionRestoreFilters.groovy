import javax.servlet.http.Cookie
import com.vionto.vithesaurus.DurationSession
import uk.co.smartkey.jforumsecuresso.SecurityTools

/**
 * OpenThesaurus - web-based thesaurus management tool
 * Copyright (C) 2011 Daniel Naber (www.danielnaber.de)
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
class SessionRestoreFilters {
    
    def filters = {
        restoreSessionFilter(controller:'*', action:'*') {
            before = {
                restoreSessionIfPossible(session, request)
                return true
            }            
        }
        ssoForForumFilter(controller:'*', action:'*') {
            before = {
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
            }
        }
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
                    log.info("Using user's old session found in cookie: ${dSession.user}")
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
