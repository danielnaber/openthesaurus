/**
 * vithesaurus - web-based thesaurus management tool
 * Copyright (C) 2010 Daniel Naber (www.danielnaber.de)
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
package com.vionto.vithesaurus;

import java.util.Date;
import java.util.List;

/**
 * Shallow information about a request against our API.
 */
public class ApiRequestEvent {

    private String remoteIpAddress;
    private Date date;

    public ApiRequestEvent(String remoteIpAddress, Date date) {
        this.remoteIpAddress = remoteIpAddress;
        this.date = date;
    }

    public String getRemoteIpAddress() {
        return remoteIpAddress;
    }

    public Date getDate() {
        return date;
    }

    @Override
    public String toString() {
        return remoteIpAddress + "@" + date;
    }

    public static boolean limitReached(String remoteIpAddress, List<ApiRequestEvent> requestEvents, int maxAgeSeconds, int maxRequests) {
        int requestsByIp = 0;
        boolean limitedReached = false;
        // all requests before this date are considered old:
        final Date thresholdDate = new Date(System.currentTimeMillis() - maxAgeSeconds * 1000);
        for (ApiRequestEvent requestEvent : requestEvents) {
            if (requestEvent.getRemoteIpAddress().equals(remoteIpAddress) && requestEvent.getDate().after(thresholdDate)) {
                requestsByIp++;
                if (requestsByIp > maxRequests) {
                    limitedReached = true;
                    break;
                }
            }
        }
        return limitedReached;
    }

}
