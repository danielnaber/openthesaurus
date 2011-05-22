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
import java.util.regex.Pattern
import java.util.regex.Matcher
import java.sql.Connection
import java.sql.DriverManager
import java.sql.ResultSet
import java.sql.PreparedStatement
import org.apache.commons.lang.StringUtils
import com.vionto.vithesaurus.tools.IpTools
import com.vionto.vithesaurus.tools.StringTools

class SynsetController extends BaseController {

    // The maximum for the search query. Avoids out of memory
    final int UPPER_BOUND = 1000

    // maximum distance for a term to be accepted as similar term:
    final int MAX_DIST = 3

    private static final String REQUEST_LIMIT_MAX_AGE_SECONDS = "requestLimitMaxAgeSeconds"
    private static final String REQUEST_LIMIT_MAX_REQUESTS = "requestLimitMaxRequests"
    private static final String REQUEST_LIMIT_SLEEP_TIME_MILLIS = "requestLimitSleepTimeMillis"
    private static final String REQUEST_LIMIT_IPS = "requestLimitIps"
    private static final String REQUEST_LIMIT_SPECIAL_IPS_PREFIX = "requestLimitForIp"

    private static apiRequestEvents = []
    private static final int API_REQUEST_QUEUE_SIZE = 500

    def beforeInterceptor = [action: this.&auth,
                             except: ['index', 'list', 'search', 'oldSearch', 'edit', 'statistics',
                                      'createMemoryDatabase', 'variation', 'substring']]

    private static final UNKNOWN_CATEGORY_NAME = 'Unknown'

    // the delete, save and update actions only accept POST requests
    static def allowedMethods = [delete:'POST', save:'POST', update:'POST', addSynonym:'POST']

    def dataSource       // will be injected

    def index = {
        redirect(action:list,params:params)
    }

    /**
     * Show page with statistics about the database, e.g. number of synsets.
     */
    def statistics = {
        // global statistics:
        def criteria = UserEvent.createCriteria()
        int latestChangesAllSections = criteria.count {
          gt('creationDate', new Date() - 7)
        }
        // per-user statistics (i.e. top users):
        Connection conn
        PreparedStatement ps
        ResultSet resultSet
        try {
          conn = dataSource.getConnection()
          String sql = """SELECT user_event.by_user_id, real_name, count(*) AS ct 
            FROM user_event, thesaurus_user
            WHERE
  			thesaurus_user.id = user_event.by_user_id AND
  			user_event.creation_date >= DATE_SUB(NOW(), INTERVAL ? DAY)
  			GROUP BY by_user_id
  		    ORDER BY ct DESC
  		    LIMIT ?"""
          List topUsers = []
          ps = conn.prepareStatement(sql)
          ps.setInt(1, 365)	// days
          ps.setInt(2, 10)	// max matches
          resultSet = ps.executeQuery()
          while (resultSet.next()) {
            topUsers.add(new TopUser(displayName:resultSet.getString("real_name"), actions:resultSet.getInt("ct")))
          }
          [ latestChangesAllSections: latestChangesAllSections,
            topUsers: topUsers ]
        } finally {
          if (resultSet != null) {
            resultSet.close()
          }
          if (ps != null) {
            ps.close()
          }
          if (conn != null) {
            conn.close()
          }
        }
    }

    /*def list = {
        if(!params.max) params.max = 10
        [ synsetList: Synset.findAllByIsVisible(true,
            [sort:params.sort, order:params.order,
             offset:params.offset, max:10]) ]
    }*/

    /**
     * Return a simplified search result snippet to be embedded
     * via Ajax.
     */
    def ajaxSearch = {
        params.ajaxSearch = 1
        search()
    }

    /**
     * Search all terms from a textarea (one query per line) return a page
     * with merged results.
     */
    def multiSearch = {
        def allMatches = []
        String[] searchTerms = getTermsFromTextArea(params.terms)
        for (term in searchTerms) {
              def searchResult = doSearch(term, null, null, null)
              for (match in searchResult.synsetList) {
                if (!allMatches.contains(match)) {
                    allMatches.add(match)
                }
              }
        }
        if (allMatches.size() == 0) {
            flash.message = message(code:'create.no.matches')
        } else {
            flash.message = ""
        }
        [ synsetList : allMatches, searchTerms: searchTerms ]
    }

    /**
     * Handle the old URLs like "http://www.openthesaurus.de/synonyme/search?q=haus" but without redirecting API requests
     */
    def oldSearch = {
      if (params.format == 'text/xml') {
        // we don't redirect API requests to avoid the redirect overhead for mobile devices
        search()
      } else {
        String q = URLEncoder.encode(params.q, "UTF-8")
        RedirectController redirectController = new RedirectController()
        redirectController.permanentRedirect("synonyme/" + q, response)
      }
    }

    /**
     * Search for term and return a page with all synsets that contain
     * the term.
     */
    def search = {
        long startTime = System.currentTimeMillis()

        if (!params.q) {
          log.warn("No query specified for search (${IpTools.getRealIpAddress(request)})")
          response.status = 500
          render message(code:'result.no.query.specified')
          return
        }
        
        Connection conn
        try {
          conn = dataSource.getConnection()
          
          boolean apiRequest = params.format == "text/xml"
          boolean spellApiRequest = params.similar == "true"
          boolean allApiRequest = params.mode == "all"
          int partialApiFromResultRequest = 0
          boolean partialApiRequest = params.substring == "true"
          int startsWithApiFromResultRequest = 0
          boolean startsWithApiRequest = params.startswith == "true"

          List partialMatchResult = []
          List startsWithResult = []
          long partialMatchStartTime = System.currentTimeMillis()
          String sleepTimeInfo = ""
          if (apiRequest) {

            sleepTimeInfo = preventRequestFlooding()

            if (partialApiRequest || allApiRequest) {
              if (params.substringFromResults) {
                partialApiFromResultRequest = Integer.parseInt(params.substringFromResults)
              }
              int partialApiMaxResultsRequest = 10
              if (params.substringMaxResults) {
                partialApiMaxResultsRequest = Integer.parseInt(params.substringMaxResults)
                if (partialApiMaxResultsRequest > 250) {
                  partialApiMaxResultsRequest = 250
                }
              }
              partialMatchResult = searchPartialResult(params.q, conn, partialApiFromResultRequest, partialApiMaxResultsRequest)
            }
            if (startsWithApiRequest || allApiRequest) {
              if (params.startsWithFromResults) {
                startsWithApiFromResultRequest = Integer.parseInt(params.startsWithFromResults)
              }
              int startsWithApiMaxResultsRequest = 10
              if (params.startsWithMaxResults) {
                startsWithApiMaxResultsRequest = Integer.parseInt(params.startsWithMaxResults)
                if (startsWithApiMaxResultsRequest > 250) {
                  startsWithApiMaxResultsRequest = 250
                }
              }
              startsWithResult = searchStartsWithResult(params.q, conn, startsWithApiFromResultRequest, startsWithApiMaxResultsRequest)
            }
          } else {
            // we display 10 matches in the page and use the next one (if any) to
            // decide whether there are more matches:
            partialMatchResult = searchPartialResult(params.q, conn, 0, 11)
          }
          long partialMatchTime = System.currentTimeMillis() - partialMatchStartTime
          
          List wikipediaResult = []
          long wikipediaStartTime = System.currentTimeMillis()
          if (!apiRequest) {
            wikipediaResult = searchWikipedia(params.q, conn)
          }
          long wikipediaTime = System.currentTimeMillis() - wikipediaStartTime

          List wiktionaryResult = []
          long wiktionaryStartTime = System.currentTimeMillis()
          if (!apiRequest) {
            wiktionaryResult = searchWiktionary(params.q, conn)
          }
          long wiktionaryTime = System.currentTimeMillis() - wiktionaryStartTime
          
          List similarTerms = []
          long similarStartTime = System.currentTimeMillis()
          if (apiRequest) {
            if (spellApiRequest || allApiRequest) {
              similarTerms = searchSimilarTerms(params.q, conn)
            } else {
              similarTerms = null
            }
          } else {
            similarTerms = searchSimilarTerms(params.q, conn)
          }
          long similarTime = System.currentTimeMillis() - similarStartTime

          Section section = null
          Source source = null
          Category category = null
          if (!params['ajaxSearch']) {
              if (params['section.id']) {
                  section = params['section.id'] == "null" ?
                          null : Section.get(params['section.id'])
              }
              if (params['source.id']) {
                  source = params['source.id'] == "null" ?
                          null : Source.get(params['source.id'])
              }
              if (params['category.id']) {
                  category = params['category.id'] == "null" ?
                          null : Category.get(params['category.id'])
              }
          }
          int offset = params.offset ? Integer.parseInt(params.offset) : 0
          int maxResults = params.max ? Integer.parseInt(params.max) : 10
          long dbStartTime = System.currentTimeMillis()
          def searchResult = doSearch(params.q.trim(), section, source, category,
                  maxResults, offset)
          long dbTime = System.currentTimeMillis() - dbStartTime
          long totalTime = System.currentTimeMillis() - startTime
          
          boolean mobileBrowser = BrowserDetection.isMobileDevice(request)
          String mobileInfo = mobileBrowser ? "m=y" : "m=n"
          
          String qType = params.format == "text/xml" ? "xml" : "htm"
          log.info("Search(ms):${qType} ${mobileInfo} ${totalTime} db:${dbTime}${sleepTimeInfo} sim:${similarTime}"
               + " substr:${partialMatchTime} wikt:${wiktionaryTime} wiki:${wikipediaTime}"
               + " q:${params.q}")
            
          // TODO: fix json output
          //if (params.format == "text/xml" || params.format == "text/json") {
          if (apiRequest) {
            renderApiResponse(searchResult, similarTerms, partialMatchResult, startsWithResult)
            return
          }

          // for temporary stats:
          /*if (wikipediaResult != null && wikipediaResult.size() > 0) {
            if (Title45info.findByTitle(params.q)) {
              log.info("45info cliplink" + ", UA: " + request.getHeader("User-Agent"))
            } else {
              log.info("45info searchlink" + ", UA: " + request.getHeader("User-Agent"))
            }
            log.info("eyeplorer pagelink" + ", UA: " + request.getHeader("User-Agent"))
          }*/

          String descriptionText = null
          if (searchResult.totalMatches > 0) {
            int wordCount = 0
            StringBuilder synonymsForDescription = new StringBuilder()
            for (Synset synset in searchResult.synsetList) {
              for (Term term in synset?.sortedTerms()) {
                if (wordCount < 15) {
                  synonymsForDescription.append(term.toString())
                  synonymsForDescription.append(", ")
                  wordCount++
                }
              }
            }
            descriptionText = synonymsForDescription.toString()
          }

          [ partialMatchResult : partialMatchResult,
            wikipediaResult : wikipediaResult,
            wiktionaryResult : wiktionaryResult,
            similarTerms : similarTerms,
            synsetList : searchResult.synsetList,
            totalMatches: searchResult.totalMatches,
            completeResult: searchResult.completeResult,
            upperBound: UPPER_BOUND,
            mobileBrowser: mobileBrowser,
            descriptionText : descriptionText,
            runTime : totalTime ]

        } finally {
          if (conn != null) {
            conn.close()
          }
        }
              
    }

  // artificially slow down response if users make too many requests
  private String preventRequestFlooding() {
    while (apiRequestEvents.size() > API_REQUEST_QUEUE_SIZE) {
      apiRequestEvents.remove(0)
    }
    String ip = IpTools.getRealIpAddress(request)
    apiRequestEvents.add(new ApiRequestEvent(ip, new Date()))

    int maxAgeSeconds = 60
    ThesaurusConfigurationEntry maxAgeSecondsObj = ThesaurusConfigurationEntry.findByKey(REQUEST_LIMIT_MAX_AGE_SECONDS)
    if (maxAgeSecondsObj != null) {
      maxAgeSeconds = Integer.parseInt(maxAgeSecondsObj.value)
    }

    int maxRequests = 5
    ThesaurusConfigurationEntry maxRequestsObj = ThesaurusConfigurationEntry.findByKey(REQUEST_LIMIT_MAX_REQUESTS)
    if (maxRequestsObj != null) {
      maxRequests = Integer.parseInt(maxRequestsObj.value)
    }

    long sleepTime = 5000
    ThesaurusConfigurationEntry sleepTimeObj = ThesaurusConfigurationEntry.findByKey(REQUEST_LIMIT_SLEEP_TIME_MILLIS)
    if (sleepTimeObj != null) {
      sleepTime = Long.parseLong(sleepTimeObj.value)
    }

    List slowDownIps = [] 
    ThesaurusConfigurationEntry slowDownIpsObj = ThesaurusConfigurationEntry.findByKey(REQUEST_LIMIT_IPS)
    if (slowDownIpsObj != null) {
      slowDownIps = slowDownIpsObj.value.split(",")
    }

    ThesaurusConfigurationEntry specialIpConfig = ThesaurusConfigurationEntry.findByKey(REQUEST_LIMIT_SPECIAL_IPS_PREFIX + "-" + ip)
    if (specialIpConfig != null) {
      String[] specialIpConfigValues = specialIpConfig.value.split(";")
      maxAgeSeconds = specialIpConfigValues[0] == "-" ? maxAgeSeconds : Integer.parseInt(specialIpConfigValues[0])
      maxRequests = specialIpConfigValues[1] == "-" ? maxRequests : Integer.parseInt(specialIpConfigValues[1])
      sleepTime = specialIpConfigValues[2] == "-" ? sleepTime : Integer.parseInt(specialIpConfigValues[2])
    }

    String sleepTimeInfo = ""
    if (slowDownIps.contains(ip) || ApiRequestEvent.limitReached(ip, apiRequestEvents, maxAgeSeconds, maxRequests)) {
      Thread.sleep(sleepTime)
      sleepTimeInfo = "+" + sleepTime + "ms"
    }
    return sleepTimeInfo
  }

  private void renderApiResponse(def searchResult, List similarTerms, List substringTerms, List startsWithTerms) {
      // see http://jira.codehaus.org/browse/GRAILSPLUGINS-709 for a required
      // workaround with feed plugin 1.4 and Grails 1.1
      render(contentType:params.format, encoding:"utf-8") {
        matches {
          metaData {
            apiVersion(content:"0.1.3")
            if (grailsApplication.config.thesaurus.apiWarning) {
              warning(content:grailsApplication.config.thesaurus.apiWarning)
            }
            copyright(content:grailsApplication.config.thesaurus.apiCopyright)
            license(content:grailsApplication.config.thesaurus.apiLicense)
            source(content:grailsApplication.config.thesaurus.apiSource)
            date(content:new Date().toString())
          }
          for (s in searchResult.synsetList) {
            //FIXME: the attribute used here flattens and thus destroys the JSON
            // while it works fine for XML:
            synset(id:s.id) {
              if (s.categoryLinks != null) {
                categories {
                  for (catLink in s.categoryLinks) {
                    category(name:catLink.category.categoryName)
                  }
                }
              }
              for (t in s.sortedTerms()) {
                if (t.level) {
                  term(term:t, level:t.level.levelName)
                } else {
                  term(term:t)
                }
              }                    
            }
          }
          if (similarTerms) {
            similarterms {
              int i = 0
              for (simTerm in similarTerms) {
                term(term:simTerm.term, distance:simTerm.dist)
                if (++i >= 5) {
                  break
                }
              }
            }
          }
          if (substringTerms && substringTerms.size() > 0) {
            substringterms {
              for (substringTerm in substringTerms) {
                term(term:substringTerm.term)
              }
            }
          }
          if (startsWithTerms && startsWithTerms.size() > 0) {
            startswithterms {
              for (startsWithTerm in startsWithTerms) {
                term(term:startsWithTerm.term)
              }
            }
          }
        }
      }
    }
    
    def substring = {
      if(!params.offset) params.offset = "0"
      if(!params.max) params.max = "20"
      int offset = Integer.parseInt(params.offset)
      int maxMatches = Integer.parseInt(params.max)
      Connection conn
      PreparedStatement ps
      ResultSet resultSet
      try {
        conn = dataSource.getConnection()
        List partialMatchResult = searchPartialResult(params.q, conn, offset, maxMatches)
        // get total matches:
        String sql = "SELECT count(*) AS totalMatches FROM memwords WHERE word LIKE ?"
        ps = conn.prepareStatement(sql)
        ps.setString(1, "%" + params.q + "%")
        resultSet = ps.executeQuery()
        resultSet.next()
        int totalMatches = resultSet.getInt("totalMatches")
        [matches: partialMatchResult, totalMatches: totalMatches]
      } finally {
        if (resultSet != null) {
          resultSet.close()
        }
        if (ps != null) {
          ps.close()
        }
        if (conn != null) {
          conn.close()
        }
      }
     }

    /** Substring matches */
    private List searchPartialResult(String term, Connection conn, int fromPos, int maxNum) {
      return searchPartialResultInternal(term, "%" + term + "%", true, conn, fromPos, maxNum)
    }

    /** Words that start with a given term */
    private List searchStartsWithResult(String term, Connection conn, int fromPos, int maxNum) {
      return searchPartialResultInternal(term, term + "%", false, conn, fromPos, maxNum)
    }

    /** Substring matches */
    private List searchPartialResultInternal(String term, String sqlTerm, boolean filterExactMatch, Connection conn, int fromPos, int maxNum) {
      String sql = "SELECT word FROM memwords WHERE word LIKE ? ORDER BY word ASC LIMIT ${fromPos}, ${maxNum}"
      PreparedStatement ps
      ResultSet resultSet
      def matches = []
      try {
          ps = conn.prepareStatement(sql)
          ps.setString(1, sqlTerm)
          resultSet = ps.executeQuery()
          //Pattern pattern = Pattern.compile(Pattern.quote(term.encodeAsHTML()), Pattern.CASE_INSENSITIVE)
          while (resultSet.next()) {
            String matchedTerm = resultSet.getString("word")
            if (filterExactMatch && matchedTerm.toLowerCase() == term.toLowerCase()) {
              continue
            }
            String result = matchedTerm.encodeAsHTML()
            // currently not useful:
            //Matcher m = pattern.matcher(result)
            //result = m.replaceAll("<span class='match'>\$0</span>")
            matches.add(new PartialMatch(term:matchedTerm, highlightTerm:result))
          }
      } finally {
          if (resultSet != null) {
            resultSet.close()
          }
          if (ps != null) {
            ps.close()
          }
      }
      return matches
   }

    /**
     * Create the in-memory database of all terms for fast substring search
     */
    // TODO: use quartz
    def createMemoryDatabase= {
      if (!isLocalHost(request)) {
        throw new Exception("Access denied from " + IpTools.getRealIpAddress(request))
      }

      log.info("Creating in-memory database, request by " + IpTools.getRealIpAddress(request))
      Connection conn
      PreparedStatement ps
      try {
        conn = dataSource.getConnection()
        executeQuery("DROP TABLE IF EXISTS memwordsTmp", conn)
        executeQuery("CREATE TABLE IF NOT EXISTS memwordsTmp (word VARCHAR(50) NOT NULL, lookup VARCHAR(50)) ENGINE = MEMORY COLLATE = 'utf8_general_ci'", conn)
        executeQuery("CREATE TABLE IF NOT EXISTS memwords (word VARCHAR(50) NOT NULL, lookup VARCHAR(50)) ENGINE = MEMORY COLLATE = 'utf8_general_ci'", conn)
      
        ps = conn.prepareStatement("INSERT INTO memwordsTmp (word, lookup) VALUES ('__last_modified__', ?)")
        ps.setString(1, new Date().toString())
        ps.execute()

        // setString() on a PreparedStatement won't work, so insert value of hidden synsets directly:
        String sql = """INSERT INTO memwordsTmp SELECT DISTINCT word, normalized_word
            FROM term, synset
            WHERE 
              term.synset_id = synset.id AND
              synset.is_visible = 1 AND
              synset.id NOT IN (${grailsApplication.config.thesaurus.hiddenSynsets})
            ORDER BY word"""
        ps = conn.prepareStatement(sql)
        ps.execute()

        executeQuery("RENAME TABLE memwords TO memwordsBak, memwordsTmp TO memwords", conn)
        executeQuery("DROP TABLE memwordsBak", conn)

        log.info("Finished creating in-memory database")
        render "OK"
      } finally {
          if (ps != null) {
            ps.close()
          }
          if (conn != null) {
            conn.close()
          }
      }
    }
    
    private void executeQuery(String sql, Connection conn) {
      PreparedStatement ps
      try {
        ps = conn.prepareStatement(sql)
        ps.execute()
      } finally {
        if (ps != null) {
          ps.close()
        }
      }
    }    

    def searchWikipedia(String term, Connection conn) {
      if (grailsApplication.config.thesaurus.wikipediaLinks != "true") {
        return null
      }
      String sql = """SELECT link, title FROM wikipedia_links, wikipedia_pages
            WHERE wikipedia_pages.title = ? AND wikipedia_pages.page_id = wikipedia_links.page_id"""
      PreparedStatement ps
      ResultSet resultSet
      def matches = []
      try {
          ps = conn.prepareStatement(sql)
          ps.setString(1, term)
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
        if (resultSet != null) {
          resultSet.close()
        }
        if (ps != null) {
          ps.close()
        }
      }
      return matches
    }

    def searchWiktionary(String term, Connection conn) {
      if (grailsApplication.config.thesaurus.wiktionaryLinks != "true") {
        return null
      }
      String sql = """SELECT headword, meanings, synonyms FROM wiktionary WHERE headword = ?"""
      PreparedStatement ps 
      ResultSet resultSet
      def matches = []
      try {
        ps = conn.prepareStatement(sql)
        ps.setString(1, term)
        resultSet = ps.executeQuery()
        if (resultSet.next()) {
          matches.add(resultSet.getString("headword"))
          matches.add(resultSet.getString("meanings"))
          matches.add(resultSet.getString("synonyms"))
        }
      } finally {
        if (resultSet != null) {
          resultSet.close()
        }
        if (ps != null) {
          ps.close()
        }
      }
      return matches
    }
    
    def searchSimilarTerms(String term, Connection conn) {
      String sql = """SELECT word, lookup FROM memwords 
			WHERE ((
				CHAR_LENGTH(word) >= ? AND CHAR_LENGTH(word) <= ?)
				OR
				(
				CHAR_LENGTH(lookup) >= ? AND CHAR_LENGTH(lookup) <= ?))
				ORDER BY word"""
      PreparedStatement ps
      ResultSet resultSet
      def matches = []
      try {
          ps = conn.prepareStatement(sql)
          int wordLength = term.length()
          ps.setInt(1, wordLength-1)
          ps.setInt(2, wordLength+1)
          ps.setInt(3, wordLength-1)
          ps.setInt(4, wordLength+1)
          resultSet = ps.executeQuery()
          // TODO: add some typical cases to be found without levenshtein (s <-> ß, ...)
          String lowerTerm = term.toLowerCase()
          while (resultSet.next()) {
            String dbTerm = resultSet.getString("word").toLowerCase()
            if (dbTerm.equals(lowerTerm)) {
              continue
            }
            //TODO: use a fail-fast algorithm here (see Lucene's FuzzyTermQuery):
            int dist = StringUtils.getLevenshteinDistance(dbTerm, lowerTerm)
            if (dist <= MAX_DIST) {
              matches.add(new SimilarMatch(term:resultSet.getString("word"), dist:dist))
            } else {
              dbTerm = resultSet.getString("lookup")
              if (dbTerm) {
                dbTerm = dbTerm.toLowerCase()
                dist = StringUtils.getLevenshteinDistance(dbTerm, lowerTerm)
                if (dist <= MAX_DIST) {
                  matches.add(new SimilarMatch(term:resultSet.getString("word"), dist:dist))
                }
              }
            }
          }
          Collections.sort(matches)		// makes sure lowest distances come first
      } finally {
          if (resultSet != null) {
            resultSet.close()
          }
          if (ps != null) {
            ps.close()            
          }
      }
      return matches
    }

    def variation = {
      String limit = ""
      if (params.id == 'ch') {
        limit = "schweiz."
      } else if (params.id == 'at') {
        limit = "österr."
      } else {
        throw new Exception("Unknown variation '${params.id}'")
      }
      String headline = message(code:'variation.headline.' + params.id)
      String title = message(code:'variation.title.' + params.id)
      String intro = message(code:'variation.intro.' + params.id)
      def termList = Term.withCriteria {
          or {
            ilike('word', "%" + limit + "%")
          }
          synset {
              eq('isVisible', true)
          }
          order('word', 'asc')
      }
      [headline: headline, title: title, intro: intro,
       termList: termList]
    }

    /**
     * Internal implementation of the search via fulltext (currently disabled)
     * or database search via Hibernate query.
     * See doDBSearch() for parameters.
     */
    def doSearch(String query, Section section, Source source, Category category,
            int max = -1, int offset = 0) {
        // currently we always use DB search, not fulltext search
        // because it was too slow on indexing:
        //log.info("search for ${query} (section:${section}, source:${source}, " +
        //        "category:${category})")
        return doDBSearch(query, section, source, category, max, offset)
    }

    /**
     * Hibernate-based search implementation. Note that the number
     * of total matches is not always accurate.
     */
    def doDBSearch(String query, Section section, Source source,
            Category category, int max = -1, int offset = 0) {
        String sortField = params.sort ? params.sort : "synsetPreferredTerm"
        if (grailsApplication.config.thesaurus.prefTerm == 'false') {
          sortField = params.sort ? params.sort : "id"
        }
        String sortOrder = params.order ? params.order : "asc"

        boolean completeResult = false

        //long t = System.currentTimeMillis()
        
        // TODO: why don't we use Synset.withCriteria here, it would
        // free us from the need to remove duplicates manually
        // => there's a bug(?) so that the synsets are incomplete,
        // i.e. the terms are missing unless they match "ilike('word', query)",
        // see http://jira.codehaus.org/browse/GRAILS-2793
        // TODO: use HQL or SQL so we can make use of Oracle's lowercase index
        def termList = Term.withCriteria {
            or {
              eq('word', query)
              eq('normalizedWord', StringTools.normalize(query))
            }
            synset {
                if (section) {
                    eq('section', section)
                }
                if (source) {
                    eq('source', source)
                }
                if (category) {
                    or {
                        eq('preferredCategory', category)
                        preferredCategory {
                            eq('categoryType', category)
                        }
                    }
                }
                eq('isVisible', true)
                order(sortField, sortOrder)
                maxResults(UPPER_BOUND)
            }
        }
        int totalMatches = termList.size()
        if (totalMatches < UPPER_BOUND) {
            completeResult = true
        }
        
        //log.info(">>"+(System.currentTimeMillis()-t) + "ms")
        
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

    /**
     * Split a string and return an array so that each non-empty
     * line is one array item.
     */
    String[] getTermsFromTextArea(String str) {
        String[] terms = str.split("[\n\r]")
        return terms.findAll { term -> term.trim() != "" }
    }

    def edit = {

        long startTime = System.currentTimeMillis()
        if (!params.containsKey("id")) {
            flash.message = "Please select a concept."
            redirect(action:list)
            return
        }
        def synset = Synset.get( params.id )

        if(!synset) {
            flash.message = "Concept not found with id ${params.id}"
            // TODO: don't go to list view
            redirect(action:list)
        }
        else {
            if (!params.max) params.max = 10
            if (!params.sort) params.sort = "creationDate"
            if (!params.order) params.order = "desc"
            def eventListCount = UserEvent.countBySynset(synset)
            def eventList = UserEvent.findAllBySynset(synset,
                    [order:'desc', sort:'creationDate', offset: params.offset, max: params.max])
            def diffs = [:]
            def typeNames = [:]
            UserEventTools tools = new UserEventTools()
            tools.buildMetaInformation(eventList, diffs, typeNames)
            boolean showOrigSource =
                grailsApplication.config.thesaurus.showOriginalSource == "true"
            long runTime = System.currentTimeMillis() - startTime
            boolean prefTerms = grailsApplication.config.thesaurus.prefTerm != 'false'
            return [ synset : synset, eventListCount : eventListCount, eventList : eventList, prefTerms: prefTerms,
                     diffs: diffs, typeNames : typeNames, showOrigSource : showOrigSource,
                     runTime : runTime ]
        }
    }

    def hide = {
        hideSynset(true, message(code:'edit.delete.missing.comment'),
            message(code:'edit.delete.success'))
    }
    
    def unhide = {
        hideSynset(false, message(code:'edit.delete.missing.comment'),
            message(code:'edit.undelete.success'))
    }
    
    private hideSynset(boolean hide, String errorMsg, String successMsg) {
        def synset = Synset.get(params.id)
        def origSynset = synset.clone()
        
        if (!params.changeComment || params.changeComment.trim().equals("")) {
            synset.errors.reject('thesaurus.error',
                  [].toArray(), errorMsg)
            render(view:'edit',model:[synset:synset],
                  contentType:"text/html", encoding:"UTF-8")
            return
        }
        
        // "delete" the synset: 
        synset.isVisible = !hide
        
        LogInfo logInfo = new LogInfo(session, IpTools.getRealIpAddress(request),
            origSynset, synset, params.changeComment)
        if(!synset.hasErrors() && synset.saveAndLog(logInfo)) {
            flash.message = successMsg
            redirect(action:edit,id:synset.id)
        }
        else {
            synset.errors.reject('thesaurus.error',
                [].toArray(), 'Could not save and/or log changes')
            render(view:'edit',model:[synset:synset],
                    contentType:"text/html", encoding:"UTF-8")
        }
    }
    
    def update = {
        def synset = Synset.get(params.id)
        def origSynset = synset.clone()

        if (synset) {
            synset.properties = params
            // add links to other synsets:
            List linkTypes = LinkType.getAll()
            for (linkType in linkTypes) {
                String synsetParamId = params["targetSynset" + linkType.linkName + ".id"]
                if (synsetParamId) {
                    Synset targetSynset = Synset.get(synsetParamId)
                    if (targetSynset == null) {
                        throw new Exception("Synset not found for link type: " + linkType.linkName)
                    }
                    String linkTypeToUseParam = "linkType" + linkType.linkName + ".id"
                    LinkType linkTypeToUse = LinkType.get(params[linkTypeToUseParam])
                    if (linkTypeToUse == null) {
                        throw new Exception("Link type not found: " + linkTypeToUseParam)
                    }
                    if (synset.id == targetSynset.id) { // don't link a synset to itself
                        synset.errors.reject('thesaurus.error.synset.selfreference', [].toArray(), 'Error saving changes')
                        render(view:'edit',model:[synset:synset], contentType:"text/html", encoding:"UTF-8")
                        return
                    } else {
                        addSynsetLink(synset, targetSynset, linkTypeToUse)
                    }
                }
            }
            // delete synset hypernym links:
            /*if (params.delete_link) {
                List deleteIDs = getCheckboxIDs(params.delete_link)
                for (deleteID in deleteIDs) {
                    SynsetLink synsetLink = SynsetLink.get(deleteID)
                    synset.removeLink(synsetLink)
                }
            }*/
            // reject hypernym/hyponym links:
            List rejectedIDs = getEvaluationRadioButtonIDs(log, "evaluate_link_", "reject")
            for (rejectedID in rejectedIDs) {
                SynsetLink synsetLink = SynsetLink.get(rejectedID)
                int oldStatus = synsetLink.evaluationStatus
                synsetLink.evaluationStatus = SynsetLink.EVAL_REJECTED
                if (oldStatus != synsetLink.evaluationStatus) {
                    String logText =
                        "rejecting: ${synsetLink.targetSynset.toShortString()} " +
                        "${synsetLink.linkType.verbName} " +
                        "${synsetLink.synset.toShortString()}"
                    logSynsetLink(logText, synset, synsetLink)
                }
            }
            // approve hypernym/hyponym links:
            List approvedIDs = getEvaluationRadioButtonIDs(log, "evaluate_link_", "approve")
            for (approveID in approvedIDs) {
                SynsetLink synsetLink = SynsetLink.get(approveID)
                int oldStatus = synsetLink.evaluationStatus
                synsetLink.evaluationStatus = SynsetLink.EVAL_APPROVED
                if (oldStatus != synsetLink.evaluationStatus) {
                    String logText =
                        "approving: ${synsetLink.targetSynset.toShortString()} " +
                        "${synsetLink.linkType.verbName} " +
                        "${synsetLink.synset.toShortString()}"
                    logSynsetLink(logText, synset, synsetLink)
                }
            }
            // set all other links to neither approved nor rejected, i.e. delete them:
            List neutralIDs = getEvaluationRadioButtonIDs(log, "evaluate_link_", "neutral")
            for (neutralID in neutralIDs) {
                SynsetLink synsetLink = SynsetLink.get(neutralID)
                String logText =
                    "neutralizing: ${synsetLink.targetSynset.toShortString()} " +
                    "${synsetLink.linkType.verbName} " +
                    "${synsetLink.synset.toShortString()}"
                logSynsetLink(logText, synset, synsetLink)
                synset.removeFromSynsetLinks(synsetLink)
                synsetLink.delete()
            }

            // reject hypernym/hyponym links that have been automatically suggested:
            List rejectedSuggestionIDs = getEvaluationRadioButtonIDs(log,
                    "evaluate_suggestion_link_", "reject")
            for (rejectID in rejectedSuggestionIDs) {
                saveSynsetLink(rejectID, SynsetLink.EVAL_REJECTED, synset)
            }

            // approve hypernym/hyponym links that have been automatically suggested:
            List approvedSuggestionIDs = getEvaluationRadioButtonIDs(log,
                    "evaluate_suggestion_link_", "approve")
            for (approveID in approvedSuggestionIDs) {
                saveSynsetLink(approveID, SynsetLink.EVAL_APPROVED, synset)
            }

            // delete terms:
            if (params.delete) {
                // we get a string or an array, depending on whether
                // one ore more checkboxes were selected:
                List deleteIDs = getCheckboxIDs(params.delete)
                if (synset.terms.size()-deleteIDs.size() <= 0) {
                    synset.errors.reject('thesaurus.empty.synset',
                            [].toArray(), 'Error saving changes')
                    render(view:'edit',model:[synset:synset],
                            contentType:"text/html", encoding:"UTF-8")
                    return
                }
                for (deleteID in deleteIDs) {
                    Term delTerm = Term.get(deleteID)
                    try {
                        synset.removeTerm(delTerm)
                    } catch(IllegalArgumentException e) {
                        synset.errors.reject(e.getMessage(),
                                [].toArray(), e.getMessage())
                        render(view:'edit',model:[synset:synset],
                                contentType:"text/html", encoding:"UTF-8")
                        return
                    }
                }
            }
            // delete category links:
            if (params.delete_category) {
                List deleteIDs = getCheckboxIDs(params.delete_category)
                // don't allow removing the last category: 
                /*if (synset.categoryLinks.size()-deleteIDs.size() <= 0) {
                    synset.errors.reject('thesaurus.empty.category',
                            [].toArray(), 'concept must contain a category')
                    render(view:'edit',model:[synset:synset],
                            contentType:"text/html", encoding:"UTF-8")
                    return
                }*/
                for (deleteID in deleteIDs) {
                    CategoryLink catLink = CategoryLink.get(deleteID)
                    synset.removeLink(catLink)
                }
            }
            // change or add a category link:
            int newCategoryCount = 0
            while (newCategoryCount < Integer.parseInt(grailsApplication.config.thesaurus.maxNewCategories)) {
                if (params['category.id_'+newCategoryCount] == "null") {
                    newCategoryCount++
                    continue
                }
                if (synset.preferredCategory?.categoryName == UNKNOWN_CATEGORY_NAME) {
                    def catLinks = CategoryLink.findAllBySynset(synset)
                    if (catLinks.size() > 1) {
                        synset.errors.reject('thesaurus.error.category.change',
                                [].toArray(), 'change not possible')
                        render(view:'edit',model:[synset:synset],
                                contentType:"text/html", encoding:"UTF-8")
                        return
                    }
                    CategoryLink catLink = catLinks.getAt(0)
                    synset.removeLink(catLink)
                }
                addCategory(synset, params['category.id_'+newCategoryCount])
                newCategoryCount++
            }
            // change preferred category:
            if (params.preferred_category) {
                Category category = Category.get(params.preferred_category)
                //log.info("params.preferred_category = ${params.preferred_category}, cat = ${category}")
                // not setting active to 'Unknown'
                if (category.categoryName != UNKNOWN_CATEGORY_NAME) {
                    synset.preferredCategory = category
                }
            }
            // change preferred term:
            Set languages = getLanguages(synset)
            if (grailsApplication.config.thesaurus.prefTerm == 'true') {
              for (language in languages) {
                def termID = params["preferred_"+language.shortForm]
                if (termID == null) {
                    log.warn("No preferred term id for ${language.shortForm}")
                } else {
                    def term = Term.get(termID)
                    if (term == null) {
                        log.warn("No term found for id ${termID}")
                    } else {
                        synset.setPreferredTerm(language, term)
                    }
                }
              }
            }
            // add new term:
            int newTermCount = 0
            while (newTermCount < Integer.parseInt(grailsApplication.config.thesaurus.maxNewTerms)) {
                if (!params['word_'+newTermCount]) {
                    newTermCount++
                    continue
                }
                def language = Language.get(params['language.id_'+newTermCount])
                Term newTerm = new Term(params['word_'+newTermCount], language, synset)
                newTerm.isShortForm = params['wordForm_'+newTermCount] == "abbreviation" ? true : false
                newTerm.isAcronym = params['wordForm_'+newTermCount] == "acronym" ? true : false
                if (params['level.id_'+newTermCount] && params['level.id_'+newTermCount] != "null") {
                    newTerm.level = TermLevel.get(params['level.id_'+newTermCount])
                }
                if (params['wordGrammar.id_'+newTermCount] && params['wordGrammar.id_'+newTermCount] != "null") {
                    newTerm.wordGrammar = WordGrammar.get(params['wordGrammar.id_'+newTermCount])
                }
                LogInfo logInfo = new LogInfo(session, IpTools.getRealIpAddress(request),
                      null, newTerm, params.changeComment)
                if (synset.containsWord(params['word_'+newTermCount])) {
                    newTerm.errors.reject('thesaurus.duplicate.term',
                          [newTerm.encodeAsHTML()].toArray(),
                          'already in concept')
                    render(view:'edit',model:[synset:synset, newTerm:newTerm],
                            contentType:"text/html", encoding:"UTF-8")
                    return
                }
                if (!newTerm.validate()) {
                    render(view:'edit',model:[synset:synset, newTerm:newTerm],
                            contentType:"text/html", encoding:"UTF-8")
                    return
                }
                try {
                    if (!newTerm.extendedValidate()) {
                        return
                    }
                } catch (IllegalArgumentException e) {
                    synset.errors.reject(e.getMessage(),
                            [].toArray(), e.getMessage())
                    render(view:'edit',model:[synset:synset, newTerm:newTerm],
                            contentType:"text/html", encoding:"UTF-8")
                    return
                }

                synset.addTerm(newTerm)
                if (!synset.hasPreferredTerm(newTerm.language) 
                      && grailsApplication.config.thesaurus.prefTerm == 'true') {
                    synset.setPreferredTerm(newTerm.language, newTerm)
                }
                def saved = newTerm.saveAndLog(logInfo)
                if (!saved) {
                    render(view:'edit',model:[synset:synset, newTerm:newTerm],
                            contentType:"text/html", encoding:"UTF-8")
                    return
                }
                newTermCount++
            }

            LogInfo logInfo = new LogInfo(session, IpTools.getRealIpAddress(request),
                    origSynset, synset, params.changeComment)
            if(!synset.hasErrors() && synset.saveAndLog(logInfo)) {
                flash.message = message(code:'edit.updated')
                redirect(action:edit,id:synset.id)
            }
            else {
                synset.errors.reject('thesaurus.error',
                    [].toArray(), 'Could not save and/or log changes')
                render(view:'edit',model:[synset:synset],
                        contentType:"text/html", encoding:"UTF-8")
            }
        }
        else {
            flash.message = "Concept not found with id ${params.id}"
            redirect(action:edit,id:params.id)
        }
    }

    /**
     * Get the values of the checkboxes that are selected. Useful if there's
     * more than one checkbox with the same name.
     */
    def getCheckboxIDs(Object param) {
        List ids = new ArrayList()
        if (param.getClass().isArray()) {
            // more than one checkbox selected
            ids.addAll(Arrays.asList(param))
        } else {
            // one checkbox selected
            ids.add(param)
        }
        return ids
    }

    private void saveSynsetLink(int synsetLinkId, int evalStatus, Synset synset) {
        SynsetLinkSuggestion synsetSuggestionLink = SynsetLinkSuggestion.get(synsetLinkId)
        SynsetLink synsetLink = new SynsetLink(synsetSuggestionLink)
        synsetLink.evaluationStatus = evalStatus
        boolean saved = synsetLink.save()
        if (!saved) {
            throw new Exception("Could not save link: ${synsetLink.errors}, status $evalStatus")
        }
        String actionName
        if (evalStatus == SynsetLink.EVAL_APPROVED) {
            actionName = "approving"
        } else if (evalStatus == SynsetLink.EVAL_REJECTED) {
            actionName = "rejecting"
        } else {
            throw new Exception("Unknown eval status: $evalStatus")
        }
        String logText =
            "$actionName: ${synsetLink.synset.toShortString()} " +
            "${synsetLink.linkType.verbName} " +
            "${synsetLink.targetSynset.toShortString()}"
        logSynsetLink(logText, synset, synsetLink)
    }

    private void logSynsetLink(String logText, Synset synset, SynsetLink synsetLink) {
        LogInfo linkLogInfo = new LogInfo(session, IpTools.getRealIpAddress(request), synsetLink,
                logText, params.changeComment)
        boolean saved = synset.saveAndLog(linkLogInfo)
        if (!saved) {
            throw new Exception("Could not save approve log: ${synset.errors}")
        }
    }

    /**
     * Get the IDs of keys like "evaluate_link_1944" that have the given
     * val as their value. The id is the part of the key after paramPrefix.
     */
    List getEvaluationRadioButtonIDs(def log, String paramPrefix, String val) {
        List ids = []
        for (param in params) {
            if (param.key.startsWith(paramPrefix) && param.value == val) {
                String id = param.key.substring(paramPrefix.length())
                ids.add(Integer.parseInt(id))
            }
        }
        return ids
    }

    def create = {
        def synset = new Synset()
        synset.properties = params
        return ['synset':synset]
    }

    /**
     * Add the given word to the given synset (called via Ajax).
     */
    def addSynonym = {
        if (!params.id) throw new Exception("parameter 'id' must be set")
        if (!params.word) throw new Exception("parameter 'word' must be set")
        Synset synset = Synset.get(params.id)
        assert(synset.isVisible)
        Language firstLanguage
        // We use the first language we found in the synset, unless there are
        // more languages:
        for (term in synset.terms) {
            if (firstLanguage && firstLanguage != term.language) {
                response.status = 500
                render "<strong>Error: language cannot be detected automatically</strong>"
                return
            }
            if (!firstLanguage) {
                firstLanguage = term.language
            }
        }
        Term newTerm = new Term(params.word, firstLanguage, synset)
        TermValidator validator = new TermValidator(newTerm)
        try {
            validator.extendedValidate()
        } catch (IllegalArgumentException e) {
            response.status = 500
            render "<strong>Error: term cannot be validated: ${e.encodeAsHTML()}</strong>"
            return
        }
        if (!newTerm.validate()) {
            response.status = 500
            render "<strong>Error: term cannot be validated: ${newTerm.errors}</strong>"
            return
        }
        Synset origSynset = synset.clone()
        synset.addTerm(newTerm)
        LogInfo logInfo = getLogInfo(origSynset, synset, "added from synset suggestion")
        boolean result = synset.saveAndLog(logInfo)
        if (!result) {
            throw new Exception("Cannot create synset: ${synset.errors}")
        }
        render(template:"/synsetSuggestion/addedSynonym", 
                model:[id:synset.id, prefTerm: synset.synsetPreferredTerm,
                language: firstLanguage])
    }

    /**
     * Used to create a synset from the list of concept suggestions (via Ajax).
     */
    /*def createSynset = {
        if (!params.term) throw new Exception("parameter 'term' must be set")
        if (!params["language.id"]) throw new Exception("parameter 'language.id' must be set")
        if (!params["section.id"]) throw new Exception("parameter 'section.id' must be set")
        if (!params["category.id"]) throw new Exception("parameter 'category.id' must be set")
        if (params["category.id"] == "null") {    // no category selected by user
            response.status = 500
            render "<strong>Error: Please select a category</strong>"
            return
        }
        def synset = new Synset()
        // save section and category:
        Section section = Section.get(params["section.id"].toInteger())
        assert(section)
        synset.section = section
        Category category = Category.get(params["category.id"].toInteger())
        assert(category)
        synset.addCategoryLink(new CategoryLink(synset, category))
        // save term as preferred term:
        Language language = Language.get(params["language.id"])
        Term term = new Term(params.term, language, synset)
        TermValidator validator = new TermValidator(term)
        try {
            validator.extendedValidate()
        } catch (IllegalArgumentException e) {
            response.status = 500
            render "<strong>Error: term cannot be validated: ${e.encodeAsHTML()}</strong>"
            return
        }
        if (!term.validate()) {
            // validate happens on save() but the user shouldn't see a real exception:
            response.status = 500
            render "<strong>Error: term cannot be validated: ${term.errors}</strong>"
            return
        }
        if (!term.save()) {
            throw new Exception("Cannot create term: ${term.errors}")
        }
        synset.addTerm(term)
        // save synset and log information:
        LogInfo logInfo = getLogInfo(null, synset, "created from synset suggestion")
        boolean result = synset.saveAndLog(logInfo)
        if (!result) {
            throw new Exception("Cannot create synset: ${synset.errors}")
        }
        render(template:"/synsetSuggestion/createdSynset", model:[id:synset.id,
            term: params.term])
    }*/
    
    def save = {
        def synset = new Synset(params)
        synset.isVisible = true
        String searchTerms = ""
        List termsToCreate = []
        int numTerms = Integer.parseInt(params.numTerms)
        // iterate over all terms to be added to the new synset:
        Map preferredTerms = [:]        // maps language -> preferred term
        for (i in 0..numTerms-1) {
            String word = params["word_"+i]
            Language language = Language.get(params["language.id_"+i])
            Term term = new Term(word, language, synset)
            term.isShortForm = params["wordForm_"+i] == "abbreviation" ? true : false
            term.isAcronym = params["wordForm_"+i] == "acronym" ? true : false
            if (params["level.id_"+i] && params["level.id_"+i] != 'null') {
                term.level = Level.get(params["level.id_"+i])
            }
            if (params["wordGrammar.id_"+i] && params["wordGrammar.id_"+i] != 'null') {
                term.wordGrammar = WordGrammar.get(params["wordGrammar.id_"+i])
            }
            if (preferredTerms.get(language) == null) {
                // make first term per language the preferred term
                preferredTerms.put(language, term)
            }
            termsToCreate.add(term)
            searchTerms += term
            searchTerms += "\n"
        }
        // validate the terms before storing the synset
        for (term in termsToCreate) {
            TermValidator validator = new TermValidator(term)
            boolean validated = term.validate()
            if (!validated) {
              String[] wordError = [term.word, term.errors.toString()].toArray()
              synset.errors.rejectValue(null, 'thesaurus.invalid.term', wordError, "")
              render(view:'multiSearch', model:[synset:synset,
                   searchTerms:getTermsFromTextArea(searchTerms)],
                   contentType:"text/html", encoding:"UTF-8")
              return
            }
            try {
                validator.extendedValidate()
            } catch(IllegalArgumentException e) {
                String[] wordError = [term.word, e.toString()].toArray()
                synset.errors.rejectValue(null, 'thesaurus.invalid.term', wordError, "")
                render(view:'multiSearch', model:[synset:synset,
                     searchTerms:getTermsFromTextArea(searchTerms)],
                     contentType:"text/html", encoding:"UTF-8")
                return
            }
        }
        // check that the category is set:
        /*if (params.category.id == null || params.category.id == "null") {
            synset.errors.rejectValue('categoryLinks', 'thesaurus.invalid.category')
            render(view:'multiSearch', model:[synset:synset,
                    searchTerms:getTermsFromTextArea(searchTerms)],
                    contentType:"text/html", encoding:"UTF-8")
            return
        }
        addCategory(synset, params.category.id)
        synset.preferredCategory = Category.get(params.category.id)
        */
        LogInfo logInfo = getLogInfo(null, synset, params.changeComment)
        if (!synset.hasErrors() && synset.saveAndLog(logInfo, false)) {
            for (term in termsToCreate) {
                synset.addToTerms(term)
                logInfo = new LogInfo(session, IpTools.getRealIpAddress(request),
                        null, synset, params.changeComment)
                if (!term.validate()) {
                    synset.errors = term.errors
                    render(view:'multiSearch', model:[synset:synset,
                         searchTerms:getTermsFromTextArea(searchTerms)],
                         contentType:"text/html", encoding:"UTF-8")
                    return
                }
                def saved = term.saveAndLog(logInfo, false)
                if (!saved) {
                    synset.errors = term.errors
                     render(view:'multiSearch', model:[synset:synset,
                         searchTerms:getTermsFromTextArea(searchTerms)],
                         contentType:"text/html", encoding:"UTF-8")
                    return
                }
            }
            // we need to set the preferred terms here because the
            // terms have to be saved first to get their id:
            if (grailsApplication.config.thesaurus.prefTerm == 'true') {
              for (lang in preferredTerms.keySet()) {
                synset.setPreferredTerm(lang, preferredTerms.get(lang))
              }
            }
            flash.message = message(code:'create.created')
            redirect(action:edit,id:synset.id)
        }
        else {
            render(view:'multiSearch',model:[synset:synset,
                   searchTerms:getTermsFromTextArea(searchTerms)],
                   contentType:"text/html", encoding:"UTF-8")
        }
    }

    /**
     * Get all the languages which are used by the given synset's terms.
     */
    Set getLanguages(Synset synset) {
        Set languages = new HashSet()
        for (term in synset.terms) {
            languages.add(term.language)
        }
        return languages
    }

    /**
     * Add the category to given synset with the given id, re-render
     * page in case of errors.
     */
    void addCategory(Synset synset, String categoryID) {
        Category category = Category.get(categoryID)
        def catLink = new CategoryLink(synset, category)
        if (synset.containsCategoryLink(catLink)) {
            synset.errors.reject('thesaurus.duplicate.link',
                [].toArray(), 'already in concept')
            render(view:'edit',model:[synset:synset],
                    contentType:"text/html", encoding:"UTF-8")
            return
        }
        synset.addCategoryLink(catLink)
    }

    /**
     * Add the synset link, re-render page in case of errors.
     */
    void addSynsetLink(Synset fromSynset, Synset toSynset, LinkType linkType) {
        def synsetLink = new SynsetLink(fromSynset, toSynset, linkType)
        synsetLink.evaluationStatus = SynsetLink.EVAL_APPROVED
        if (fromSynset.containsSynsetLink(synsetLink)) {
            fromSynset.errors.reject('thesaurus.duplicate.link',
                [].toArray(), 'already in concept')
            render(view:'edit',model:[synset:fromSynset],
                    contentType:"text/html", encoding:"UTF-8")
            return
        }
        fromSynset.addSynsetLink(synsetLink)
        def saved = synsetLink.saveAndLog()
        if(!synsetLink.validate() || !saved) {
            fromSynset.errors = synsetLink.errors
            render(view:'edit',model:[synset:fromSynset],
                    contentType:"text/html", encoding:"UTF-8")
            return
        }
        String logText =
            "adding link: ${synsetLink.targetSynset.toShortString()} " +
            "${synsetLink.linkType.verbName} " +
            "${synsetLink.synset.toShortString()}"
        logSynsetLink(logText, fromSynset, synsetLink)
    }

    /**
     * Create a LogInfo object with the current session and IP address.
     */
    LogInfo getLogInfo(Object oldObj, Object newObj, String changeDesc) {
        return new LogInfo(session, IpTools.getRealIpAddress(request), oldObj,
                newObj, changeDesc)
    }
}

/**
 * Container for a partial search result plus the number of total matches.
 */
class SearchResult {
    int totalMatches
    List synsetList
    boolean completeResult // 'false' if there are more results than given back
    SearchResult(int totalMatches, List synsetList, boolean completeResult) {
        this.totalMatches = totalMatches
        this.synsetList = synsetList
        this.completeResult = completeResult
    }
}

/** Match of a substring search. */
class PartialMatch {
  String term
  String highlightTerm
}

/** Compare so that synsets whose relevant term has no language level set is preferred. */
class WordLevelComparator implements Comparator {

    String query
    
    WordLevelComparator(String query) {
        this.query = query
    }

    @Override
    int compare(Object o1, Object o2) {
        Synset syn1 = (Synset) o1
        Synset syn2 = (Synset) o2
        int syn1prio = hasLevelForQuery(syn1.terms) ? 1 : 0
        int syn2prio = hasLevelForQuery(syn2.terms) ? 1 : 0
        return syn1prio - syn2prio
    }
    
    boolean hasLevelForQuery(def terms) {
        for (Term term : terms) {
            if (term.word.equalsIgnoreCase(query) && term.level) {
                return true
            }
        }
        return false
    }

}
