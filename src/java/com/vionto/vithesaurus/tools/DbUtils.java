package com.vionto.vithesaurus.tools;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

/**
 * Database utils.
 */
public class DbUtils {

  private DbUtils() {
  }

  public static void closeQuietly(Connection connection) {
    if (connection != null) {
      try {
        connection.close();
      } catch (SQLException ignore) {}
    }
  }

  public static void closeQuietly(Statement statement) {
    if (statement != null) {
      try {
        statement.close();
      } catch (SQLException ignore) {}
    }
  }

  public static void closeQuietly(ResultSet resultSet) {
    if (resultSet != null) {
      try {
        resultSet.close();
      } catch (SQLException ignore) {}
    }
  }

}
