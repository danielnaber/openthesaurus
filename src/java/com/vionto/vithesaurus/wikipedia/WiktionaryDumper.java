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
package com.vionto.vithesaurus.wikipedia;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.xml.parsers.ParserConfigurationException;
import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;

import org.xml.sax.Attributes;
import org.xml.sax.SAXException;
import org.xml.sax.SAXParseException;
import org.xml.sax.helpers.DefaultHandler;

/**
 * Loads links from a Wiktionary XML dump and builds an SQL dump (for MySQL).
 * Contains some filtering that's specific the German.
 * 
 * Get the XML dump from http://download.wikimedia.org/dewiktionary/latest/,
 * the filename is something like "XXwiktionary-YYYYMMDD-pages-articles.xml.bz2",
 * whereas XX is the language code (de, en, fr, etc).
 * 
 * @author Daniel Naber
 */
public class WiktionaryDumper {

  /** Lines starting with this string indicate the "meanings" section in a Wiktionary page. */
  private static final String MEANINGS_PREFIX = "{{Bedeutungen}}";

  /** Lines starting with this string indicate the "synonyms" section in a Wiktionary page. */
  private static final String SYNONYMS_PREFIX = "{{Synonyme}}";

  /** String required in a document, other documents will be ignored. */
  private static final String LANGUAGE_STRING = "{{Sprache|Deutsch}}";
  
  /** Lines starting with this string indicate a new section in a Wiktionary page. */
  private static final String SECTION_PREFIX = "{{";

  private final Pattern XML_COMMENT_PATTERN = Pattern.compile("<!--.*?-->", Pattern.DOTALL);

  private WiktionaryDumper() {
  }

  private void run(final InputStream is) throws IOException, SAXException, ParserConfigurationException {
    final WiktionaryPageHandler handler = new WiktionaryPageHandler();
    final SAXParserFactory factory = SAXParserFactory.newInstance();
    final SAXParser saxParser = factory.newSAXParser();
    saxParser.getXMLReader().setFeature("http://apache.org/xml/features/nonvalidating/load-external-dtd",
        false);  
    System.out.println("SET NAMES utf8;");
    System.out.println("DROP TABLE IF EXISTS wiktionary;");
    System.out.println("CREATE TABLE `wiktionary` ( " + 
        "`headword` varchar(255) NOT NULL default '', " + 
        "`meanings` text, " + 
        "`synonyms` text, " +
        "KEY `headword` (`headword`)" +
        ") ENGINE = MYISAM;");
    saxParser.parse(is, handler);
    System.err.println("Exported: " + handler.exported);
    System.err.println("Skipped: " + handler.skipped);
  }

  public static void main(final String[] args) throws Exception {
    if (args.length != 1) {
      System.out.println("Usage: WiktionaryDumper <xmldump>");
      System.exit(1);
    }
    final WiktionaryDumper prg = new WiktionaryDumper();
    prg.run(new FileInputStream(args[0]));
  }

  class WiktionaryPageHandler extends DefaultHandler {
    
    private static final int UNDEF = 0;
    private static final int TITLE = 1;
    private static final int TEXT = 2;
    
    private int position = UNDEF;
    
    private int exported = 0;
    private int skipped = 0;

    private StringBuilder title = new StringBuilder();
    private StringBuilder text = new StringBuilder();
    
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
     
    @Override
    @SuppressWarnings("unused")
    public void endElement(String namespaceURI, String sName, String qName) {
      if (qName.equals("title")) {
        if (title.indexOf(":") >= 0) {    // page in a namespace
          title = new StringBuilder();
        }
        
      } else if (qName.equals("text")) {
        if (title.length() > 0) {
          if (text.indexOf(LANGUAGE_STRING) == -1) {
            skipped++;
          } else {
            final String cleanedText = clean(text.toString());
            final List<String> meaningsList = getSection(cleanedText, MEANINGS_PREFIX);
            final String meanings = join(meaningsList, " ");
            final List<String> synonymsList = getSection(cleanedText, SYNONYMS_PREFIX);
            final String synonyms = join(synonymsList, " ");
            System.out.printf("INSERT INTO wiktionary (headword, meanings, synonyms) VALUES ('%s', '%s', '%s');\n",
                escape(title.toString()), escape(meanings), escape(synonyms));
            exported++;
          }
        }
        text = new StringBuilder();
        title = new StringBuilder();
      }
      position = UNDEF;
    }
    
    private String clean(String str) {
      final Matcher matcher = XML_COMMENT_PATTERN.matcher(str);
      return matcher.replaceAll("");
    }

    private List<String> getSection(final String text, final String prefix) {
      final List<String> terms = new ArrayList<String>();
      final Scanner scanner = new Scanner(text);
      boolean inSynonymList = false;
      while (scanner.hasNextLine()) {
        final String line = scanner.nextLine();
        if (line.trim().startsWith(prefix)) {
          inSynonymList = true;
        } else if (inSynonymList && line.trim().startsWith(SECTION_PREFIX)) {
          // next section starts
          break;
        } else if (inSynonymList) {
          terms.add(line);
        }
      }
      scanner.close();
      return terms;
    }

    private String escape(String str) {
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

    private String join(final List<String> list, final String delimiter) {
      final StringBuilder sb = new StringBuilder();
      for (String element : list) {
        sb.append(element);
        sb.append(delimiter);
      }
      return sb.toString();
    }

  }

}
