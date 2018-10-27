/**
 * OpenThesaurus - web-based thesaurus management tool
 * Copyright (C) 2011 Daniel Naber (www.danielnaber.de)
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

package openthesaurus


class WordListController extends BaseController {
    
    def index() {
        if(!params.max) params.max = 10
        def categories = com.vionto.vithesaurus.Category.withCriteria { eq('isDisabled', false) }.sort()
        int categoriesLen = categories.size()
        int categoriesLenHalf = categories.size() / 2
        def categories1 = categories.subList(0, categoriesLenHalf)
        def categories2 = categories.subList(categoriesLenHalf, categoriesLen)
        [categories1: categories1, categories2: categories2]
    }

}