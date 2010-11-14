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
package com.vionto.vithesaurus.tools;

import javax.servlet.http.HttpServletRequest;
import java.util.Enumeration;

/**
 * Helper methods for dealing with IP addresses.
 */
public class IpTools {

    private IpTools() {
    }

    /**
     * Get user's IP, even if the web application is running behind Apache and
     * {@code request.getRemoteAddr()} thus always returns 127.0.0.1.
     * @return ip address or null
     */
    public static String getRealIpAddress(final HttpServletRequest request) {
        @SuppressWarnings("unchecked")
        final Enumeration<String> headers = request.getHeaders("X-Forwarded-For");
        if (headers == null) {
            return null;
        } else {
            while (headers.hasMoreElements()) {
                final String[] ips = headers.nextElement().split(",");
                for (String ip : ips) {
                    final String proxy = ip.trim();
                    if (!"unknown".equals(proxy) && !proxy.isEmpty()) {
                        return proxy;
                    }
                }
            }
        }
        return request.getRemoteAddr();
    }

}
