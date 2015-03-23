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
import com.vionto.vithesaurus.*;
import grails.test.mixin.*
import org.junit.*

@Ignore("doesn't work after Grails update")
@TestFor(Term)
@Mock([Term, Language])
class TermTests extends GroovyTestCase {

    Language english
    Synset s

    void setUp() {
        english = new Language()
        english.shortForm = "en"
        english.longForm = "English"
        s = new Synset()
    }

    @Ignore("not updated to Grails 2.x tests yet")
    void testToString() {
        Term t1 = new Term("word1", english, s)
        assertEquals("word1", t1.toString())
    }

    @Ignore("not updated to Grails 2.x tests yet")
    void testToDetailedString() {
        Term t1 = new Term("word1", english, s)
        t1.userComment = "my comment"

        String exp = "word1 || comment=my comment"
        assertEquals(exp, t1.toDetailedString())
    }

    @Ignore("not updated to Grails 2.x tests yet")
    void testAddInvalidTerm() {
        Term t1 = new Term("broken word: `\\€", english, s)
        assertFalse(t1.validate())
    }

}