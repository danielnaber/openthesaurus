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

import com.vionto.vithesaurus.*
import java.sql.Connection
import java.sql.ResultSet
import java.sql.PreparedStatement

class StatisticsController extends BaseController {

    def dataSource       // will be injected
    
    /**
     * Show page with statistics about the database, e.g. number of synsets.
     */
    def index = {
        // global statistics:
        def criteria = UserEvent.createCriteria()
        int latestChangesAllSections = criteria.count {
          gt('creationDate', new Date() - 7)
        }
        // per-user statistics (i.e. top users):
        Connection conn
        PreparedStatement ps
        ResultSet resultSet
        try {
          conn = dataSource.getConnection()
          String sql = """SELECT user_event.by_user_id, real_name, count(*) AS ct 
            FROM user_event, thesaurus_user
            WHERE
            thesaurus_user.id = user_event.by_user_id AND
            user_event.creation_date >= DATE_SUB(NOW(), INTERVAL ? DAY)
            GROUP BY by_user_id
            ORDER BY ct DESC
            LIMIT ?"""
          List topUsers = []
          ps = conn.prepareStatement(sql)
          ps.setInt(1, 365)	// days
          ps.setInt(2, 10)	// max matches
          resultSet = ps.executeQuery()
          while (resultSet.next()) {
            topUsers.add(new TopUser(displayName:resultSet.getString("real_name"), actions:resultSet.getInt("ct")))
          }
          AssociationController associationController = new AssociationController()
          int associationCount = associationController.getAssociationCount()[0]
          [ latestChangesAllSections: latestChangesAllSections,
            topUsers: topUsers, associationCount: associationCount ]
        } finally {
          if (resultSet != null) {
            resultSet.close()
          }
          if (ps != null) {
            ps.close()
          }
          if (conn != null) {
            conn.close()
          }
        }
    }

}
