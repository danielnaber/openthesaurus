/**
 * vithesaurus - web-based thesaurus management tool
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

class TermTests extends GroovyTestCase {

    Language english
    Synset s

    void setUp() {
        english = new Language()
        english.shortForm = "en"
        english.longForm = "English"
        s = new Synset()
    }

    void testToString() {
        Term t1 = new Term("word1", english, s)
        assertEquals("word1", t1.toString())
    }

    void testToDetailedString() {
        Term t1 = new Term("word1", english, s)
        t1.userComment = "my comment"
        t1.isShortForm = true

        String exp = "word1 || abbrev=true | acronym=false | language=en | " +
                "form=null | comment=my comment"
        assertEquals(exp, t1.toDetailedString())
    }

    void testAddInvalidTerm() {
        Term t1 = new Term("broken word: `\\€", english, s)
        assertFalse(t1.validate())
    }

}