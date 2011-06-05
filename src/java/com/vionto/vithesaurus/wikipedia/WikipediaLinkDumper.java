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
 * Loads links from a Wikipedia XML dump and builds an SQL dump (for MySQL).
 * Contains some filtering that is specific to German.
 * 
 * Get the Wikipedia XML dump from http://download.wikimedia.org/backup-index.html,
 * the filename is something like "XXwiki-YYYYMMDD-pages-articles.xml.bz2",
 * whereas XX is the language code (de, en, fr, etc).
 * 
 * How to use this (starting from the openthesaurus directory):
 * -Change to the "java" directory
 *  cd src/java
 * -unpack the Wikipedia XML dump here:
 *  bunzip XXwiki-YYYYMMDD-pages-meta-current.xml.bz2
 * -Only if you made changes to this source code: compile the link 
 *  extraction Java program (requires the Java Development Kit):
 *  javac com/vionto/vithesaurus/WikipediaLinkDumper.java
 * -Call the program:
 *  java -cp . com.vionto.vithesaurus.WikipediaLinkDumper <wiki.xml> >result.sql
 * -Import the result into the OpenThesaurus database:
 *  mysql thesaurus <result.sql 
 * 
 * @author Daniel Naber
 */
public class WikipediaLinkDumper {
  
  private WikipediaLinkDumper() {
  }

  private void run(final InputStream is) throws IOException, SAXException, ParserConfigurationException {
    final WikipediaPageHandler handler = new WikipediaPageHandler();
    final SAXParserFactory factory = SAXParserFactory.newInstance();
    final SAXParser saxParser = factory.newSAXParser();
    saxParser.getXMLReader().setFeature("http://apache.org/xml/features/nonvalidating/load-external-dtd",
        false);  
    System.out.println("SET NAMES utf8;");
    System.out.println("DROP TABLE IF EXISTS wikipedia_pages;");
    System.out.println("CREATE TABLE `wikipedia_pages` ( " + 
        "`page_id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY , " + 
        "`title` VARCHAR( 100 ) NOT NULL " + 
        ") ENGINE = MYISAM;");
    System.out.println("DROP TABLE IF EXISTS wikipedia_links;");
    System.out.println("CREATE TABLE `wikipedia_links` ( " + 
        " `page_id` INT NOT NULL , " + 
        " `link` VARCHAR( 100 ) NOT NULL " + 
        ") ENGINE = MYISAM;");
    saxParser.parse(is, handler);
    System.out.println("ALTER TABLE `wikipedia_pages` ADD INDEX ( `page_id` );");
    System.out.println("ALTER TABLE `wikipedia_pages` ADD INDEX ( `title` );");
    System.out.println("ALTER TABLE `wikipedia_links` ADD INDEX ( `page_id` );");
  }

  public static void main(final String[] args) throws Exception {
    if (args.length != 1) {
      System.out.println("Usage: WikipediaLinkDumper <xmldump>");
      System.exit(1);
    }
    final WikipediaLinkDumper prg = new WikipediaLinkDumper();
    prg.run(new FileInputStream(args[0]));
  }

  class WikipediaPageHandler extends DefaultHandler {
    
    private static final int UNDEF = 0;
    private static final int TITLE = 1;
    private static final int TEXT = 2;

    private static final int MAX_LINKS_PER_PAGE = 15;

    private int position = UNDEF;
      
    private StringBuilder title = new StringBuilder();
    private StringBuilder text = new StringBuilder();
    
    private int pageCount = 0;

    private final Pattern NUM_PATTERN = Pattern.compile("\\d+");

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
        pageCount++;
        // test:
        //if (pageCount > 5000)
        //  System.exit(1);
        System.out.println("INSERT INTO wikipedia_pages VALUES ("+pageCount+", '" +
            escape(title.toString().trim())+ "');");
        title = new StringBuilder();
      } else if (qName.equals("text")) {
        final List<String> links = extractLinks(text.toString());
        for (String link : links) {
          System.out.println("INSERT INTO wikipedia_links VALUES (" +pageCount+ ", '"
              +escape(link)+ "');");
        }
        text = new StringBuilder();
      } else {
        position = UNDEF;
      }
    }
    
    private String escape(String str) {
      return str.replace("'", "''").replace("\\", "");
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

    private List<String> extractLinks(String wikiText) {
      int pos = 0;
      final List<String> links = new ArrayList<String>();
      while (true) {
        pos = wikiText.indexOf("[[", pos);
        if (pos == -1) {
          break;
        }
        final int endPos = wikiText.indexOf("]]", pos+1);
        if (endPos == -1) {
          break;
        }
        String linkText = wikiText.substring(pos+2, endPos);
        pos = endPos;
        String[] parts = linkText.split("\\|");
        if (parts.length == 2) {
          linkText = parts[0];
        }
        final Matcher numMatcher = NUM_PATTERN.matcher(linkText);
        if (numMatcher.matches()) {   // filter numbers (e.g. years like "1972")
          continue;
        }
        if (linkText.startsWith("Bild:") || linkText.startsWith("Kategorie:") || linkText.startsWith("Image:")) {
          continue;
        }
        if (linkText.startsWith("#")) {    // often not useful
          continue;
        }
        parts = linkText.split("#");    // e.g. Flugzeug#Flugsteuerung -> Flugzeug
        if (parts.length == 2) {
          linkText = parts[0];
        }
        linkText = linkText.replace('_', ' ');
        
        if (linkText.indexOf(':') != -1) { // filter language links ("en:" etc)) {
          continue;
        }
        links.add(linkText);
        if (links.size() >= MAX_LINKS_PER_PAGE) {
          break;
        }
      }
      return links;
    }
    
  }

}
