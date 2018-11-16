/**
 * OpenThesaurus - web-based thesaurus management tool
 * Copyright (C) 2012 Daniel Naber (www.danielnaber.de)
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

import com.vionto.vithesaurus.DiffPositionComparator

import java.sql.Connection
import java.sql.PreparedStatement
import java.sql.ResultSet
import com.vionto.vithesaurus.PartialMatch
import com.vionto.vithesaurus.tools.DbUtils
import com.vionto.vithesaurus.SimilarMatch
import org.apache.commons.lang3.StringUtils
import com.vionto.vithesaurus.SimilarLengthComparator
import com.vionto.vithesaurus.Term
import com.vionto.vithesaurus.tools.StringTools
import com.vionto.vithesaurus.WordLevelComparator
import com.vionto.vithesaurus.SearchResult

import com.google.common.cache.Cache;
import com.google.common.cache.CacheBuilder;
import java.util.concurrent.TimeUnit

class SearchService {

  static transactional = false

  def dataSource
    
  int cacheLookupCount = 0

  // The maximum for the search query. Avoids out of memory
  private static final int UPPER_BOUND = 1000
  private static final int MAX_SIMILARITY_DISTANCE = 3

  private final Cache<String, List<SimilarMatch>> simCache = 
          CacheBuilder.newBuilder().maximumSize(5000).recordStats().expireAfterAccess(15, TimeUnit.MINUTES).build();
  private final Cache<SubstringQuery, List<PartialMatch>> substringCache = 
          CacheBuilder.newBuilder().maximumSize(5000).recordStats().expireAfterAccess(15, TimeUnit.MINUTES).build();

  /**
   * Hibernate-based search implementation. Note that the number
   * of total matches is not always accurate.
   */
  def searchSynsets(String query, int max = -1, int offset = 0, boolean normalize = true) {
      boolean completeResult = false

      // TODO: why don't we use Synset.withCriteria here, it would
      // free us from the need to remove duplicates manually
      // => there's a bug(?) so that the synsets are incomplete,
      // i.e. the terms are missing unless they match "ilike('word', query)",
      // see http://jira.codehaus.org/browse/GRAILS-2793
      def termList = Term.withCriteria {
          or {
            eq('word', query)
            if (normalize) {
                eq('normalizedWord', StringTools.normalize(query))
                eq('normalizedWord2', StringTools.normalize2(query))
            }
            if (query.startsWith("sich ") || query.startsWith("etwas ")) {
                String simplifiedQuery = query.replaceAll("^(sich|etwas) ", "")
                eq('word', simplifiedQuery)
                if (normalize) {
                    // special case for German reflexive etc - keep in sync with _mainmatches.gsp
                    eq('normalizedWord', simplifiedQuery)
                }
            }
          }
          synset {
              eq('isVisible', true)
              maxResults(UPPER_BOUND)
          }
      }
      int totalMatches = termList.size()
      if (totalMatches < UPPER_BOUND) {
          completeResult = true
      }

      def synsetList = []
      Set ids = new HashSet()
      int i = 0
      for (term in termList) {
          // avoid duplicates:
          if (!ids.contains(term.synset.id)) {
              i++
              if (i <= offset) {
                  ids.add(term.synset.id)
                  continue
              }
              synsetList.add(term.synset)
              ids.add(term.synset.id)
              if (max > 0 && synsetList.size() >= max) {
                  break
              }
          }
      }
      // We count terms, not synsets so the number of matches may
      // not be correct - make it correct at least if there are only
      // a few hits (the user can easily see then that the number is
      // incorrect):
      if (synsetList.size() < max && offset == 0) {
          totalMatches = synsetList.size()
      }
      Collections.sort(synsetList, new WordLevelComparator(query))
      return new SearchResult(totalMatches, synsetList, completeResult)
  }

  List searchWikipedia(String query, Connection conn) {
    String sql = "SELECT link, title FROM wikipedia WHERE title = ?"
    PreparedStatement ps = null
    ResultSet resultSet = null
    List matches = []
    try {
        ps = conn.prepareStatement(sql)
        ps.setString(1, query)
        resultSet = ps.executeQuery()
        int i = 0
        while (resultSet.next()) {
          if (i == 0) {
            matches.add(resultSet.getString("title"))
          }
          matches.add(resultSet.getString("link"))
          i++
        }
    } finally {
      DbUtils.closeQuietly(resultSet)
      DbUtils.closeQuietly(ps)
    }
    return matches
  }

  List searchWiktionary(String query, Connection conn) {
    String sql = "SELECT headword, meanings, synonyms FROM wiktionary WHERE headword = ?"
    PreparedStatement ps = null
    ResultSet resultSet = null
    def matches = []
    try {
      ps = conn.prepareStatement(sql)
      ps.setString(1, query)
      resultSet = ps.executeQuery()
      if (resultSet.next()) {
        matches.add(resultSet.getString("headword"))
        matches.add(resultSet.getString("meanings"))
        matches.add(resultSet.getString("synonyms"))
      }
    } finally {
      DbUtils.closeQuietly(resultSet)
      DbUtils.closeQuietly(ps)
    }
    return matches
  }

  def searchMostSimilarTerm(String query, Connection conn) {
    def similarTerms = searchSimilarTerms(query, conn)
    if (similarTerms.size() > 0) {
        int smallestDistance = similarTerms.get(0).dist
        def smallDistTerms = getTermsWithDistance(similarTerms, smallestDistance)
        // yes, this is guesswork:
        def comparator = query.length() > 5 ? new DiffPositionComparator(query) : new SimilarLengthComparator(query)
        Collections.sort(smallDistTerms, comparator)
        log.info("Similar to '$query': " + smallDistTerms)
        return smallDistTerms.get(0)
    } else {
        return []
    }
  }

  private List getTermsWithDistance(List similarTerms, int smallestDiff) {
    def smallestDiffTerms = []
    for (similarTerm in similarTerms) {
      if (similarTerm.dist == smallestDiff) {
        smallestDiffTerms.add(similarTerm)
      } else {
        return smallestDiffTerms
      }
    }
    return smallestDiffTerms
  }

  def searchSimilarTerms(String query, Connection conn) {
    // Levenshtein calculation is slow, so use a cached result if available:
    def cachedResult = simCache.getIfPresent(query)
    cacheLookupCount++
    if (cacheLookupCount % 100 == 0) {
        log.info("simCacheLookupCount: " + cacheLookupCount + ", similarity cache hit rate: " + simCache.stats().hitRate() +
                 ", substring cache hit rate: " + substringCache.stats().hitRate())
    }
    if (cachedResult != null) {
      return cachedResult  
    }
    String firstChar = query.length() > 0 ? query.charAt(0) : ""
    String like = ""
    if (!firstChar.isEmpty() && firstChar.matches("[a-zA-ZöäüßÖÄÜ]")) {
        // this improves performance quite a bit, as Levenshtein below is slow...
        String likePart = "'" + firstChar + "%'"
        like = " (word LIKE ${likePart} OR lookup LIKE ${likePart} OR lookup2 LIKE ${likePart}) AND "
    }
    String sql = """SELECT word, lookup, lookup2 FROM memwords WHERE (
              """ + like + """
              (
                (CHAR_LENGTH(word) >= ? AND CHAR_LENGTH(word) <= ?)
                OR
                (CHAR_LENGTH(lookup) >= ? AND CHAR_LENGTH(lookup) <= ?)
                OR
                (CHAR_LENGTH(lookup2) >= ? AND CHAR_LENGTH(lookup2) <= ?))
              )
              ORDER BY word"""
    PreparedStatement ps = null
    ResultSet resultSet = null
    def matches = []
    try {
        ps = conn.prepareStatement(sql)
        int wordLength = query.length()
        def minLength = wordLength - 1
        def maxLength = wordLength + 1
        ps.setInt(1, minLength)
        ps.setInt(2, maxLength)
        ps.setInt(3, minLength)
        ps.setInt(4, maxLength)
        ps.setInt(5, minLength)
        ps.setInt(6, maxLength)
        resultSet = ps.executeQuery()
        // TODO: add some typical cases to be found without levenshtein (s <-> ß, ...)
        String lowercaseQuery = query.toLowerCase()
        while (resultSet.next()) {
          String lowercaseDbTerm = resultSet.getString("word").toLowerCase()
          if (lowercaseDbTerm.equals(lowercaseQuery)) {
            continue
          }
          int dist = StringUtils.getLevenshteinDistance(lowercaseDbTerm, lowercaseQuery, MAX_SIMILARITY_DISTANCE)
          if (dist >= 0 && dist <= MAX_SIMILARITY_DISTANCE) {
            matches.add(new SimilarMatch(term:resultSet.getString("word"), dist:dist))
          } else {
            String lookupTerm = resultSet.getString("lookup")
            maybeAddMatchesFor(lookupTerm, lowercaseQuery, matches, resultSet)
            String lookupTerm2 = resultSet.getString("lookup2")
            maybeAddMatchesFor(lookupTerm2, lowercaseQuery, matches, resultSet)
          }
        }
        Collections.sort(matches)		// makes sure lowest distances come first
    } finally {
        DbUtils.closeQuietly(resultSet)
        DbUtils.closeQuietly(ps)
    }
    simCache.put(query, matches)
    return matches
  }

    private void maybeAddMatchesFor(String lookupTerm, String lowercaseQuery, List matches, ResultSet resultSet) {
        int dist
        if (lookupTerm) {
            String lowercaseLookupTerm = lookupTerm.toLowerCase()
            dist = StringUtils.getLevenshteinDistance(lowercaseLookupTerm, lowercaseQuery, MAX_SIMILARITY_DISTANCE)
            if (dist >= 0 && dist <= MAX_SIMILARITY_DISTANCE) {
                matches.add(new SimilarMatch(term: resultSet.getString("word"), dist: dist))
            }
        }
    }

  /** Substring matches */
  List searchPartialResult(String term, int fromPos, int maxNum) {
    def substringQuery = new SubstringQuery(term, fromPos, maxNum)
    def cachedResult = substringCache.getIfPresent(substringQuery)
    if (cachedResult != null) {
      return cachedResult
    }
    def result = searchPartialResultInternal(term, "%" + term + "%", true, fromPos, maxNum)
    substringCache.put(substringQuery, result)
    return result
  }

  /** Words that start with a given term */
  List searchStartsWithResult(String term, int fromPos, int maxNum) {
    return searchPartialResultInternal(term, term + "%", false, fromPos, maxNum)
  }

  int getPartialResultTotalMatches(String query) {
    Connection conn = null
    PreparedStatement ps = null
    ResultSet resultSet = null
    try {
      conn = dataSource.getConnection()
      String sql = "SELECT count(*) AS totalMatches FROM memwords WHERE word LIKE ?"
      ps = conn.prepareStatement(sql)
      ps.setString(1, "%" + query + "%")
      resultSet = ps.executeQuery()
      resultSet.next()
      return resultSet.getInt("totalMatches")
    } finally {
      DbUtils.closeQuietly(resultSet)
      DbUtils.closeQuietly(ps)
      DbUtils.closeQuietly(conn)
    }
  }

  /** Substring matches */
  private List searchPartialResultInternal(String term, String sqlTerm, boolean filterExactMatch, int fromPos, int maxNum) {
    Connection conn = null
    PreparedStatement ps = null
    ResultSet resultSet = null
    List matches = []
    try {
      conn = dataSource.getConnection()
      String sql = "SELECT word FROM memwords WHERE word LIKE ? ORDER BY word ASC LIMIT ${fromPos}, ${maxNum}"
      ps = conn.prepareStatement(sql)
      ps.setString(1, sqlTerm)
      resultSet = ps.executeQuery()
      while (resultSet.next()) {
        String matchedTerm = resultSet.getString("word")
        if (filterExactMatch && matchedTerm.toLowerCase() == term.toLowerCase()) {
          continue
        }
        String result = matchedTerm.encodeAsHTML()
        matches.add(new PartialMatch(term:matchedTerm, highlightTerm:result))
      }
    } finally {
      DbUtils.closeQuietly(resultSet)
      DbUtils.closeQuietly(ps)
      DbUtils.closeQuietly(conn)
    }
    return matches
  }

  class SubstringQuery {
    String query;
    int from;
    int max;
    SubstringQuery(String query, int from, int max) {
      this.query = query;  
      this.from = from;  
      this.max = max;  
    }

    boolean equals(o) {
      if (this.is(o)) return true
      if (getClass() != o.class) return false
      SubstringQuery that = (SubstringQuery) o
      if (from != that.from) return false
      if (max != that.max) return false
      if (query != that.query) return false
      return true
    }

    int hashCode() {
        int result
        result = (query != null ? query.hashCode() : 0)
        result = 31 * result + from
        result = 31 * result + max
        return result
    }
  }

}
