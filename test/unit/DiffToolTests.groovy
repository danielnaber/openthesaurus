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

// Tests for the Groovy object diff tools
class DiffToolTests extends GroovyTestCase {
    
    void testDiff() {
		Synset s1 = new Synset()
		Synset s2 = new Synset()
		DiffTool diffTool = new DiffTool()
		List diffs = diffTool.diff(s1, s2)
		//println diffs
        assertEquals(0, diffs.size())
        
        s1.originalURI = "foobar"
  		diffs = diffTool.diff(s1, s2)
  		//println diffs
  		assertEquals(1, diffs.size())

		s2.originalURI = "foobar"
      	diffs = diffTool.diff(s1, s2)
   		assertEquals(0, diffs.size())
    }
    
}
