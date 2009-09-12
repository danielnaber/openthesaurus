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

  private StringTools() {
    // static methods only, no public constructor
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
   * like "replaceAtPosition", but only replaces the numbers of characters that are given by
   * "length"
   */
  public static String replaceCertainPartAtPosition(final int position, final int length, 
      final String replacement, final String string) {

    if (replacement == null)
      return string;
    if (position < 0 || position > (string.length() - 1) || string == null)
      return null;
    return string.substring(0, position) + replacement
        + string.substring(position + length, string.length());
  }

  /**
   * replaces a substring in "string" at a given "position" by "replacement"
   */
  public static String replaceAtPosition(final int position, final String replacement,
      final String string) {
    if (replacement == null) {
      return string;
    }
    if (position < 0 || position > (string.length() - 1) || string == null) {
      return null;
    }
    return string.substring(0, position) + replacement
        + string.substring(position + replacement.length(), string.length());
  }

  /**
   * returns all indices of all occurences of "substring" in "string"
   */
  public static int[] allIndexOf(final String substring, final String string) {

    if (!string.contains(substring)) {
      return null;
    }

    int[] returner = new int[countSubstrings(new String[] { substring }, string)];
    returner[0] = string.indexOf(substring, 0);

    for (int i = 1; i < returner.length; i++) {
      returner[i] = string.indexOf(substring, returner[i - 1] + 1);
    }
    return returner;
  }

  /**
   * counts the occurence of all "substrings" in "string"
   */
  public static int countSubstrings(final String[] substring, final String string) {

    int counter = substring.length;
    for (int i = 0; i < substring.length; i++) {
      if (substring[i] == null || !string.contains(substring[i])) {
        substring[i] = null;
        counter--;
      }
    }
    if (counter == 0) {
      return 0;
    }
    String[] realSubstring = new String[counter];

    int helper = 0;
    for (int i = 0; i < substring.length; i++) {
      if (substring[i] == null) {
        continue;
      }
      realSubstring[helper] = substring[i];
      helper++;

    }

    int lastIndex = findLastPosition(realSubstring, string);
    int aktuellePosition = findNextPosition(0, realSubstring, string);

    int returner = 1;

    while (aktuellePosition != lastIndex) {

      aktuellePosition = findNextPosition(aktuellePosition + 1, realSubstring, string);
      returner++;
    }

    return returner;
  }

  private static int findNextPosition(final int beginIndex, final String[] substring,
      final String string) {

    int returner = 4711;    //FIXME

    for (String temp : substring) {
      if (string.indexOf(temp, beginIndex) < returner && string.indexOf(temp, beginIndex) != -1)
        returner = string.indexOf(temp, beginIndex);
    }
    return returner;
  }

  private static int findLastPosition(final String[] substring, final String string) {

    int returner = -1;

    for (String temp : substring) {
      if (string.lastIndexOf(temp) > returner)
        returner = string.lastIndexOf(temp);
    }
    return returner;
  }

  /**
   * Write the contents if {@code file} to {@code out}.
   * @param file input file
   * @param out stream to be written to
   * @throws IOException
   */
  public static void writeToStream(final File file, final OutputStream out) throws IOException {
    final FileInputStream fis = new FileInputStream(file);
    final BufferedInputStream bis = new BufferedInputStream(fis);
    final byte[] chars = new byte[4096];
    int readbytes = 0;
    while (readbytes >= 0) {
      readbytes = bis.read(chars, 0, 4096);
      if (readbytes <= 0) {
        break;
      }
      out.write(chars, 0, readbytes);
    }
    bis.close();
    fis.close();
  }

}
