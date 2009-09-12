/**
 * vithesaurus - web-based thesaurus management tool
 * Copyright (C) 2009 Daniel Naber (www.danielnaber.de)
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

import javax.servlet.http.HttpServletRequest;

public class BrowserDetection {
  
  private BrowserDetection() {
    // no public constructor, static methods only
  }

  /**
   * Guess if user is probably using a mobile device (mobile phone) with a small display.
   */
  public static boolean isMobileDevice(final HttpServletRequest request) {
      final String userAgent = request.getHeader("User-Agent");
      if (userAgent == null) {
        return false;
      }
      // due to Problems with WURFL (license and technical) we're back at manually
      // checking the User-Agent:
      if (userAgent.contains("iPhone") || userAgent.contains("iPod")) {
        return true;
      } else if (userAgent.contains("Android ")) {
        return true;
      }
      return false;
  }

}
