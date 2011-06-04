package com.vionto.vithesaurus.wikipedia;

import org.apache.commons.lang.StringUtils;

import javax.xml.stream.XMLInputFactory;
import javax.xml.stream.XMLStreamConstants;
import javax.xml.stream.XMLStreamException;
import javax.xml.stream.XMLStreamReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Read Wikipedia XML dump and print potential synonyms per article.
 */
public class WikipediaSynonymExtractor {
    
    private static final int MAX_CHARS = 150;

    private static final Pattern BOLD_PATTERN = Pattern.compile("''''?'?(.*?)''''?'?");

    private Connection connection;

    public WikipediaSynonymExtractor() {
    }
    
    private void parse(File file) throws XMLStreamException, IOException, SQLException {
        connection = DriverManager.getConnection("jdbc:mysql://localhost/vithesaurus?user=root&password=");
        final XMLInputFactory factory = XMLInputFactory.newInstance();
        final FileInputStream fis = new FileInputStream(file);
        final XMLStreamReader parser = factory.createXMLStreamReader(fis);
        final List<String> synonyms = new ArrayList<String>();
        String text = null;
        while (true) {
            final int event = parser.next();
            if (event == XMLStreamConstants.END_DOCUMENT) {
                parser.close();
                break;
            } else if (event == XMLStreamConstants.START_ELEMENT) {
                //System.out.println("> " + parser.getLocalName());
                if (parser.getLocalName().equals("text")) {
                    parser.next();
                    if (parser.hasText()) {
                        text = parser.getText();
                        final String shortText = text.substring(0, Math.min(MAX_CHARS, text.length())); 
                        final Matcher matcher = BOLD_PATTERN.matcher(shortText);
                        int pos = 0;
                        while (matcher.find(pos)) {
                            synonyms.add(matcher.group(1));
                            pos = matcher.end();
                        }
                        
                    }
                }
            } else if (event == XMLStreamConstants.END_ELEMENT) {
                if (parser.getLocalName().equals("text")) {
                    if (synonyms.size() > 1) {
                        findSynonyms(synonyms);
                         /*if (!isKnown) {
                             System.out.println(synonyms + ": " + text.replaceAll("\\s+", " "));                             
                         }*/
                    }
                    synonyms.clear();
                }
            }
        }
        fis.close();
        connection.close();
    }

    private void findSynonyms(List<String> synonyms) throws SQLException, UnsupportedEncodingException {
        final PreparedStatement preparedStatement = connection.prepareStatement(
                "SELECT DISTINCT synset.id FROM term, synset, term term2 WHERE synset.is_visible = 1 AND synset.id " +
                "   = term.synset_id AND term.synset_id AND term2.synset_id = synset.id AND term2.word = ?");
        try {
            final Map<Integer,Integer> synsetIdToCount = new HashMap<Integer, Integer>();
            for (String synonym : synonyms) {
                preparedStatement.setString(1, synonym);
                final ResultSet resultSet = preparedStatement.executeQuery();
                //System.out.println(synonym);
                try {
                    while (resultSet.next()) {
                        //System.out.println(" " + resultSet.getInt("id"));
                        final Integer key = resultSet.getInt("id");
                        if (synsetIdToCount.containsKey(key)) {
                            synsetIdToCount.put(key, synsetIdToCount.get(key) + 1);
                        } else {
                            synsetIdToCount.put(key, 1);
                        }
                    }
                } finally {
                    resultSet.close();
                }
            }
            boolean foundAll = false;
            //System.out.println(synonyms + " " + synsetIdToCount);
            for (Map.Entry<Integer, Integer> entry : synsetIdToCount.entrySet()) {
                if (entry.getValue() == synonyms.size()) {
                    //System.out.println("Found all synonyms: " + synonyms);
                    foundAll = true;
                }
            }
            if (synsetIdToCount.size() == 0) {
                //System.out.println("Found NO synonyms: " + synonyms);
                System.out.println("[<a href=\"http://de.wikipedia.org/w/index.php?title=Spezial:Suche&search=" +
                        URLEncoder.encode(synonyms.get(0), "utf-8")
                        + "\">W</a>] <a href=\"http://www.openthesaurus.de/synset/create?term=" +
                        URLEncoder.encode(StringUtils.join(synonyms, "\n"), "utf-8") + "\">"
                    + StringUtils.join(synonyms, ", ") + "</a><br/>");
            } else if (!foundAll) {
                //System.out.println("DID NOT find all synonyms: " + synonyms);
            }
        } finally {
            preparedStatement.close();
        }
    }


    public static void main(String[] args) throws XMLStreamException, IOException, SQLException {
        final WikipediaSynonymExtractor extractor = new WikipediaSynonymExtractor();
        extractor.parse(new File("/media/data/data/corpus/wikipedia/dewiki-20100815-pages-articles.xml"));
    }
}
