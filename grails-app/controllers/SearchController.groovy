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
import com.vionto.vithesaurus.Tag
import com.vionto.vithesaurus.Term
import com.vionto.vithesaurus.TermLevel

class SearchController {

    def index() {
        []
    }

    def search() {
        TermLevel level = params.level ? TermLevel.findByLevelName(params.level) : null
        Category category = params.category ? Category.findByCategoryName(params.category) : null
        String[] tagNames = params.tags ? params.tags.split(",\\s*") : []
        List<Tag> wantedTags = []
        for (String tagName : tagNames) {
            wantedTags.add(Tag.findByName(tagName))
        }
        List<Long> hiddenSynsetIds = getHiddenSynsetIds()
        def c = Term.createCriteria()
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
            if (wantedTags.size() > 0) {
                // TODO: semantics isn't clean yet...
                for (Tag tag : wantedTags) {
                    tags {
                            eq('id', tag.id)
                    }
                }
            }
            synset {
                eq('isVisible', true)
                not {
                    inList('id', hiddenSynsetIds)
                }
            }
            order('word', 'asc')
        }
        // TODO: paging
        int totalMatches = result.size()
        [result: result, totalMatches: totalMatches]
    }

    private List<Long> getHiddenSynsetIds() {
        List<Long> hiddenSynsets = []
        if (grailsApplication.config.thesaurus.hiddenSynsets) {
            String[] hiddenSynsetStrings = grailsApplication.config.thesaurus.hiddenSynsets.split(",\\s*")
            for (String id : hiddenSynsetStrings) {
                hiddenSynsets.add(Long.parseLong(id))
            }
        }
        return hiddenSynsets
    }

}
