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

import net.sourceforge.wurfl.wall.TagUtil;
import net.sourceforge.wurfl.wurflapi.CapabilityMatrix;
import net.sourceforge.wurfl.wurflapi.ObjectsManager;
import net.sourceforge.wurfl.wurflapi.UAManager;

public class BrowserDetection {
  
  private BrowserDetection() {
    // no public constructor, static methods only
  }

  /**
   * Guess if user is probably using a mobile device (mobile phone) with a small display.
   */
  public static boolean isMobileDevice(final HttpServletRequest request) {
      final String userAgent = TagUtil.getUA(request);
      final UAManager uaManager = ObjectsManager.getUAManagerInstance();
      final String deviceIDFromUA = uaManager.getDeviceIDFromUA(userAgent);
      final CapabilityMatrix capabilities = ObjectsManager.getCapabilityMatrixInstance();
      final String width = capabilities.getCapabilityForDevice(deviceIDFromUA, "resolution_width");
      int widthInt = 0;
      if (width != null) {
        widthInt = Integer.parseInt(width);
      }
      if (widthInt != 0 && widthInt < 800 && !"generic".equals(deviceIDFromUA)) {
        return true;
      }
      return false;
  }

}
