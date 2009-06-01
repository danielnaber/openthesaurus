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

class SynsetController extends BaseController {

    // The maximum for the search query. Avoids out of memory
    final int UPPER_BOUND = 1000

    // maximum distance for a term to be accepcted as similar term:
    final int MAX_DIST = 3

    def beforeInterceptor = [action: this.&auth,
                             except: ['index', 'list', 'search', 'edit', 'statistics',
                                      'createMemoryDatabase', 'variation']]

    private static final UNKNOWN_CATEGORY_NAME = 'Unknown'

    // the delete, save and update actions only accept POST requests
    def allowedMethods = [delete:'POST', save:'POST', update:'POST']

    def dataSource       // will be injected

    def index = {
        if (params.id) {
          // this is an ID from the PHP version of OpenThesaurus, we keep it working:
          Synset synset = Synset.findByOriginalId(params.id)
          if (synset == null) {
            flash.message = message(code:'notfound.id.not.found', args:[params.id.encodeAsHTML()])
            response.sendError(404)
            return
          }
          String url = g.createLink(controller:'synset', action:'edit', id: synset.id)
          response.setHeader("Location", url)
          // search engines expect 301 if a move is permanent:
          response.sendError(301)
          return
        }
        redirect(action:list,params:params)
    }

    /**
     * Show page with statistics about the database, e.g. number of synsets.
     */
    def statistics = {
        Map termCountMap = new HashMap()
        Map latestChangesMap = new HashMap()
        List sections = Section.list()
        for (section in sections) {
            def criteria = Term.createCriteria()
            int termCount = criteria.count {
                synset {
                    eq('isVisible', true)
                    eq('section', section)
                }
            }
            termCountMap.put(section, termCount)
            criteria = UserEvent.createCriteria()
            int latestChanges = criteria.count {
                gt('creationDate', new Date() - 7)
                synset {
                    eq('section', section)
                }
            }
            latestChangesMap.put(section, latestChanges)
        }
        [ termCount : termCountMap,
          latestChanges : latestChangesMap ]
    }

    def list = {
        if(!params.max) params.max = 10
        [ synsetList: Synset.findAllByIsVisible(true,
            [sort:params.sort, order:params.order,
             offset:params.offset, max:10]) ]
    }

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
            flash.message = "No matches"
        } else {
            flash.message = ""
        }
        [ synsetList : allMatches, searchTerms: searchTerms ]
    }

    /**
     * Search for term and return a page with all synsets that contain
     * the term.
     */
    def search = {
        long startTime = System.currentTimeMillis()
        
        long partialMatchStartTime = System.currentTimeMillis()
        List partialMatchResult = searchPartialResult(params.q)
        long partialMatchTime = System.currentTimeMillis() - partialMatchStartTime
        
        long wikipediaStartTime = System.currentTimeMillis()
        List wikipediaResult = searchWikipedia(params.q)
        long wikipediaTime = System.currentTimeMillis() - wikipediaStartTime

        long wiktionaryStartTime = System.currentTimeMillis()
        List wiktionaryResult = searchWiktionary(params.q)
        long wiktionaryTime = System.currentTimeMillis() - wiktionaryStartTime
        
        long similarStartTime = System.currentTimeMillis()
        // TODO: use config option
        List similarTerms = searchSimilarTerms(params.q, 5)
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
        def searchResult = doSearch(params.q.trim(), section, source, category,
                maxResults, offset)
        if (searchResult.totalMatches == 0) {
          /*String msg = "No matches for '${params.q.encodeAsHTML()}'"
              msg += source ?
                      " in source '${source.encodeAsHTML()}'" : ""
              msg += category ?
                      " in category '${category.encodeAsHTML()}'" : ""
          flash.message = msg*/
          flash.message = ""
        } else {
          flash.message = ""
        }
        long totalTime = System.currentTimeMillis() - startTime
        log.info("Search time total: ${totalTime}ms, sim: ${similarTime}ms, substr: ${partialMatchTime}ms, wikipedia: ${wikipediaTime}ms")
        [ partialMatchResult : partialMatchResult,
          wikipediaResult : wikipediaResult,
          wiktionaryResult : wiktionaryResult,
          similarTerms : similarTerms,
          synsetList : searchResult.synsetList,
          totalMatches: searchResult.totalMatches,
          completeResult: searchResult.completeResult,
          upperBound: UPPER_BOUND,
          runTime : totalTime ]
    }

    /** Substring matches*/
    private List searchPartialResult(String term) {
      //TODO: connect only once?!
      Connection conn = DriverManager.getConnection(dataSource.url, dataSource.username, dataSource.password)
      String sql = "SELECT word FROM memwords WHERE word LIKE ? LIMIT 0, 10"
      PreparedStatement ps = conn.prepareStatement(sql)
      ps.setString(1, "%" + term + "%")
      ResultSet resultSet = ps.executeQuery()
      def matches = []
      Pattern pattern = Pattern.compile(Pattern.quote(term), Pattern.CASE_INSENSITIVE)
      while (resultSet.next()) {
        String matchedTerm = resultSet.getString("word")
        if (matchedTerm == term) {
          continue
        }
        String result = matchedTerm.encodeAsHTML()
        Matcher m = pattern.matcher(result)
        result = m.replaceAll("<span class='match'>\$0</span>")
        matches.add(new PartialMatch(term:matchedTerm, highlightTerm:result))
      }
      resultSet.close()
      ps.close()
      conn.close()
      return matches
   }

    /**
     * Create the in-memory database of all terms for fast substring search
     */
    // TODO: use quartz
    def createMemoryDatabase= {
      log.info("Creating in-memory database, request by " + request.getRemoteAddr())
      Connection conn = DriverManager.getConnection(dataSource.url, dataSource.username, dataSource.password)
      executeQuery("DROP TABLE IF EXISTS memwordsTmp", conn)
      executeQuery("CREATE TABLE IF NOT EXISTS memwordsTmp (word VARCHAR(50) NOT NULL, lookup VARCHAR(50)) ENGINE = MEMORY", conn)
      executeQuery("CREATE TABLE IF NOT EXISTS memwords (word VARCHAR(50) NOT NULL, lookup VARCHAR(50)) ENGINE = MEMORY", conn)
      
      PreparedStatement ps = 
        conn.prepareStatement("INSERT INTO memwordsTmp (word, lookup) VALUES ('__last_modified__', ?)")
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

      ps.close()
      conn.close()
      log.info("Finished creating in-memory database")
      render "OK"
    }
      
    private void executeQuery(String sql, Connection conn) {
      PreparedStatement ps = conn.prepareStatement(sql)
      ps.execute()
    }    

    def searchWikipedia(String term) {
      Connection conn = DriverManager.getConnection(dataSource.url, dataSource.username, dataSource.password)
      String sql = """SELECT link, title FROM wikipedia_links, wikipedia_pages
		WHERE wikipedia_pages.title = ? AND wikipedia_pages.page_id = wikipedia_links.page_id"""
      PreparedStatement ps = conn.prepareStatement(sql)
      ps.setString(1, term)
      ResultSet resultSet = ps.executeQuery()
      def matches = []
      while (resultSet.next()) {
        matches.add(resultSet.getString("link"))
      }
      resultSet.close()
      ps.close()
      conn.close()
      return matches
    }

    def searchWiktionary(String term) {
      Connection conn = DriverManager.getConnection(dataSource.url, dataSource.username, dataSource.password)
      String sql = """SELECT headword, meanings, synonyms FROM wiktionary WHERE headword = ?"""
      PreparedStatement ps = conn.prepareStatement(sql)
      ps.setString(1, term)
      ResultSet resultSet = ps.executeQuery()
      def matches = []
      while (resultSet.next()) {
        matches.add(resultSet.getString("meanings"))
        matches.add(resultSet.getString("synonyms"))
        break; // we expect only one match
      }
      resultSet.close()
      ps.close()
      conn.close()
      return matches
    }
    
    def searchSimilarTerms(String term, int maxHits) {
      Connection conn = DriverManager.getConnection(dataSource.url, dataSource.username, dataSource.password)
      String sql = """SELECT word, lookup FROM memwords 
			WHERE ((
				CHAR_LENGTH(word) >= ? AND CHAR_LENGTH(word) <= ?)
				OR
				(
				CHAR_LENGTH(lookup) >= ? AND CHAR_LENGTH(lookup) <= ?))
				ORDER BY word"""
      PreparedStatement ps = conn.prepareStatement(sql)
      int wordLength = term.length()
      ps.setInt(1, wordLength-1)
      ps.setInt(2, wordLength+1)
      ps.setInt(3, wordLength-1)
      ps.setInt(4, wordLength+1)
      ResultSet resultSet = ps.executeQuery()
      def matches = []
      // TODO: add some typical cases to be found without levenshtein (s <-> ß, ...)
      while (resultSet.next()) {
        String dbTerm = resultSet.getString("word").toLowerCase()
        if (dbTerm.equalsIgnoreCase(term)) {
          continue
        }
        int dist = StringUtils.getLevenshteinDistance(dbTerm, term.toLowerCase())
        if (dist <= MAX_DIST) {
          matches.add(resultSet.getString("word"))
        } else {
          dbTerm = resultSet.getString("lookup")
          if (dbTerm) {
            dbTerm = dbTerm.toLowerCase()
            dist = StringUtils.getLevenshteinDistance(dbTerm, term.toLowerCase())
            if (dist <= MAX_DIST) {
              matches.add(resultSet.getString("word"))
            }
          }
        }
        if (matches.size() >= maxHits) {
          break
        }
      }
      resultSet.close()
      ps.close()
      conn.close()
      return matches
    }
    
    def variation = {
      String limit = ""
      if (params.id == 'ch') {
        limit = "schweiz."
      } else if (params.id == 'at') {
        limit = "österr."
      } else {
        throw new Exception("Unknown variation")
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
        return doDBSearch(query, section, source, category, max, offset)
    }

    /**
     * Hibernate-based search implementation. Note that the number
     * of total matches is not always accurate.
     */
    def doDBSearch(String query, Section section, Source source,
            Category category, int max = -1, int offset = 0) {
        log.info("DB search for ${query} (section:${section}, source:${source}, " +
                "category:${category})")
        String sortField = params.sort ? params.sort : "synsetPreferredTerm"
        String sortOrder = params.order ? params.order : "asc"

        boolean completeResult = false

        // TODO: why don't we use Synset.withCriteria here, it would
        // free us from the need to remove duplicates manually
        // => there's a bug(?) so that the synsets are incomplete,
        // i.e. the terms are missing unless they match "ilike('word', query)",
        // see http://jira.codehaus.org/browse/GRAILS-2793
        // TODO: use HQL or SQL so we can make use of Oracle's lowercase index
        def termList = Term.withCriteria {
            or {
              ilike('word', query)
              ilike('normalizedWord', Term.normalize(query))
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
            def eventList = UserEvent.findAllBySynset(synset,
                    [order:'desc', sort:'creationDate', max: 10])
            def diffs = [:]
            def typeNames = [:]
            UserEventTools tools = new UserEventTools()
            tools.buildMetaInformation(eventList, diffs, typeNames)
            boolean showOrigSource =
                grailsApplication.config.thesaurus.showOriginalSource == "true"
            long runTime = System.currentTimeMillis() - startTime
            return [ synset : synset, eventList : eventList,
                     diffs: diffs, typeNames : typeNames, showOrigSource : showOrigSource,
                     runTime : runTime ]
        }
    }

    def update = {
        def synset = Synset.get(params.id)
        def origSynset = synset.clone()

        if (synset) {
            synset.properties = params
            // add links to other synsets:
            if (params.targetSynset?.id) {
                Synset targetSynset = Synset.get(params.targetSynset.id)
                LinkType linkType = LinkType.get(params.linkType.id)
                if (synset.id == targetSynset.id) { // not to itself
                    synset.errors.reject('thesaurus.error.synset.selfreference',
                            [].toArray(), 'Error saving changes')
                    render(view:'edit',model:[synset:synset],
                            contentType:"text/html", encoding:"UTF-8")
                    return
                } else {
                    addSynsetLink(synset, targetSynset, linkType)
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
                        "rejecting: ${synsetLink.synset.synsetPreferredTerm} " +
                        "${synsetLink.linkType.verbName} " +
                        "${synsetLink.targetSynset.synsetPreferredTerm}"
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
                        "approving: ${synsetLink.synset.synsetPreferredTerm} " +
                        "${synsetLink.linkType.verbName} " +
                        "${synsetLink.targetSynset.synsetPreferredTerm}"
                    logSynsetLink(logText, synset, synsetLink)
                }
            }
            // set all other links to neither approved nor rejected, i.e. delete them:
            List neutralIDs = getEvaluationRadioButtonIDs(log, "evaluate_link_", "neutral")
            for (neutralID in neutralIDs) {
                SynsetLink synsetLink = SynsetLink.get(neutralID)
                String logText =
                    "neutralizing: ${synsetLink.synset.synsetPreferredTerm} " +
                    "${synsetLink.linkType.verbName} " +
                    "${synsetLink.targetSynset.synsetPreferredTerm}"
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
                if (synset.categoryLinks.size()-deleteIDs.size() <= 0) {
                    synset.errors.reject('thesaurus.empty.category',
                            [].toArray(), 'concept must contain a category')
                    render(view:'edit',model:[synset:synset],
                            contentType:"text/html", encoding:"UTF-8")
                    return
                }
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
                if (synset.preferredCategory.categoryName == UNKNOWN_CATEGORY_NAME) {
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
                    newTerm.level = Level.get(params['level.id_'+newTermCount])
                }
                if (params['wordGrammar.id_'+newTermCount] && params['wordGrammar.id_'+newTermCount] != "null") {
                    newTerm.wordGrammar = WordGrammar.get(params['wordGrammar.id_'+newTermCount])
                }
                LogInfo logInfo = new LogInfo(session, request.getRemoteAddr(),
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
                if (!synset.hasPreferredTerm(newTerm.language)) {
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

            LogInfo logInfo = new LogInfo(session, request.getRemoteAddr(),
                    origSynset, synset, params.changeComment)
            if(!synset.hasErrors() && synset.saveAndLog(logInfo)) {
                flash.message = "Concept updated"
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
            "$actionName: ${synsetLink.synset.synsetPreferredTerm} " +
            "${synsetLink.linkType.verbName} " +
            "${synsetLink.targetSynset.synsetPreferredTerm}"
        logSynsetLink(logText, synset, synsetLink)
    }

    private void logSynsetLink(String logText, Synset synset, SynsetLink synsetLink) {
        LogInfo linkLogInfo = new LogInfo(session, request.getRemoteAddr(), synsetLink,
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
    def createSynset = {
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
    }
    
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
        if (params.category.id == null || params.category.id == "null") {
            synset.errors.rejectValue('categoryLinks', 'thesaurus.invalid.category')
            render(view:'multiSearch', model:[synset:synset,
                    searchTerms:getTermsFromTextArea(searchTerms)],
                    contentType:"text/html", encoding:"UTF-8")
            return
        }
        addCategory(synset, params.category.id)
        synset.preferredCategory = Category.get(params.category.id)
        LogInfo logInfo = getLogInfo(null, synset, params.changeComment)
        if (!synset.hasErrors() && synset.saveAndLog(logInfo, false)) {
            for (term in termsToCreate) {
                synset.addToTerms(term)
                logInfo = new LogInfo(session, request.getRemoteAddr(),
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
            for (lang in preferredTerms.keySet()) {
                synset.setPreferredTerm(lang, preferredTerms.get(lang))
            }
            flash.message = "Concept created"
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
            "adding link: ${synsetLink.synset.synsetPreferredTerm} " +
            "${synsetLink.linkType.verbName} " +
            "${synsetLink.targetSynset.synsetPreferredTerm}"
        logSynsetLink(logText, fromSynset, synsetLink)
    }

    /**
     * Create a LogInfo object with the current session and IP address.
     */
    LogInfo getLogInfo(Object oldObj, Object newObj, String changeDesc) {
        return new LogInfo(session, request.getRemoteAddr(), oldObj,
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
