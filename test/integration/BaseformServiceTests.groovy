/**
 * OpenThesaurus - web-based thesaurus management tool
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

import grails.test.GrailsUnitTestCase
import org.junit.Ignore

import java.sql.Connection

@Ignore("doesn't work after Grails update")
class BaseformServiceTests extends GrailsUnitTestCase {

    def dataSource
    def baseformService

    void testBaseformService() {
        Connection conn = dataSource.getConnection()
        try {
            initDatabase(conn)
            Set forms

            forms = baseformService.getBaseForms(conn, "unbekannteswort")
            assertEquals(0, forms.size())

            forms = baseformService.getBaseForms(conn, "Haus")
            assertEquals(0, forms.size())

            forms = baseformService.getBaseForms(conn, "Hauses")
            assertEquals("[Haus]", forms.toString())

            // compounds:
            forms = baseformService.getBaseForms(conn, "Testhäuser")
            assertEquals("[Testhaus]", forms.toString())

        } finally {
            conn.close()
        }
    }

    private void initDatabase(Connection conn) {
        exec("DROP TABLE IF EXISTS word_mapping", conn)
        exec("CREATE TABLE IF NOT EXISTS `word_mapping` (fullform varchar(255) CHARACTER SET utf8 NOT NULL, " +
                "baseform varchar(255) CHARACTER SET utf8 NOT NULL, KEY idx (fullform)) ENGINE=MyISAM DEFAULT CHARSET=latin1", conn)
        exec("INSERT INTO word_mapping (baseform, fullform) VALUES ('Haus', 'Hauses')", conn)
        exec("INSERT INTO word_mapping (baseform, fullform) VALUES ('Haus', 'Häuser')", conn)
    }

    private void exec(String sql, Connection conn) {
        def statement = conn.prepareStatement(sql)
        try {
            statement.execute()
        } finally  {
            statement.close()
        }
    }
}
