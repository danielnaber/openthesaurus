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

class UserEventController extends BaseController {
    
    def index = { redirect(action:list,params:params) }

    /**
     * List the user events, enriched with information calculated
     * on-the-fly, e.g. object difference display.
     */
    def list = {
        String sortCrit = "creationDate"
        if (params.sort) sortCrit = params.sort
        if (!params.order) params.order = "desc"
        params.max = params.max ? Integer.parseInt(params.max) : 10
        params.offset = params.offset ? Integer.parseInt(params.offset) : 0
        if (params.jumpToPage) {
            params.offset = (Integer.parseInt(params.jumpToPage) - 1) * params.max
        }
        
        def crit = UserEvent.createCriteria()
        int totalMatches = crit.count {
            if (params.userId) {
                or {
                    byUser {
                        ilike('userId', params.userId)
                    }
                }
            }
        }
        
        def eventList = UserEvent.withCriteria {
            if (params.userId) {
                or {
                    byUser {
                        ilike('userId', params.userId)
                    }
                }
            }
            maxResults(params.max)
            firstResult(params.offset)
            order(sortCrit, params.order)
        }
        
        def diffs = [:]
        def typeNames = [:]
        UserEventTools tools = new UserEventTools()
        tools.buildMetaInformation(eventList, diffs, typeNames)
        [ userEventList: eventList, diffs: diffs, typeNames : typeNames,
          totalMatches: totalMatches ]
    }

}