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

import org.junit.Ignore

import java.sql.Connection
import com.vionto.vithesaurus.Synset
import com.vionto.vithesaurus.Term
import com.vionto.vithesaurus.Language

@Ignore("doesn't work after Grails update")
class SearchServiceTest extends GroovyTestCase {

    def dataSource
    def searchService
    def memoryDatabaseCreationService

    @Ignore("not updated to Grails 2.x tests yet")
    def testSearchMostSimilarTerm() {
        Connection conn = dataSource.getConnection()
        try {
            initMemoryDatabase()

            def term = searchService.searchMostSimilarTerm("hello", conn)
            assertEquals("hallo/1", term.toString())

            def term2 = searchService.searchMostSimilarTerm("HELLO", conn)
            assertEquals("hallo/1", term2.toString())

            def term3 = searchService.searchMostSimilarTerm("halloZZ", conn)
            assertEquals("halloX/2", term3.toString())

        } finally {
            conn.close()
        }
    }

    @Ignore("not updated to Grails 2.x tests yet")
    def testSearchSimilarTerms() {
        Connection conn = dataSource.getConnection()
        try {
            initMemoryDatabase()

            def otherTerms = searchService.searchSimilarTerms("xyzxyz", conn)
            assertEquals(0, otherTerms.size())

            def terms1 = searchService.searchSimilarTerms("hallo", conn)
            assertEquals("(blubb) hallo/0", terms1.get(0).toString())
            assertEquals("halloX/1", terms1.get(1).toString())

            def terms2 = searchService.searchSimilarTerms("hello", conn)
            assertEquals("[(blubb) hallo/1, hallo/1, halloX/2]", terms2.toString())

            def terms2Uppercase = searchService.searchSimilarTerms("HELLO", conn)
            assertEquals("[(blubb) hallo/1, hallo/1, halloX/2]", terms2Uppercase.toString())

            def farthestTerms = searchService.searchSimilarTerms("halloZZ", conn)
            assertEquals("[halloX/2]", farthestTerms.toString())

        } finally {
            conn.close()
        }
    }

    @Ignore("not updated to Grails 2.x tests yet")
    def testSearchPartialResult() {
        initMemoryDatabase()

        def otherTerms = searchService.searchPartialResult("xyzxyz", 0, 10)
        assertEquals(0, otherTerms.size())

        def terms1 = searchService.searchPartialResult("hallo", 0, 10)
        assertEquals("[(blubb) hallo, halloX]", terms1.toString())

        def terms2 = searchService.searchPartialResult("HALLO", 0, 10)
        assertEquals("[(blubb) hallo, halloX]", terms2.toString())

        def terms3 = searchService.searchPartialResult("llo", 0, 10)
        assertEquals("[(blubb) hallo, hallo, halloX]", terms3.toString())
    }

    @Ignore("not updated to Grails 2.x tests yet")
    def testGetPartialResultTotalMatches() {
        initMemoryDatabase()
        assertEquals(0, searchService.getPartialResultTotalMatches("xyz"))
        assertEquals(3, searchService.getPartialResultTotalMatches("h"))
        assertEquals(1, searchService.getPartialResultTotalMatches("hallox"))
        assertEquals(1, searchService.getPartialResultTotalMatches("HALLOx"))
    }

    @Ignore("not updated to Grails 2.x tests yet")
    def testSearchStartsWithResult() {
        initMemoryDatabase()

        def otherTerms = searchService.searchStartsWithResult("xyzxyz", 0, 10)
        assertEquals(0, otherTerms.size())

        def terms1 = searchService.searchStartsWithResult("h", 0, 10)
        assertEquals("[hallo, halloX]", terms1.toString())

        def terms2 = searchService.searchStartsWithResult("halloX", 0, 10)
        assertEquals("[halloX]", terms2.toString())

        def terms3 = searchService.searchStartsWithResult("allo", 0, 10)
        assertEquals("[]", terms3.toString())
    }

    private void initMemoryDatabase() {
        // clean up the data other tests left:
        Term.executeUpdate('delete from Term')
        Synset.executeUpdate('delete from Synset')

        def german = Language.findByShortForm("de")
        Synset synset1 = new Synset()
        synset1.addTerm(new Term("hallo", german, synset1))
        synset1.save(failOnError: true, flush: true)

        Synset synset2 = new Synset()
        synset2.addTerm(new Term("halloX", german, synset1))
        synset2.save(failOnError: true, flush: true)

        Synset synset3 = new Synset()
        synset3.addTerm(new Term("(blubb) hallo", german, synset1))
        synset3.save(failOnError: true, flush: true)

        memoryDatabaseCreationService.createMemoryDatabase("-1")
    }
}
