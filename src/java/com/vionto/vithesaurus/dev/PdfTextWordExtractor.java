package com.vionto.vithesaurus.dev;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Extract words from a two-column dictionary that has been converted
 * from PDF via pdftotext. Input will probably need some manual fixes.
 */
public class PdfTextWordExtractor {

  private String head = "";
  private String prevHead = "";
  private StringBuilder sb = new StringBuilder();

  private void run(String file) throws IOException {
    List<String> lines = Files.readAllLines(Paths.get(file));
    String prevLine = "";
    for (String line : lines) {
      if (line.equals("")) {
      } else if (line.matches("\f.*")) {
      } else if (line.matches("[A-Z]")) {
      } else if (line.matches("[0-9]+")) {
      } else if (line.matches("[a-zA-ZöäüÄÖÜß-]+") && prevLine.isEmpty()) {

      } else if (line.matches("\\d\\..*") || prevLine.endsWith("\u00AD") || prevLine.endsWith(",") || prevLine.endsWith("sich")) {
        if (prevLine.endsWith("\u00AD")) {
          sb.replace(sb.length()-1, sb.length(), "");  // cut off hyphen-like char (\u00AD)
          sb.append(line);
        } else {
          sb.append(" ");
          sb.append(line);
        }

      } else if (line.matches("[a-zA-ZöäüÄÖÜß-]+, sich .*")) {
        // "anstauen, sich"
        printAndReset();
        Matcher m = Pattern.compile("([a-zA-ZöäüÄÖÜß-]+, sich) (.*)").matcher(line);
        if (m.matches()) {
          head = m.group(1);
          sb.append(m.group(2));
        } else {
          System.err.println("NO MATCH: " + line);
        }
        
      } else if (line.matches("[a-zA-ZöäüÄÖÜß-]+ ([a-zA-ZöäüÄÖÜß-]+|[1-9]\\.).*")) {
        // "anstechen anbrechen, anzapfen, aufbrechen"
        printAndReset();
        Matcher m = Pattern.compile("([a-zA-ZöäüÄÖÜß-]+) (.+)").matcher(line);
        if (m.matches()) {
          //System.out.println("HEAD: " + m.group(1));
          head = m.group(1);
          sb.append(" ");
          sb.append(m.group(2));
        } else {
          System.err.println("NO MATCH: " + line);
        }
        
      } else {
        System.out.println("UNKNOWN CASE: " + line);
        sb.append(" ");
        sb.append(line);
      }
      prevLine = line;
    }
    printAndReset();
  }

  private void printAndReset() {
    if (normalize(head).compareTo(normalize(prevHead)) < 0) {
      System.err.println("Out of order? " + prevHead + " ... " + head); 
    }
    System.out.println(head + " => " + sb);
    prevHead = head;
    head = "";
    sb = new StringBuilder();
  }

  private String normalize(String s) {
    return s.toLowerCase().replace("ä", "a").replace("ü", "u").replace("ö", "o").replace("ß", "ss").replace("-", "");
  }

  public static void main(String[] args) throws IOException {
    if (args.length != 1) {
      System.out.println("Usage: " + PdfTextWordExtractor.class.getSimpleName() + " <file>");
      System.exit(1);
    }
    new PdfTextWordExtractor().run(args[0]);
  }
}
