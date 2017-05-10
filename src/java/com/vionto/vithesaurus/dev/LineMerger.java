package com.vionto.vithesaurus.dev;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.List;

/**
 * Fix a list of alphabetically sorted lines in which line breaks might have
 * been added which we want to remove.
 */
public class LineMerger {

  public static void main(String[] args) throws IOException {
    List<String> lines = Files.readAllLines(Paths.get("TODO"));
    int i = 0;
    while (i+2 < lines.size()) {
      String line = lines.get(i);
      String line1 = lines.get(i).toLowerCase();
      StringBuilder merged = new StringBuilder(line);
      if (line1.trim().endsWith(",")) {
        while (lines.get(i).trim().endsWith(",")) {
          merged.append(lines.get(i+1));
          i++;
        }
        //System.out.println("M: " + merged);
        System.out.println(merged);
      } else {
        System.out.println(line);
      }
      i++;
    }
  }
}
