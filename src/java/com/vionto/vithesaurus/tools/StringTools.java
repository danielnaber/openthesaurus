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
package com.vionto.vithesaurus.tools;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;

/**
 * Some useful tools for dealing with Strings.
 */
public class StringTools {

  private static final int BUFFER_SIZE = 4096;

  private StringTools() {
    // static methods only, no public constructor
  }

  public static String normalize(String word) {
    return word.replaceAll("\\(.*?\\)", "").trim();
  }
  
  public static String normalizeForSort(String s) {
    return normalize(s.toLowerCase().replace('ä', 'a').replace('ü', 'u').replace('ö', 'o').replace("ß", "ss"));
  }

  /**
   * Replaces all occurrences of<br>
   * <code>&lt;, &gt;, &amp;</code> <br>
   * with <br>
   * <code>&amp;lt;, &amp;gt;, &amp;amp;</code><br>
   * 
   * @param string
   *          The input string
   * @return The modified String, with replacements.
   */
  public static String replaceHtmlMarkupChars(final String string) {
    return string.replaceAll("&", "&amp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;");
  }

  /**
   * Write the contents if {@code file} to {@code out}.
   * @param file input file
   * @param out stream to be written to
   * @throws IOException
   */
  public static void writeToStream(final File file, final OutputStream out) throws IOException {
    final FileInputStream fis = new FileInputStream(file);
    try {
      final BufferedInputStream bis = new BufferedInputStream(fis);
      try {
        final byte[] chars = new byte[BUFFER_SIZE];
        int readBytes = 0;
        while (readBytes >= 0) {
          readBytes = bis.read(chars, 0, BUFFER_SIZE);
          if (readBytes <= 0) {
            break;
          }
          out.write(chars, 0, readBytes);
        }
      } finally {
        bis.close();
      }
    } finally {
      fis.close();
    }
  }

}
