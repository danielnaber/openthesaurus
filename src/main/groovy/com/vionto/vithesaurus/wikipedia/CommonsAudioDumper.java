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

import org.apache.commons.codec.digest.DigestUtils;
import org.apache.commons.compress.compressors.bzip2.BZip2CompressorInputStream;
import org.xml.sax.Attributes;
import org.xml.sax.SAXException;

import javax.xml.parsers.ParserConfigurationException;
import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Arrays;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Extract files with pronunciation information from Wikimedia commons.
 * @author Daniel Naber
 */
public class CommonsAudioDumper {

  private static final Pattern CC_BY_DE          = Pattern.compile("(?i)\\{\\{(?:self\\|)?Cc-by-([234]\\.[05])-de(?:\\|(.*?))?\\}\\}.*");
  private static final Pattern CC_BY             = Pattern.compile("(?i)\\{\\{(?:self\\|)?Cc-by-([234]\\.[05])(?:\\|(.*?))?\\}\\}.*");
  private static final Pattern CC_BY_SA          = Pattern.compile("(?i)\\{\\{(?:self\\|)?Cc-by-sa-([234]\\.[05])(?:\\|(.*?))?\\}\\}.*");
  private static final Pattern CC_BY_SA_MIGRATED = Pattern.compile("Cc-by-sa-3.0-migrated");
  private static final Pattern CC_ZERO           = Pattern.compile("Cc-zero");
  private static final Pattern RELICENSE         = Pattern.compile("migration=relicense");
  private static final Pattern PD_SELF           = Pattern.compile("\\{\\{PD-self\\}\\}");
  private static final Pattern PD_IN             = Pattern.compile("\\{\\{self\\|Cc-zero\\}\\}");
  private static final List<LicensePattern> LICENSE_PATTERNS = Arrays.asList(
          new LicensePattern(CC_BY_DE, "https://creativecommons.org/licenses/by/$1/de/deed.en"),
          new LicensePattern(CC_BY, "https://creativecommons.org/licenses/by/$1/deed.en"),
          new LicensePattern(CC_BY_SA, "https://creativecommons.org/licenses/by-sa/$1/deed.en"),
          new LicensePattern(CC_BY_SA_MIGRATED, "https://creativecommons.org/licenses/by-sa/3.0/deed.en"),
          new LicensePattern(CC_ZERO, "https://creativecommons.org/publicdomain/zero/1.0/deed.en"),
          new LicensePattern(RELICENSE, "https://creativecommons.org/licenses/by-sa/3.0/deed.en"),
          new LicensePattern(PD_SELF, "https://en.wikipedia.org/wiki/Public_domain"),
          new LicensePattern(PD_IN, "https://en.wikipedia.org/wiki/Public_domain")
  );

  CommonsAudioDumper() {
  }

  private void run(InputStream is) throws IOException, SAXException, ParserConfigurationException {
    CommonsPageHandler handler = new CommonsPageHandler();
    SAXParserFactory factory = SAXParserFactory.newInstance();
    SAXParser saxParser = factory.newSAXParser();
    saxParser.getXMLReader().setFeature("http://apache.org/xml/features/nonvalidating/load-external-dtd", false);  
    System.out.println("SET NAMES utf8;");
    saxParser.parse(is, handler);
    System.err.println("Exported: " + handler.exported);
    System.err.println("Skipped: " + handler.skipped);
    System.err.println("Skipped " + handler.noLicense + " because of missing/undetected license");
  }

  public static void main(String[] args) throws Exception {
    if (args.length != 1) {
      System.out.println("Usage: CommonsAudioDumper <xmldump>");
      System.out.println("   <xmldump> is a compressed XML dump from http://dumps.wikimedia.org/commonswiki/, e.g. 'commonswiki-20150602-pages-articles.xml.bz2'");
      System.exit(1);
    }
    CommonsAudioDumper prg = new CommonsAudioDumper();
    try (
      InputStream fileStream = new FileInputStream(args[0]);
      InputStream gzipStream = new BZip2CompressorInputStream(fileStream);
    ) {
      prg.run(gzipStream);
    }
  }
  
  License getLicenseOrNull(String title, String text) {
    String licenseUrl = null;
    String attribution = null;
    for (LicensePattern licensePattern : LICENSE_PATTERNS) {
      Matcher pattern = licensePattern.pattern.matcher(text);
      if (pattern.find()) {
        if (pattern.groupCount() >= 1) {
          licenseUrl = licensePattern.licenseUrl.replace("$1", pattern.group(1));
        } else {
          licenseUrl = licensePattern.licenseUrl;
        }
        if (pattern.groupCount() >= 2) {
          // TODO: find more ways to extract attribution, this one is rarely used
          attribution = pattern.group(2);
        }
      }
    }
    if (licenseUrl == null) {
      System.err.println("No license found for: " + title);
      return null;
    } else {
      return new License(licenseUrl, attribution);
    }
  }
  
  static class LicensePattern {
    Pattern pattern;
    String licenseUrl;
    LicensePattern(Pattern pattern, String licenseUrl) {
      this.pattern = pattern;
      this.licenseUrl = licenseUrl;
    }
  }

  static class License {
    String url;
    String attribution;
    License(String url, String attribution) {
      this.url = url;
      this.attribution = attribution;
    }
    String getUrl() {
      return url;
    }
    String getAttribution() {
      return attribution;
    }
  }

  @SuppressWarnings("DynamicRegexReplaceableByCompiledPattern")
  class CommonsPageHandler extends WikimediaDumpHandler {
    
    private int exported = 0;
    private int skipped = 0;
    private int noLicense = 0;

    @Override
    public void startElement(String namespaceURI, String lName,
                             String qName, Attributes attrs) {
      super.startElement(namespaceURI, lName, qName, attrs);
      if (qName.equals("title")) {
        title = new StringBuilder();
      }
    }

    @Override
    public void endElement(String namespaceURI, String sName, String qName) {
      if (qName.equals("text")) {
        String title = this.title.toString();
        String cleanTitle = title.replaceFirst("^File:", "");
        if (title.contains("File:De-") && title.contains(".ogg")) {
          String cleanedText = clean(text.toString());
          License license = getLicenseOrNull(title, cleanedText);
          if (license != null) {
            String md5sum = DigestUtils.md5Hex(cleanTitle.replace(' ', '_'));
            String md5path = md5sum.substring(0, 1) + "/" + md5sum.substring(0, 2) + "/";  //  e.g. "5/5e/"
            String url = "https://upload.wikimedia.org/wikipedia/commons/" + md5path + title.replaceFirst("^File:", "").replace(' ', '_');
            System.out.printf("INSERT INTO audio (word, url, author, license) VALUES ('%s', '%s', '%s', '%s');\n",
                    escape(cleanTitle), escape(url), escape(license.attribution), escape(license.url));
            exported++;
          } else {
            noLicense++;
          }
        } else {
          skipped++;
          if (skipped % 25_000 == 0) {
            System.err.println(skipped + "...");
          }
        }
        this.text = new StringBuilder();
        this.title = new StringBuilder();
      }
      position = UNDEF;
    }

    @Override
    protected String escape(String str) {
      if (str == null) {
        return "-";
      }
      return str.replace("'''", "").replace("''", "").replace("'", "''");
    }
    
  }

}
