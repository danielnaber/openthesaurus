package vithesaurus

import java.sql.Connection
import java.sql.PreparedStatement
import java.sql.ResultSet
import com.vionto.vithesaurus.PartialMatch
import com.vionto.vithesaurus.tools.DbUtils

class SearchService {

  static transactional = false

  def dataSource

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
