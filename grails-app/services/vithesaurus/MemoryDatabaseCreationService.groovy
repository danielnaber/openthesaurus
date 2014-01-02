package vithesaurus

import java.sql.Connection
import java.sql.PreparedStatement
import com.vionto.vithesaurus.tools.DbUtils

/**
 * Create a MySQL memory database.
 */
class MemoryDatabaseCreationService {

  public static FIELD_LENGTH = 50
    
  static transactional = false

  def dataSource

  /**
   * Create an im memory MySQL database, dropping the old database if it exists.
   *
   * @param hiddenSynsetString comma-separated string of synsets ids to be ignored
   */
  def createMemoryDatabase(String hiddenSynsetString) {
    Connection conn = null
    PreparedStatement ps = null
    try {
      conn = dataSource.getConnection()
      executeQuery("DROP TABLE IF EXISTS memwordsTmp", conn)
      executeQuery("CREATE TABLE IF NOT EXISTS memwordsTmp (word VARCHAR(${FIELD_LENGTH}) NOT NULL, lookup VARCHAR(${FIELD_LENGTH}), lookup2 VARCHAR(${FIELD_LENGTH})) ENGINE = MEMORY COLLATE = 'utf8_general_ci'", conn)
      executeQuery("CREATE TABLE IF NOT EXISTS memwords (word VARCHAR(${FIELD_LENGTH}) NOT NULL, lookup VARCHAR(${FIELD_LENGTH}), lookup2 VARCHAR(${FIELD_LENGTH})) ENGINE = MEMORY COLLATE = 'utf8_general_ci'", conn)

      ps = conn.prepareStatement("INSERT INTO memwordsTmp (word, lookup) VALUES ('__last_modified__', ?)")
      ps.setString(1, new Date().toString())
      ps.execute()

      // setString() on a PreparedStatement won't work, so insert value of hidden synsets directly:
      String sql = """INSERT INTO memwordsTmp SELECT DISTINCT word, normalized_word, normalized_word2
        FROM term, synset
        WHERE
          term.synset_id = synset.id AND
          synset.is_visible = 1 AND
          synset.id NOT IN (${hiddenSynsetString})
        ORDER BY word"""
      ps = conn.prepareStatement(sql)
      ps.execute()

      executeQuery("RENAME TABLE memwords TO memwordsBak, memwordsTmp TO memwords", conn)
      executeQuery("DROP TABLE memwordsBak", conn)

    } finally {
      DbUtils.closeQuietly(ps)
      DbUtils.closeQuietly(conn)
    }
  }

  private void executeQuery(String sql, Connection conn) {
    PreparedStatement ps = conn.prepareStatement(sql)
    try {
      ps.execute()
    } finally {
      DbUtils.closeQuietly(ps)
    }
  }

}
