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

import com.vionto.vithesaurus.*
import java.sql.Connection
import java.sql.ResultSet
import java.sql.PreparedStatement
import org.apache.commons.lang.StringUtils

/**
 * Suggests words as potential synsets. Also finds synsets with existing similar
 * words to which the suggested word may be merged.
 * 
 * Note that this requires indices like this (Oracle) to be fast:
 * <pre>
 * create index term_word_length_i on term (length(word));
 * create index term_word_reverse_i on term (reverse(word));
 * </pre>
 */
class SynsetSuggestionController extends BaseController {
    
    def dataSource       // will be injected by Grails
    
    /** Number of entries to be displayed for 'starts with' terms */
    final static int STARTS_WITH_MAX = 10
    /** Number of entries to be displayed for 'ends with' terms */
    final static int ENDS_WITH_MAX = 10

    /** Maxmimum length difference in each direction (i.e. similar word may be 1 character
     * shorter than original or 1 character longer if this is set to 1) allowed to be 
     * similar (improves performance as Levenshtein can be called less often).
     */
    final static int MAX_LENGTH_DIFF = 1
    /** Maximimum Levenshtein distance allowed for a word to be similar. 
     * It doesn't make sense to set this to a value greater than MAX_LENGTH_DIFF*2.
     */
    final static int MAX_LEVENSHTEIN = 2

    /** Database connection for direct SQL. */
    Connection conn
    /** Similarity search. */
    PreparedStatement simSearchStatement
    /** SQL statement for terms that end with a given string. */
    PreparedStatement endsWithStatement
    
    def beforeInterceptor = [action: this.&auth]
    
    def index = { redirect(action:list,params:params) }

    // the delete, save and update actions only accept POST requests
    static def allowedMethods = [delete:'POST', save:'POST', update:'POST']

    def list = {
        if (!params.offset) params.offset = 0
        else params.offset = params.offset.toInteger()
        if (!params.max) params.max = 25
        else params.max = params.max.toInteger()
        if (!params.sort) {
            params.sort = "termCount"
        }
        if (!params.order) {
            params.order = "desc"
        }
        if (params.clear) {     // reset filter
            params.filter = ""
        }

        // first count hits:
        def criteria = SynsetSuggestion.createCriteria()
        int totalHits = SynsetSuggestion.count()
        int hits = criteria.count {
            if (params.filter) {
                ilike('term', params.filter)
            }
            if (params.prefix) {
                ilike('term', params.prefix + "%")
            }
        }
        
        // now get the hits:
        List synsetSuggestionList = SynsetSuggestion.withCriteria {
            if (params.filter) {
                ilike('term', params.filter)
            }
            if (params.prefix) {
                ilike('term', params.prefix + "%")
            }
            order(params.sort, params.order)
            firstResult(params.offset)
            maxResults(params.max)
        }

        List synsetSuggestions = []
        for (synsetSuggestion in synsetSuggestionList) {
            String suggestedWord = synsetSuggestion.term
            List identicalWords = Term.withCriteria {
                ilike('word', suggestedWord)
                synset {
                    eq('isVisible', true)
                }
            }
            String identicalWord = null
            if (identicalWords.size() >= 1) {
                identicalWord = identicalWords.get(0)
            }
            // filled only on ajax request for performance reasons:
            List startsWithWords = []
            List endsWithWords = []
            List similarWords = []
            RejectedWord rejWord = RejectedWord.findByWordIlike(suggestedWord)
            long rejectionId = rejWord ? rejWord.id : 0
            SynsetSuggestionInformation ssi = new SynsetSuggestionInformation(
                    id: synsetSuggestion.id,
                    suggestedWord: suggestedWord, 
                    identicalWord: identicalWord,
                    wordCount: synsetSuggestion.termCount,
                    rejectionId: rejectionId)
            synsetSuggestions.add(ssi)
        }
        
        [ synsetSuggestionList: synsetSuggestions, totalHits: totalHits,
          hits: hits, startsWithMax: STARTS_WITH_MAX, endsWithMax: ENDS_WITH_MAX]
    }
    
    /**
     * Show words that are somehow similar and which are thus potential duplicates
     * (called via Ajax).
     */
    def relatedWords = {
        if (!params.word) throw new Exception("Missing parameter 'word'")
        if (!params.suggestionId) throw new Exception("Missing parameter 'suggestionId'")
        long startTime = System.currentTimeMillis()
        // TODO: open only once?!
        conn = dataSource.getConnection()
        String sql = makeSimilarSearchSql()
        simSearchStatement = conn.prepareStatement(sql)
        
        // We use reverse() for performance speedup (finding prefixes is much faster
        // than finding suffixes) -- this there's an according index:
        endsWithStatement = 
            conn.prepareStatement("SELECT word FROM term WHERE reverse(word) LIKE ?")
        
        List similarWords = getSimilarWords(params.word)
        List startsWithWords = getStartsWithWords(params.word)
        List endsWithWords = getEndsWithWords(params.word, conn)
        long uniqueId = System.currentTimeMillis()  // used to keep <div> ids unique 
        simSearchStatement.close()
        conn.close()
        
        // if there are similar terms, use their language, section, and category
        // setting to pre-select the form fields with useful values:
        long suggestedLanguageId = -1
        long suggestedCategoryId = -1
        long suggestedSectionId = -1
        if (similarWords.size() > 0) {
            suggestedLanguageId = similarWords.get(0).languageId
            suggestedCategoryId = similarWords.get(0).categoryId
            suggestedSectionId = similarWords.get(0).sectionId
        }

        render(template:"relatedWords", 
                model:[similarWords: similarWords, startsWithWords: startsWithWords,
                       endsWithWords: endsWithWords, term: params.word, 
                       i: uniqueId, suggestionId: params.suggestionId,
                       suggestedLanguageId: suggestedLanguageId,
                       suggestedCategoryId: suggestedCategoryId,
                       suggestedSectionId: suggestedSectionId])
    }

    /**
     * Get (up to STARTS_WITH_MAX) terms that start with the given term.
     */
    private List getStartsWithWords(String term) {
        return Term.withCriteria {
            synset {
                eq('isVisible', true)
            }
            ilike('word', term + "%")
            maxResults(STARTS_WITH_MAX)
        }
    }

    /**
     * Get (up to ENDS_WITH_MAX) terms that end with the given term.
     * Requires a reverse() index.
     */
    private List getEndsWithWords(String term, Connection conn) {
        endsWithStatement.setString(1, term.reverse() + "%")
        ResultSet rs = endsWithStatement.executeQuery()
        List list = []
        int i = 0
        while (rs.next() && i < ENDS_WITH_MAX) {
            list.add(rs.getString("word"))
            i++
        }
        rs.close()
        return list
    }

    /**
     * Find terms that are similar to the given term, according to
     * the Levenshtein distance.
     * @return a list of SimilarTerm objects
     */
    private List getSimilarWords(String term) {
        simSearchStatement.setInt(2, (term.length() - MAX_LENGTH_DIFF))
        simSearchStatement.setInt(3, (term.length() + MAX_LENGTH_DIFF))
        
        String firstChar = term.substring(0, 1)
        String secondChar = ""
        if (term.length() > 1) {
            secondChar = term.substring(1, 2)
        }
        // We need a prefix only for performance reasons, i.e. we cannot use
        // Levenshtein distance on all words in the database:
        String prefix = firstChar + secondChar + "%"
        List simWords = []
        simWords.addAll(filterTerms(term, 
                runSimilarityQuery(simSearchStatement, prefix.toLowerCase())))
        
        return simWords
    }

    /**
     * Return only those words from the given list whose words are similar to
     * the given term, according to the Levenshtein distance.
     * @return a new list with some elements from the original list
     */
    private List filterTerms(String term, List potentiallySimilarTerms) {
        List list = []
        term = term.toLowerCase()
        for (elem in potentiallySimilarTerms) {
            int distance = 
                StringUtils.getLevenshteinDistance(term, elem.suggestedWord.toLowerCase())
            if (distance <= MAX_LEVENSHTEIN) {
                elem.distance = distance
                list.add(elem)
            }
        }
        return list.sort()
    }
    
    /**
     * Run the SQL query that searches for potentially similar terms.
     * @return a list of SimilarTerm objects
     */
    private List runSimilarityQuery(PreparedStatement prepStatement, String query) {
        List results = []
        //long t = System.currentTimeMillis()
        prepStatement.setString(1, query)
        ResultSet rs = prepStatement.executeQuery()
        while (rs.next()) {
            SimilarTerm simTerm = new SimilarTerm(suggestedWord: rs.getString("word"), 
                    synsetId: rs.getLong("synset_id"), sectionName: rs.getString("section_name"),
                    categoryId: rs.getLong("preferred_category_id"),
                    languageId: rs.getLong("language_id"),
                    sectionId: rs.getLong("section_id"),
                    distance: -1)
            results.add(simTerm)
        }
        //log.info("sql query result size = " + results.size() +
        // "(" +(System.currentTimeMillis()-t)+ "ms)")
        return results
    }
    
    /**
     * Build an SQL query that queries for potentielly similar words, i.e. words
     * that are about the same length and that start with the same prefix. The
     * results should be further filtered by a Levenshtein distance.
     * Requires a lower() index on the 'word' colum for good performance.
     * @return an SQL string to be used in a PreparedStatement 
     */
    private String makeSimilarSearchSql() {
        // The criteria help improve performance because we must limit the
        // number of hits so that the Levenshtein distance is called less often:
        return "SELECT " +
            "word, language_id, synset_id, section_id, section_name, preferred_category_id " +
            "FROM term, synset, section WHERE " +
            "term.synset_id = synset.id " +
            "AND synset.is_visible = 1 " +
            "AND lower(word) like ? " +
            "AND length(word) >= ? " + 
            "AND length(word) <= ? " + 
            "AND term.synset_id = synset.id " +
            "AND section.id = synset.section_id"
    }

}

/**
 * A word similar to some other term, plus the information to which synset
 * the word belongs.
 */
class SimilarTerm implements Comparable {
    
    int distance
    String suggestedWord
    long languageId     // id of the term's language
    long synsetId       // id to which the term belongs
    long categoryId     // the id of the preferred category of the synset
    long sectionId      // id of the section of the term's synset
    String sectionName  // name of the section of the term's synset
    
    /**
     * Used to sort most similar words first (e.g. those with a small distance)
     */
    int compareTo(Object other) {
        assert(other instanceof SimilarTerm)
        return distance - other.distance 
    }
}

/**
 * An original suggestion from the Complex Concept Identifier import,
 * plus similar terms from the existing concepts.
 */
class SynsetSuggestionInformation {

    long id
    String suggestedWord
    String identicalWord
    List startsWithWords
    List endsWithWords
    List similarWords
    int wordCount
    long rejectionId        // 0 if word has not been rejected yet
    
}
