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

import com.vionto.vithesaurus.ElasticSearchMatch
import com.vionto.vithesaurus.Synset

class ElasticSearchController {

    def elasticSearchService
    
    def index = {
        []
    }

    def search = {
        long esTimeStart = System.currentTimeMillis()
        def results = elasticSearchService.searchSynsets(params.q)
        long esTime = System.currentTimeMillis() - esTimeStart
        long restTimeStart = System.currentTimeMillis()
        List matches = []
        for (result in results) {
            def synsetId = (long)result.source.get("synset_id")
            Synset synset = Synset.get(synsetId)
            String highlightTermWithSpan = result.highlightFields.get("term").fragments[0]
            String highlightTerm = highlightTermWithSpan.replaceAll("<span.*?>", "").replaceAll("</span>", "")
            matches.add(new ElasticSearchMatch(synset:synset, highlightTerm: highlightTerm, highlightTermWithSpan: highlightTermWithSpan))
        }
        long restTime = System.currentTimeMillis() - restTimeStart
        [matches: matches, esTime: esTime, restTime: restTime, totalHits: results.totalHits]
    }

}
