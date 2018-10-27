/**
 * OpenThesaurus - web-based thesaurus management tool
 * Copyright (C) 2009 vionto GmbH, www.vionto.com
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

package openthesaurus


import com.vionto.vithesaurus.*
import java.sql.Connection
import java.sql.ResultSet
import java.sql.PreparedStatement
import java.text.SimpleDateFormat

class StatisticsController extends BaseController {

    def dataSource       // will be injected
    
    /**
     * Show page with statistics about the database, e.g. number of synsets.
     */
    def index() {
        // global statistics:
        def criteria = UserEvent.createCriteria()
        int latestChangesAllSections = criteria.count {
          gt('creationDate', new Date() - 7)
        }
        // per-user statistics (i.e. top users):
        Connection conn
        try {
          conn = dataSource.getConnection()
          List topUsers = getTopUsers(conn, 365)
          List allTimeTopUsers = getTopUsers(conn, 365*100)
          AssociationController associationController = new AssociationController()
          int associationCount = associationController.getAssociationCount()[0]
          int tagCount = getTermTags(conn)
          [ latestChangesAllSections: latestChangesAllSections,
            topUsers: topUsers, allTimeTopUsers: allTimeTopUsers, associationCount: associationCount, tagCount: tagCount ]
        } finally {
          if (conn != null) {
            conn.close()
          }
        }
    }

    private List getTopUsers(Connection conn, int lastDays) {
        String sql = """SELECT user_event.by_user_id AS id, real_name, count(*) AS ct 
            FROM user_event, thesaurus_user
            WHERE
            thesaurus_user.id = user_event.by_user_id AND
            user_event.creation_date >= DATE_SUB(?, INTERVAL ? DAY)
            GROUP BY by_user_id
            ORDER BY ct DESC
            LIMIT ?"""                                                                                                                          
        List topUsers = []
        PreparedStatement ps
        ResultSet resultSet
        try {
            ps = conn.prepareStatement(sql)
            // this should enable caching of the result in MySQL, unlike when using NOW():
            String today = new SimpleDateFormat("yyyy-MM-dd 00:00:00").format(new Date())
            ps.setString(1, today)
            ps.setInt(2, lastDays)
            ps.setInt(3, 10)    // max matches
            resultSet = ps.executeQuery()
            while (resultSet.next()) {
                topUsers.add(new TopUser(displayName: resultSet.getString("real_name"), actions: resultSet.getInt("ct"), userId: resultSet.getInt("id")))
            }
        } finally {
            if (resultSet != null) {
                resultSet.close()
            }
            if (ps != null) {
                ps.close()
            }
        }
        return topUsers
    }

    private int getTermTags(Connection conn) {
        PreparedStatement ps
        ResultSet resultSet
        try {
          ps = conn.prepareStatement("SELECT COUNT(*) AS count FROM term_tag")  //well, we also count deleted synsets...
          resultSet = ps.executeQuery()
          resultSet.next()
          return resultSet.getInt("count")
        } finally {
          if (resultSet != null) resultSet.close()
          if (ps != null) ps.close()
        }
    }

}
