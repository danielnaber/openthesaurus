package vithesaurus

import java.sql.Connection
import java.sql.PreparedStatement
import java.sql.ResultSet
import com.vionto.vithesaurus.PartialMatch

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
    Connection conn
    PreparedStatement ps
    ResultSet resultSet
    try {
      conn = dataSource.getConnection()
      String sql = "SELECT count(*) AS totalMatches FROM memwords WHERE word LIKE ?"
      ps = conn.prepareStatement(sql)
      ps.setString(1, "%" + query + "%")
      resultSet = ps.executeQuery()
      resultSet.next()
      return resultSet.getInt("totalMatches")
    } finally {
      if (resultSet != null) { resultSet.close() }
      if (ps != null) { ps.close() }
      if (conn != null) { conn.close() }
    }
  }

  /** Substring matches */
  private List searchPartialResultInternal(String term, String sqlTerm, boolean filterExactMatch, int fromPos, int maxNum) {
    String sql = "SELECT word FROM memwords WHERE word LIKE ? ORDER BY word ASC LIMIT ${fromPos}, ${maxNum}"
    Connection conn
    PreparedStatement ps
    ResultSet resultSet
    def matches = []
    try {
      conn = dataSource.getConnection()
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
      if (resultSet != null) { resultSet.close() }
      if (ps != null) { ps.close() }
      if (conn != null) { conn.close() }
    }
    return matches
  }

}
