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

class SynsetTests extends GroovyTestCase {

    Language english
    
    void setUp() {
        english = new Language()
        english.shortForm = "en"
        english.longForm = "English"
    }
    
    void testToString() {
        Synset s = new Synset()
        Term t1 = new Term("word1", english, s)
        s.addTerm(t1)
        assertEquals("word1", s.toString())
        Term t2 = new Term("word2", english, s)
        s.addTerm(t2)
        assertEquals("word1 | word2", s.toString())
    }

    void testToDetailedString() {
        Synset s = new Synset()
        Term t1 = new Term("word1", english, s)
        s.addTerm(t1)
        
        Category cat1 = new Category("mycat1")
        Category cat2 = new Category("mycat2")
        CategoryLink catLink1 = new CategoryLink(s, cat1)
        CategoryLink catLink2 = new CategoryLink(s, cat2)
        
        // cat inserted first will be preferred cat:
        s.addCategoryLink(catLink2)
        s.addCategoryLink(catLink1)
        
        String exp = "| word1 || isVisible=true || comment=null || " +
            "preferredTerms=en:word1 || " +
            "preferredCategory=mycat2 || " + 
            "section=null || " + 
            "categories=mycat1|mycat2"
        assertEquals(exp, s.toDetailedString())

        Term t2 = new Term("aword2", english, s)
        s.userComment = "my comment."
        s.addTerm(t2)
        exp = "| aword2 | word1 || isVisible=true || comment=my comment. || " +
            "preferredTerms=en:word1 || " +
            "preferredCategory=mycat2 || " + 
            "section=null || " + 
            "categories=mycat1|mycat2"
        assertEquals(exp, s.toDetailedString())
        
        s.setPreferredTerm(english, t2)
        exp = "| aword2 | word1 || isVisible=true || comment=my comment. || " +
            "preferredTerms=en:aword2 || " +
            "preferredCategory=mycat2 || " + 
            "section=null || " + 
            "categories=mycat1|mycat2"
        assertEquals(exp, s.toDetailedString())
    }

    void testAddDuplicateTerm() {
		Synset s = new Synset()
        Term t1 = new Term("word1", english, s)
		s.addTerm(t1)
		Term t2 = new Term("word1", english, s)
		try {
			s.addTerm(t2)
			fail()
		} catch (IllegalArgumentException e) {
		  // expected, term cannot be added twice
		}
    }
    
}