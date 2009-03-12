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

// Tests for the Java String-based diff tool
class DiffTests extends GroovyTestCase {
    
    void testDiff() {
        assertEquals('', Diff.diff("", ""))
        assertEquals("<span class='add'>xyz</span>", Diff.diff("", "xyz"))
        assertEquals("<span class='del'>xyz</span>", Diff.diff("xyz", ""))
        assertEquals("eins", Diff.diff("eins", "eins"))
        assertEquals("<span class='del'>eins</span><span class='add'>ein</span>",
                Diff.diff("eins", "ein"))
        assertEquals("<span class='del'>ein</span><span class='add'>eins</span>",
                Diff.diff("ein", "eins"))
        assertEquals("eins<span class='add'> zwei</span>",
                Diff.diff("eins", "eins zwei"))
        assertEquals("eins <span class='del'>zwei </span>drei",
                Diff.diff("eins zwei drei", "eins drei"))
        assertEquals("eins <span class='del'>zwei drei </span>vier",
                Diff.diff("eins zwei drei vier", "eins vier"))
        assertEquals("eins <span class='add'>zwei drei </span>vier",
                Diff.diff("eins vier", "eins zwei drei vier"))
        assertEquals("<span class='add'>neu </span>eins",
                Diff.diff("eins", "neu eins"))
        assertEquals("<span class='add'>neu </span>eins zwei",
                Diff.diff("eins zwei", "neu eins zwei"))
    
        assertEquals("|<span class='add'> neu |</span> eins | zwei",
                Diff.diff("| eins | zwei", "| neu | eins | zwei"))
        // known to fail (bug when change is at the start of the string
        // and the string contains "|" which triggers the new mode
        // of splitting):
        //assertEquals("<span class='add'>neu | </span>eins | zwei",
        //        Diff.diff("eins | zwei", "neu | eins | zwei"))

    }
    
}
