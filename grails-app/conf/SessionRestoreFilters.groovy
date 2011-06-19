import javax.servlet.http.Cookie
import com.vionto.vithesaurus.DurationSession

/**
 * vithesaurus - web-based thesaurus management tool
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
    }
    
    private void restoreSessionIfPossible(def session, def request) {
        if (!session.user) {
            // user doesn't have a login session yet. look at cookies so users can stay logged in (almost) forever:
            Cookie[] cookies = request.getCookies()
            for (cookie in cookies) {
                // "loginCookie" is the long-term cookie used to identify users
                // so they don't have to re-login on each visit:
                if (cookie.getName() == UserController.LOGIN_COOKIE_NAME) {
                    DurationSession dSession = DurationSession.findBySessionId(cookie.getValue())
                    if (!dSession) {
                        //log.info("No DurationSession found for cookie ${cookie.getValue()}")
                    } else {
                        log.info("Using user's old session found in cookie: ${dSession.user}")
                        session.user = dSession.user
                    }
                    break
                }
            }
        }
    }
    
}
