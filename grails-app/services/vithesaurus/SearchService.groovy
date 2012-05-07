package vithesaurus

import java.sql.Connection
import java.sql.PreparedStatement
import java.sql.ResultSet
import com.vionto.vithesaurus.PartialMatch
import com.vionto.vithesaurus.tools.DbUtils
import com.vionto.vithesaurus.SimilarMatch
import org.apache.commons.lang3.StringUtils

class SearchService {

  static transactional = false

  def dataSource

  private static final int MAX_SIMILARITY_DISTANCE = 3

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
