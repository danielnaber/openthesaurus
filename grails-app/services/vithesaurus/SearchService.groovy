/**
 * vithesaurus - web-based thesaurus management tool
 * Copyright (C) 2012 Daniel Naber (www.danielnaber.de)
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
package vithesaurus

import java.sql.Connection
import java.sql.PreparedStatement
import java.sql.ResultSet
import com.vionto.vithesaurus.PartialMatch
import com.vionto.vithesaurus.tools.DbUtils
import com.vionto.vithesaurus.SimilarMatch
import org.apache.commons.lang3.StringUtils
import com.vionto.vithesaurus.SimilarLengthComparator
import com.vionto.vithesaurus.Term
import com.vionto.vithesaurus.tools.StringTools
import com.vionto.vithesaurus.WordLevelComparator
import com.vionto.vithesaurus.SearchResult

class SearchService {

  static transactional = false

  def dataSource

  // The maximum for the search query. Avoids out of memory
  private static final int UPPER_BOUND = 1000
  private static final int MAX_SIMILARITY_DISTANCE = 3

  /**
   * Hibernate-based search implementation. Note that the number
   * of total matches is not always accurate.
   */
  def searchSynsets(String query, int max = -1, int offset = 0) {
      boolean completeResult = false

      // TODO: why don't we use Synset.withCriteria here, it would
      // free us from the need to remove duplicates manually
      // => there's a bug(?) so that the synsets are incomplete,
      // i.e. the terms are missing unless they match "ilike('word', query)",
      // see http://jira.codehaus.org/browse/GRAILS-2793
      // TODO: use HQL or SQL so we can make use of Oracle's lowercase index
      def termList = Term.withCriteria {
          or {
            eq('word', query)
            eq('normalizedWord', StringTools.normalize(query))
            if (query.startsWith("sich ") || query.startsWith("etwas ")) {
                // special case for German reflexive etc - keep in sync with _mainmatches.gsp
                String simplifiedQuery = query.replaceAll("^(sich|etwas) ", "")
                eq('word', simplifiedQuery)
                eq('normalizedWord', simplifiedQuery)
            }
          }
          synset {
              eq('isVisible', true)
              maxResults(UPPER_BOUND)
          }
      }
      int totalMatches = termList.size()
      if (totalMatches < UPPER_BOUND) {
          completeResult = true
      }

      def synsetList = []
      Set ids = new HashSet()
      int i = 0
      for (term in termList) {
          // avoid duplicates:
          if (!ids.contains(term.synset.id)) {
              i++
              if (i <= offset) {
                  ids.add(term.synset.id)
                  continue
              }
              synsetList.add(term.synset)
              ids.add(term.synset.id)
              if (max > 0 && synsetList.size() >= max) {
                  break
              }
          }
      }
      // We count terms, not synsets so the number of matches may
      // not be correct - make it correct at least if there are only
      // a few hits (the user can easily see then that the number is
      // incorrect):
      if (synsetList.size() < max && offset == 0) {
          totalMatches = synsetList.size()
      }
      Collections.sort(synsetList, new WordLevelComparator(query))
      return new SearchResult(totalMatches, synsetList, completeResult)
  }

  List searchWikipedia(String query, Connection conn) {
    String sql = "SELECT link, title FROM wikipedia WHERE title = ?"
    PreparedStatement ps = null
    ResultSet resultSet = null
    List matches = []
    try {
        ps = conn.prepareStatement(sql)
        ps.setString(1, query)
        resultSet = ps.executeQuery()
        int i = 0
        while (resultSet.next()) {
          if (i == 0) {
            matches.add(resultSet.getString("title"))
          }
          matches.add(resultSet.getString("link"))
          i++
        }
    } finally {
      DbUtils.closeQuietly(resultSet)
      DbUtils.closeQuietly(ps)
    }
    return matches
  }

  List searchWiktionary(String query, Connection conn) {
    String sql = "SELECT headword, meanings, synonyms FROM wiktionary WHERE headword = ?"
    PreparedStatement ps = null
    ResultSet resultSet = null
    def matches = []
    try {
      ps = conn.prepareStatement(sql)
      ps.setString(1, query)
      resultSet = ps.executeQuery()
      if (resultSet.next()) {
        matches.add(resultSet.getString("headword"))
        matches.add(resultSet.getString("meanings"))
        matches.add(resultSet.getString("synonyms"))
      }
    } finally {
      DbUtils.closeQuietly(resultSet)
      DbUtils.closeQuietly(ps)
    }
    return matches
  }

  def searchMostSimilarTerm(String query, Connection conn) {
    def similarTerms = searchSimilarTerms(query, conn)
    if (similarTerms.size() > 0) {
        int smallestDistance = similarTerms.get(0).dist
        def smallDistTerms = getTermsWithDistance(similarTerms, smallestDistance)
        Collections.sort(smallDistTerms, new SimilarLengthComparator(query))
        return smallDistTerms.get(0)
    } else {
        return []
    }
  }

  private List getTermsWithDistance(List similarTerms, int smallestDiff) {
    def smallestDiffTerms = []
    for (similarTerm in similarTerms) {
      if (similarTerm.dist == smallestDiff) {
        smallestDiffTerms.add(similarTerm)
      } else {
        return smallestDiffTerms
      }
    }
    return smallestDiffTerms
  }

  def searchSimilarTerms(String query, Connection conn) {
    String sql = """SELECT word, lookup FROM memwords WHERE (
              (CHAR_LENGTH(word) >= ? AND CHAR_LENGTH(word) <= ?)
              OR
              (CHAR_LENGTH(lookup) >= ? AND CHAR_LENGTH(lookup) <= ?))
              ORDER BY word"""
    PreparedStatement ps = null
    ResultSet resultSet = null
    def matches = []
    try {
        ps = conn.prepareStatement(sql)
        int wordLength = query.length()
        ps.setInt(1, wordLength - 1)
        ps.setInt(2, wordLength + 1)
        ps.setInt(3, wordLength - 1)
        ps.setInt(4, wordLength + 1)
        resultSet = ps.executeQuery()
        // TODO: add some typical cases to be found without levenshtein (s <-> ß, ...)
        String lowercaseQuery = query.toLowerCase()
        while (resultSet.next()) {
          String lowercaseDbTerm = resultSet.getString("word").toLowerCase()
          if (lowercaseDbTerm.equals(lowercaseQuery)) {
            continue
          }
          int dist = StringUtils.getLevenshteinDistance(lowercaseDbTerm, lowercaseQuery, MAX_SIMILARITY_DISTANCE)
          if (dist >= 0 && dist <= MAX_SIMILARITY_DISTANCE) {
            matches.add(new SimilarMatch(term:resultSet.getString("word"), dist:dist))
          } else {
            String lookupTerm = resultSet.getString("lookup")
            if (lookupTerm) {
              String lowercaseLookupTerm = lookupTerm.toLowerCase()
              dist = StringUtils.getLevenshteinDistance(lowercaseLookupTerm, lowercaseQuery, MAX_SIMILARITY_DISTANCE)
              if (dist >= 0 && dist <= MAX_SIMILARITY_DISTANCE) {
                matches.add(new SimilarMatch(term:resultSet.getString("word"), dist:dist))
              }
            }
          }
        }
        Collections.sort(matches)		// makes sure lowest distances come first
    } finally {
        DbUtils.closeQuietly(resultSet)
        DbUtils.closeQuietly(ps)
    }
    return matches
  }

  /** Substring matches */
  List searchPartialResult(String term, int fromPos, int maxNum) {
    return searchPartialResultInternal(term, "%" + term + "%", true, fromPos, maxNum)
  }

  /** Words that start with a given term */
  List searchStartsWithResult(String term, int fromPos, int maxNum) {
    return searchPartialResultInternal(term, term + "%", false, fromPos, maxNum)
  }

  int getPartialResultTotalMatches(String query) {
    Connection conn = null
    PreparedStatement ps = null
    ResultSet resultSet = null
    try {
      conn = dataSource.getConnection()
      String sql = "SELECT count(*) AS totalMatches FROM memwords WHERE word LIKE ?"
      ps = conn.prepareStatement(sql)
      ps.setString(1, "%" + query + "%")
      resultSet = ps.executeQuery()
      resultSet.next()
      return resultSet.getInt("totalMatches")
    } finally {
      DbUtils.closeQuietly(resultSet)
      DbUtils.closeQuietly(ps)
      DbUtils.closeQuietly(conn)
    }
  }

  /** Substring matches */
  private List searchPartialResultInternal(String term, String sqlTerm, boolean filterExactMatch, int fromPos, int maxNum) {
    Connection conn = null
    PreparedStatement ps = null
    ResultSet resultSet = null
    List matches = []
    try {
      conn = dataSource.getConnection()
      String sql = "SELECT word FROM memwords WHERE word LIKE ? ORDER BY word ASC LIMIT ${fromPos}, ${maxNum}"
      ps = conn.prepareStatement(sql)
      ps.setString(1, sqlTerm)
      resultSet = ps.executeQuery()
      while (resultSet.next()) {
        String matchedTerm = resultSet.getString("word")
        if (filterExactMatch && matchedTerm.toLowerCase() == term.toLowerCase()) {
          continue
        }
        String result = matchedTerm.encodeAsHTML()
        matches.add(new PartialMatch(term:matchedTerm, highlightTerm:result))
      }
    } finally {
      DbUtils.closeQuietly(resultSet)
      DbUtils.closeQuietly(ps)
      DbUtils.closeQuietly(conn)
    }
    return matches
  }

}
