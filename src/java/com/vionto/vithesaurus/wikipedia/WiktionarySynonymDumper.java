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
package com.vionto.vithesaurus.wikipedia;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;

import javax.xml.parsers.ParserConfigurationException;
import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;

import org.apache.commons.lang.StringUtils;
import org.xml.sax.SAXException;

/**
 * Loads synonyms from a Wiktionary XML dump and builds an SQL dump (for MySQL).
 * Contains some filtering that's specific to German.
 * 
 * Get the XML dump from http://download.wikimedia.org/dewiktionary/latest/,
 * the filename is something like "XXwiktionary-YYYYMMDD-pages-articles.xml.bz2",
 * whereas XX is the language code (de, en, fr, etc).
 * 
 * @author Daniel Naber
 */
public class WiktionarySynonymDumper {

  /** String required in a document, other documents will be ignored. */
  private static final String LANGUAGE_STRING = "{{Sprache|Deutsch}}";

  /** Lines starting with this string indicate the "meanings" section in a Wiktionary page. */
  private static final String MEANINGS_PREFIX = "{{Bedeutungen}}";

  /** Lines starting with this string indicate the "synonyms" section in a Wiktionary page. */
  private static final String SYNONYMS_PREFIX = "{{Synonyme}}";

  /** Lines starting with this string indicate a new section in a Wiktionary page. */
  private static final String SECTION_PREFIX = "{{";

  private WiktionarySynonymDumper() {
  }

  private void run(InputStream is) throws IOException, SAXException, ParserConfigurationException {
    WiktionaryPageHandler handler = new WiktionaryPageHandler();
    SAXParserFactory factory = SAXParserFactory.newInstance();
    SAXParser saxParser = factory.newSAXParser();
    saxParser.getXMLReader().setFeature("http://apache.org/xml/features/nonvalidating/load-external-dtd", false);  
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

  public static void main(String[] args) throws Exception {
    if (args.length != 1) {
      System.out.println("Usage: WiktionarySynonymDumper <xmldump>");
      System.out.println("   <xmldump> is an unzipped XML dump from http://dumps.wikimedia.org/dewiktionary/, e.g. 'dewiktionary-20140725-pages-articles.xml.bz2'");
      System.exit(1);
    }
    WiktionarySynonymDumper prg = new WiktionarySynonymDumper();
    prg.run(new FileInputStream(args[0]));
  }

  class WiktionaryPageHandler extends WikimediaDumpHandler {
    
    private int exported = 0;
    private int skipped = 0;

    @Override
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
            String cleanedText = clean(text.toString());
            List<String> meaningsList = getSection(cleanedText, MEANINGS_PREFIX);
            String meanings = StringUtils.join(meaningsList, " ");
            List<String> synonymsList = getSection(cleanedText, SYNONYMS_PREFIX);
            String synonyms = StringUtils.join(synonymsList, " ");
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
    
    private List<String> getSection(String text, String prefix) {
      List<String> terms = new ArrayList<>();
      try (Scanner scanner = new Scanner(text)) {
        boolean inSynonymList = false;
        while (scanner.hasNextLine()) {
          String line = scanner.nextLine();
          if (line.trim().startsWith(prefix)) {
            inSynonymList = true;
          } else if (inSynonymList && line.trim().startsWith(SECTION_PREFIX)) {
            // next section starts
            break;
          } else if (inSynonymList) {
            terms.add(line);
          }
        }
      }
      return terms;
    }

  }

}
