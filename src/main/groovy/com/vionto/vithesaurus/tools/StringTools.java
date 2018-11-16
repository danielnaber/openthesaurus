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
package com.vionto.vithesaurus.tools;

import java.io.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Some useful tools for dealing with Strings.
 */
public class StringTools {

  private static final int BUFFER_SIZE = 4096;

  // based on http://www.codinghorror.com/blog/2008/10/the-problem-with-urls.html:
  private static final Pattern URL_PATTERN = Pattern.compile("\\(?\\bhttps?://..\\.wikipedia.org/[-A-Za-z0-9+&@#/%?=~_()|!:,.;]*[-A-Za-z0-9+&@#/%=~_()|]");

  private StringTools() {
    // static methods only, no public constructor
  }

  public static String slashEscape(String str) {
    return str.replace("/", "___");
  }

  public static String slashUnescape(String str) {
    return str.replace("___", "/");
  }

  public static String wikipediaUrlsToLinks(String textWithUrls) {
    Matcher matcher = URL_PATTERN.matcher(textWithUrls);
    return matcher.replaceAll("<a href='$0'>Wikipedia</a>");
  }

  /**
   * Normalize the word for the 'normalizedWord' field.
   */
  public static String normalize(String word) {
    return cleanWord(word).replaceAll("\\(.*?\\)", "").replaceAll("\\s+", " ").trim();
  }

  public static String normalizeParenthesis(String word) {
    return word.replaceAll("\\(.*?\\)", "").replaceAll("\\s+", " ").trim();
  }

  /**
   * Normalize the word for the 'normalizedWord2' field.
   */
  public static String normalize2(String word) {
    return cleanWord(word).replace("(", "").replace(")", "").replaceAll("\\s+", " ").trim();
  }

  private static String cleanWord(String word) {
    // this way we can find "nörgeln" when the user searches for "noergeln" (e.g. because they have no German keyboard):
    return word.replaceAll("[.!?,]", "")
               .replace("Ä", "Ae").replace("ä", "ae")
               .replace("Ü", "Ue").replace("ü", "ue")
               .replace("Ö", "Oe").replace("ö", "oe")
               .replace("ß", "ss");
  }
  
  public static String normalizeForSort(String s) {
    return normalize(s.toLowerCase().replace('ä', 'a').replace('ü', 'u').replace('ö', 'o').replace("ß", "ss"));
  }

  /**
   * Replaces all occurrences of<br>
   * <code>&lt;, &gt;, &amp;</code> <br>
   * with <br>
   * <code>&amp;lt;, &amp;gt;, &amp;amp;</code><br>
   */
  public static String replaceHtmlMarkupChars(final String str) {
    return str.replaceAll("&", "&amp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;");
  }

  /**
   * Write the contents of {@code file} to {@code out}.
   * @param file input file
   * @param out stream to be written to
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
