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

package openthesaurus

import javax.servlet.http.HttpServletRequest
import com.vionto.vithesaurus.tools.IpTools

/**
 * Helper methods to protect pages by login.
 */
abstract class BaseController {

    def readOnlyMode() {
        return grailsApplication.config.thesaurus.readOnly == 'true'
    }

    /**
     * Used to totally block access.
     */
    def noAccess() {
        log.info("Access denied to no-access area")
        return false
    }
}
