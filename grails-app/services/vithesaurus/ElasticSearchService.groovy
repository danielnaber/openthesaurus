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
package vithesaurus

import com.vionto.vithesaurus.Synset
import com.vionto.vithesaurus.Term
import org.elasticsearch.action.bulk.BulkRequestBuilder
import org.elasticsearch.action.bulk.BulkResponse
import org.elasticsearch.action.search.SearchResponse
import org.elasticsearch.client.Client
import org.elasticsearch.client.Requests
import org.elasticsearch.index.query.MatchQueryBuilder
import org.elasticsearch.index.query.QueryBuilders

import javax.annotation.PreDestroy

import static org.elasticsearch.node.NodeBuilder.nodeBuilder

class ElasticSearchService {

    static transactional = false

    private org.elasticsearch.node.Node node
    private Client client

    ElasticSearchService() {
        // TODO: prevent access from outside
        log.info("Creating ElasticSearchService...")
        //use if no external ElasticSearch is running:
        //node = nodeBuilder().clusterName("openthesauruscluster").node()
        node = nodeBuilder().client(true).node()
        client = node.client()
    }

    @PreDestroy
    public void cleanUp() throws Exception {
        log.info("Closing ElasticSearch node")
        node.close()
    }

    def searchSynsets(String query, int max = -1, int offset = 0) {
        long t = System.currentTimeMillis()
        //def termQuery = QueryBuilders.termQuery("term", query) /*.boost(2.0f)*/
        def matchQuery = QueryBuilders.matchQuery("term", query).operator(MatchQueryBuilder.Operator.AND)
        def prefixQuery = QueryBuilders.prefixQuery("term", query)
        def queryObj = QueryBuilders.boolQuery().should(matchQuery).should(prefixQuery)
        SearchResponse result = client.prepareSearch("openthesaurus")
                .setQuery(queryObj)
                .setHighlighterPreTags("<span class='synsetmatchDirect'>")
                .setHighlighterPostTags("</span>")
                .addHighlightedField("term")
                .execute()
                .actionGet()
        log.info("ElasticSearch time: " + (System.currentTimeMillis() - t) + "ms for ${query}: ${result.hits.totalHits} hits")
        return result.hits
    }
    
    def deleteAll() {
        def query = client.deleteByQuery(Requests.deleteByQueryRequest().query(QueryBuilders.matchAllQuery()))
        query.actionGet()  // make synchronous
    }

    /**
     * Warning: deletes everything before it indexes the synsets.
     */
    def indexAll() {  // one doc per term
        log.info("Deleting all index docs...")
        deleteAll()
        log.info("Getting all synsets...")
        List synsets = Synset.list()
        log.info("Starting re-indexing process...")
        int i = 0
        BulkRequestBuilder bulkRequest = client.prepareBulk()
        for (Synset synset in synsets) {
            if (!synset.isVisible) {
                continue
            }
            Map<String, Object> json = new HashMap<>()
            json.put("postDate", new Date())
            json.put("synset_id", synset.id)
            for (Term term in synset.sortedTerms()) {
                json.put("term", term.word)
                bulkRequest.add(client.prepareIndex("openthesaurus", "terms").setSource(json))
            }

            if (i % 500 == 0) {
                log.info("Adding synset ${i}...")
            }
            i++
            //if (i > 100) { break }
        }
        BulkResponse bulkResponse = bulkRequest.execute().actionGet()
        if (bulkResponse.hasFailures()) {
            throw new RuntimeException(bulkResponse.buildFailureMessage())
        }
        log.info("Done indexing ${i} synsets...")
        return i
    }

}
