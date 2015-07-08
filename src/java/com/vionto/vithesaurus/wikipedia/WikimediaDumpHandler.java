/**
 * OpenThesaurus - web-based thesaurus management tool
 * Copyright (C) 2015 Daniel Naber (www.danielnaber.de)
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
package com.vionto.vithesaurus.wikipedia;

import org.xml.sax.Attributes;
import org.xml.sax.SAXException;
import org.xml.sax.SAXParseException;
import org.xml.sax.helpers.DefaultHandler;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class WikimediaDumpHandler extends DefaultHandler {

  private static final Pattern XML_COMMENT_PATTERN = Pattern.compile("<!--.*?-->", Pattern.DOTALL);
  
  protected static final int UNDEF = 0;
  
  private static final int TITLE = 1;
  private static final int TEXT = 2;
  
  protected int position = UNDEF;
  protected StringBuilder title = new StringBuilder();
  protected StringBuilder text = new StringBuilder();

  @Override
  public void warning (final SAXParseException e) throws SAXException {
    throw e;
  }

  @Override
  public void error (final SAXParseException e) throws SAXException {
    throw e;
  }

  @Override
  @SuppressWarnings("unused")
  public void startElement(String namespaceURI, String lName,
                           String qName, Attributes attrs) {
    if (qName.equals("title")) {
      position = TITLE;
    } else if (qName.equals("text")) {
      position = TEXT;
    } else {
      position = UNDEF;
    }
  }

  protected String clean(String str) {
    final Matcher matcher = XML_COMMENT_PATTERN.matcher(str);
    return matcher.replaceAll("");
  }

  protected String escape(String str) {
    // >'''< means bold, >''< means italics in MediaWiki - remove those, then escape >'< for MySQL: 
    return str.replace("'''", "").replace("''", "").replace("'", "''");
  }

  @Override
  public void characters(final char[] buf, final int offset, final int len) {
    final String s = new String(buf, offset, len);
    if (position == TITLE) {
      title.append(s);
    } else if (position == TEXT) {
      text.append(s);
    }
  }

}
