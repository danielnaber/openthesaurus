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
import com.vionto.vithesaurus.Language
import com.vionto.vithesaurus.Synset
import com.vionto.vithesaurus.Term
import org.junit.Ignore

import java.sql.Connection

@Ignore("doesn't work after Grails update")
class MemoryDatabaseCreationServiceTest extends GrailsUnitTestCase {

    def dataSource
    def memoryDatabaseCreationService

    void testMemoryDatabaseCreation() {
        fillDatabase()
        memoryDatabaseCreationService.createMemoryDatabase("-1")
        assertMemoryDatabaseContent()
        // test that re-creation works as well:
        memoryDatabaseCreationService.createMemoryDatabase("-1")
        assertMemoryDatabaseContent()
    }

    private void fillDatabase() {
        def synsets = Synset.list()
        for (synset in synsets) {
            synset.delete()
        }
        def german = Language.findByShortForm("de")
        Synset synset1 = new Synset()
        synset1.addTerm(new Term("hallo", german, synset1))
        synset1.addTerm(new Term("blah (xxx)", german, synset1))
        synset1.save(failOnError: true, flush: true)
    }

    private void assertMemoryDatabaseContent() {
        Connection conn = dataSource.getConnection()
        try {
            def statement = conn.prepareStatement("SELECT * FROM memwords ORDER BY word")
            def result = statement.executeQuery()
            result.next()
            assertEquals("blah (xxx)", result.getString("word"))
            assertEquals("blah", result.getString("lookup"))
            result.next()
            assertEquals("hallo", result.getString("word"))
            assertEquals(null, result.getString("lookup"))
            result.next()
            assertEquals("__last_modified__", result.getString("word"))
            assertFalse(result.next())
            result.close()
        } finally {
            conn.close()
        }
    }
}
