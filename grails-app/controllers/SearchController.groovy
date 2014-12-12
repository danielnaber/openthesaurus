/**
 * OpenThesaurus - web-based thesaurus management tool
 * Copyright (C) 2014 Daniel Naber (www.danielnaber.de)
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
import com.vionto.vithesaurus.Category
import com.vionto.vithesaurus.Term
import com.vionto.vithesaurus.TermLevel

class SearchController {

    def index() {
        []
    }

    def search() {
        def c = Term.createCriteria()
        TermLevel level = params.level ? TermLevel.findByLevelName(params.level) : null
        Category category = params.category ? Category.findByCategoryName(params.category) : null
        def result = c {
            if (params.contains) {
                ilike('word', "%" + params.contains + "%")
            }
            if (params.startsWith) {
                ilike('word', params.startsWith + "%")
            }
            if (params.endsWith) {
                ilike('word', "%" + params.endsWith)
            }
            if (level) {
                eq('level', level)
            }
            if (category) {
                synset {
                    categoryLinks {
                        eq('category', category)
                    }
                }
            }
            synset {
                eq('isVisible', true)
            }
        }
        // TODO: link it
        // TODO: paging
        // TODO: filter hidden...
        int totalMatches = result.size()
        [result: result, totalMatches: totalMatches]
    }
}
