/**
 * OpenThesaurus - web-based thesaurus management tool
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

package openthesaurus


import com.vionto.vithesaurus.*
import groovy.sql.Sql

import java.sql.Connection

import org.apache.commons.lang.StringUtils
import com.vionto.vithesaurus.tools.IpTools
import com.vionto.vithesaurus.tools.StringTools
import org.apache.commons.lang.StringEscapeUtils
import com.vionto.vithesaurus.tools.DbUtils

class SynsetController extends BaseController {

    def requestLimiterService
    def searchService
    def memoryDatabaseCreationService
    def wordListService
    def baseformService

    // the delete, save and update actions only accept POST requests
    static def allowedMethods = [delete:'POST', save:'POST', update:'POST', addSynonym:'POST']
    
    def dataSource       // will be injected
    
    def index() {
        redirect(action:'list',params:params)
    }

    def statistics() {
        // this is an old URL, keep it supported
        redirect(controller:'statistics', action:'index')
    }
    
    /**
     * Search all terms from a textarea (one query per line) return a page
     * with merged results.
     */
    def multiSearch() {
        def allMatches = []
        String[] searchTerms = getTermsFromTextArea(params.terms)
        for (term in searchTerms) {
              def searchResult = searchService.searchSynsets(term)
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
    def oldSearch() {
      if (params.format == 'text/xml' || params.format == 'application/json') {
        // we don't redirect API requests to avoid the redirect overhead for mobile devices
        search()
      } else {
        String q = URLEncoder.encode(params.q, "UTF-8")
        RedirectController redirectController = new RedirectController()
        redirectController.permanentRedirect("synonyme/" + q, response)
      }
    }

    /**
     * Return a simplified search result snippet to be embedded
     * via Ajax.
     */
    def ajaxSearch() {
        search()
    }

    def newSearch() {
        params.newSearch = true
        search()
    }
    
    /**
     * Search for term and return a page with all synsets that contain
     * the term.
     */
    def search() {
        long startTime = System.currentTimeMillis()

        if (!params.q) {
          log.warn("No query specified for search (${IpTools.getRealIpAddress(request)})")
          response.status = 500
          render message(code:'result.no.query.specified')
          return
        }
        
        try {
          params.q = URLDecoder.decode(StringTools.slashUnescape(params.q), "UTF-8")
        } catch (IllegalArgumentException e) {
          params.q = params.q.replaceAll("%", "%25") // replace all % with %25 to avoid IllegalArgumentException
          try {
            params.q = URLDecoder.decode(StringTools.slashUnescape(params.q), "UTF-8")
          } catch (IllegalArgumentException e2) {
            log.error("Error decoding query: " + params.q + " from user agent " + request.getHeader("User-Agent"), e2)
            response.status = 500
            render message(code:e2.toString())
            return
          }
        }
        Connection conn = null
        try {
          conn = dataSource.getConnection()
          boolean apiRequest = params.format == "text/xml" || params.format == "application/json"
          boolean spellApiRequest = params.similar == "true"
          boolean allApiRequest = params.mode == "all"
          boolean partialApiRequest = params.substring == "true"
          boolean startsWithApiRequest = params.startswith == "true"
          boolean baseformApiRequest = params.baseform == "true"

          List partialMatchResult = []
          List startsWithResult = []
          long partialMatchStartTime = System.currentTimeMillis()
          String sleepTimeInfo = ""
          if (apiRequest) {
            response.setHeader("Access-Control-Allow-Origin", "*")
            try {
              sleepTimeInfo = requestLimiterService.preventRequestFlooding(request)
            } catch (TooManyRequestsException e) {
              log.info("Too many API requests from ${e.getIpAddress()}, blocking request " + params + ", user agent: " + request.getHeader("User-Agent"))
              render(status: 429/*too many requests*/, text: "Too many requests from your IP address (${e.getIpAddress()}) - please stop flooding our service. Use http://www.openthesaurus.de/about/download instead.")
              return
            }
            if (partialApiRequest || allApiRequest) {
              int partialSearchOffset = params.substringFromResults ? Integer.parseInt(params.substringFromResults) : 0
              partialMatchResult = searchService.searchPartialResult(params.q, partialSearchOffset, getPartialSearchMax())
            }
            if (startsWithApiRequest || allApiRequest) {
              int startsWithSearchOffset = params.startsWithFromResults ? Integer.parseInt(params.startsWithFromResults) : 0
              startsWithResult = searchService.searchStartsWithResult(params.q, startsWithSearchOffset, getStartsWithSearchMax())
            }
          } else {
            // we display 10 matches in the page and use the next one (if any) to
            // decide whether there are more matches:
            partialMatchResult = searchService.searchPartialResult(params.q, 0, 11)
          }
          long partialMatchTime = System.currentTimeMillis() - partialMatchStartTime
          
          List wikipediaResult = []
          long wikipediaStartTime = System.currentTimeMillis()
          if (!apiRequest) {
            if (grailsApplication.config.thesaurus.wikipediaLinks == "true") {
              wikipediaResult = searchService.searchWikipedia(params.q, conn)
            }
          }
          long wikipediaTime = System.currentTimeMillis() - wikipediaStartTime

          List wiktionaryResult = []
          long wiktionaryStartTime = System.currentTimeMillis()
          if (!apiRequest) {
            if (grailsApplication.config.thesaurus.wiktionaryLinks == "true") {
              wiktionaryResult = searchService.searchWiktionary(params.q, conn)
            }
          }
          long wiktionaryTime = System.currentTimeMillis() - wiktionaryStartTime
          
          List similarTerms
          long similarStartTime = System.currentTimeMillis()
          if (apiRequest) {
            if (spellApiRequest || allApiRequest) {
              similarTerms = searchService.searchSimilarTerms(params.q, conn)
            } else {
              similarTerms = null
            }
          } else {
            similarTerms = searchService.searchSimilarTerms(params.q, conn)
          }
          long similarTime = System.currentTimeMillis() - similarStartTime

          int offset = params.offset ? Integer.parseInt(params.offset) : 0
          int maxResults = params.max ? Integer.parseInt(params.max) : -1
          long dbStartTime = System.currentTimeMillis()
          def searchResult = searchService.searchSynsets(params.q.trim(), maxResults, offset)
          long dbTime = System.currentTimeMillis() - dbStartTime
          long totalTime = System.currentTimeMillis() - startTime
          
          String qType = getQueryType()
          log.info("Search(ms):${qType} ${searchResult.totalMatches}matches ${totalTime}ms db:${dbTime}${sleepTimeInfo} sim:${similarTime}"
               + " substr:${partialMatchTime} wikt:${wiktionaryTime} wiki:${wikipediaTime}"
               + " q:${params.q}")

          def baseforms = []
          if (apiRequest) {
            if (baseformApiRequest || allApiRequest) {
              baseforms = baseformService.getBaseForms(conn, params.q.trim())
            }
            renderApiResult(searchResult, similarTerms, partialMatchResult, startsWithResult, baseforms)
            return
          }

          String metaTagDescriptionText = null
          if (searchResult.totalMatches > 0) {
            metaTagDescriptionText = getMetaTagDescription(searchResult)
          } else if (params.q.trim().length() < 70) {  // avoid de.danielnaber.jwordsplitter.InputTooLongException
            baseforms = baseformService.getBaseForms(conn, params.q.trim())
          }

          // this is specific to the German OpenThesaurus:
          WordListLookup remoteWordLookup = wordListService.remoteWordUrlAndMetaInfo(params.q)
          WordListLookup remoteGenderLookup = wordListService.remoteGenderUrlAndMetaInfo(params.q)
          WordListLookup remoteMistakeLookup = wordListService.remoteCommonMistakeUrlAndMetaInfo(params.q)
          // end of parts that's specific to the German OpenThesaurus

          if (params.newSearch) {
              render(view:"_searchinternal", model: [
                  partialMatchResult : partialMatchResult,
                  wikipediaResult : wikipediaResult,
                  wiktionaryResult : wiktionaryResult,
                  similarTerms : similarTerms,
                  synsetList : searchResult.synsetList,
                  totalMatches: searchResult.totalMatches,
                  completeResult: searchResult.completeResult,
                  baseforms: baseforms,
                  descriptionText : metaTagDescriptionText,
                  runTime : totalTime,
                  remoteWordLookup: remoteWordLookup,
                  remoteGenderLookup: remoteGenderLookup,
                  remoteMistakeLookup: remoteMistakeLookup,
                  withAd: params.withAd
                  ], contentType:"text/html", encoding:"UTF-8")
          }
          else {
              boolean noResult =
                      searchResult.totalMatches == 0 &&
                      wikipediaResult.size() == 0 &&
                      wiktionaryResult.size() == 0 &&
                      partialMatchResult.size() == 0
              render(view: "search", model: [ partialMatchResult : partialMatchResult,
                                            wikipediaResult : wikipediaResult,
                                            wiktionaryResult : wiktionaryResult,
                                            similarTerms : similarTerms,
                                            synsetList : searchResult.synsetList,
                                            totalMatches: searchResult.totalMatches,
                                            completeResult: searchResult.completeResult,
                                            baseforms: baseforms,
                                            descriptionText : metaTagDescriptionText,
                                            runTime : totalTime,
                                            remoteWordLookup: remoteWordLookup,
                                            remoteGenderLookup: remoteGenderLookup,
                                            remoteMistakeLookup: remoteMistakeLookup,
                                            withAd: true
                ], contentType:"text/html", encoding:"UTF-8", status: noResult ? 404 : 200)
              }

        } finally {
          DbUtils.closeQuietly(conn)
        }
    }

  private int getPartialSearchMax() {
    int partialApiMaxResultsRequest = 10
    if (params.substringMaxResults) {
      partialApiMaxResultsRequest = Math.min(Integer.parseInt(params.substringMaxResults), 250)
    }
    return partialApiMaxResultsRequest
  }

  private int getStartsWithSearchMax() {
    int startsWithApiMaxResultsRequest = 10
    if (params.startsWithMaxResults) {
      startsWithApiMaxResultsRequest = Math.min(Integer.parseInt(params.startsWithMaxResults), 250)
    }
    return startsWithApiMaxResultsRequest
  }

  private String getQueryType() {
      String qType
      if (params.format == "text/xml") {
          qType = "xml"
      } else if (params.format == "application/json") {
          qType = "jso"
      } else {
          qType = "htm"
      }
      return qType
  }

    private void renderApiResult(SearchResult searchResult, ArrayList similarTerms, List partialMatchResult, List startsWithResult, List baseformResult) {
        if (params.format == "application/json") {
            if (params.callback) {
                String validCallbackPattern = '^[a-zA-Z0-9_.-]+$'
                if (!params.callback.matches(validCallbackPattern)) {
                    throw new Exception("Invalid callback parameter: only characters [a-zA-Z0-9_.-] are allowed")
                }
                // JSONP: Get the actual JSON content via HTTP and add the callback - all other ways to make
                // this work failed or were equally ugly:
                def paramsList = []
                for (param in params.keySet()) {
                    if (param != "callback") {
                        paramsList.add(param + "=" + URLEncoder.encode(params[param], "utf-8"))
                    }
                }
                paramsList.add("internalHttpPassword=" + grailsApplication.config.thesaurus.internalHttpPassword)
                paramsList.add("sourceIp=" + IpTools.getRealIpAddress(request))
                def paramsString = StringUtils.join(paramsList, "&")
                def serverUrl = new URL(grailsApplication.config.thesaurus.serverURL)
                def server = serverUrl.protocol + "://" + serverUrl.host + ":" + serverUrl.port
                String url = server + "/synonyme/search?" + paramsString
                String urlContent = new URL(url).text
                render(text: "${params.callback}(${urlContent})", encoding: "utf-8")
            } else {
                renderApiResponseAsJson(searchResult, similarTerms, partialMatchResult, startsWithResult, baseformResult)
            }
        } else {
            renderApiResponseAsXml(searchResult, similarTerms, partialMatchResult, startsWithResult)
        }
    }

  private String getMetaTagDescription(SearchResult searchResult) {
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
    return synonymsForDescription.toString()
  }

  // NOTE: keep in sync with JSON!
  private void renderApiResponseAsXml(def searchResult, List similarTerms, List substringTerms, List startsWithTerms) {
      // see http://jira.codehaus.org/browse/GRAILSPLUGINS-709 for a required
      // workaround with feed plugin 1.4 and Grails 1.1
      render(contentType:"text/xml", encoding:"utf-8") {
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
              if (params.supersynsets == 'true' || params.mode == 'all') {
                supersynsets {
                  for (link in s.sortedSynsetLinks()) {
                    if (link.linkType.linkName == 'Oberbegriff') {
                      synset {
                        for (t in link.targetSynset.sortedTerms()) {
                          if (t.level) {
                            term(term:t, level:t.level.levelName)
                          } else {
                            term(term:t)
                          }
                        }
                      }
                    }
                  }
                }
              }
              if (params.subsynsets == 'true' || params.mode == 'all') {
                subsynsets {
                  for (link in s.sortedSynsetLinks()) {
                    if (link.linkType.linkName == 'Unterbegriff') {
                      synset {
                        for (t in link.targetSynset.sortedTerms()) {
                          if (t.level) {
                            term(term:t, level:t.level.levelName)
                          } else {
                            term(term:t)
                          }
                        }
                      }
                    }
                  }
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

    // NOTE: keep in sync with XML!
    private void renderApiResponseAsJson(def searchResult, List similarTerms, List substringTerms, List startsWithTerms, List baseformResult) {
        // see http://jira.codehaus.org/browse/GRAILSPLUGINS-709 for a required
        // workaround with feed plugin 1.4 and Grails 1.1

        render(contentType:"text/json", encoding:"utf-8") {

            metaData apiVersion: "0.2",
                warning: "ACHTUNG: Bitte vor ernsthafter Nutzung feedback@openthesaurus.de kontaktieren, um bei API-Änderungen informiert zu werden",
                copyright: grailsApplication.config.thesaurus.apiCopyright,
                license: grailsApplication.config.thesaurus.apiLicense,
                source: grailsApplication.config.thesaurus.apiSource,
                date: new Date().toString()

            List synsetList = []

            for (s in searchResult.synsetList) {
                List categoryNames = []
                if (s.categoryLinks != null) {
                    for (catLink in s.categoryLinks) {
                        categoryNames.add(catLink.category.categoryName)
                    }
                }
                List terms = []
                for (t in s.sortedTerms()) {
                    if (t.level) {
                        terms.add([term: t.word, level: t.level.levelName])
                    } else {
                        terms.add([term: t.word])
                    }
                }
                Map res = [
                           'id': s.id,
                           'categories': categoryNames,
                           'terms': terms
                          ]
                if (params.supersynsets == 'true' || params.mode == 'all') {
                    List superSynsets = []
                    for (link in s.sortedSynsetLinks()) {
                        if (link.linkType.linkName == 'Oberbegriff') {
                            List superTerms = []
                            for (t in link.targetSynset.sortedTerms()) {
                                if (t.level) {
                                    superTerms.add([term:t.word, level:t.level.levelName])
                                } else {
                                    superTerms.add([term:t.word])
                                }
                            }
                            superSynsets.add(superTerms)
                        }
                    }
                    res.put('supersynsets', superSynsets)
                }
                if (params.subsynsets == 'true' || params.mode == 'all') {
                    List subSynsets = []
                    for (link in s.sortedSynsetLinks()) {
                        if (link.linkType.linkName == 'Unterbegriff') {
                            List subTerms = []
                            for (t in link.targetSynset.sortedTerms()) {
                                if (t.level) {
                                    subTerms.add([term:t.word, level:t.level.levelName])
                                } else {
                                    subTerms.add([term:t.word])
                                }
                            }
                            subSynsets.add(subTerms)
                        }
                    }
                    res.put('subsynsets', subSynsets)
                }

                synsetList << res
            }

            synsets synsetList

            if (similarTerms) {
                List simTermList = []
                int i = 0
                for (simTerm in similarTerms) {
                    simTermList << [term:simTerm.term, distance:simTerm.dist]
                    if (++i >= 5) {
                        break
                    }
                }
                similarterms simTermList
            }

            if (substringTerms && substringTerms.size() > 0) {
                List substringTermsList = []
                for (substringTerm in substringTerms) {
                    substringTermsList << [term:substringTerm.term]
                }
                substringterms substringTermsList
            }

            if (startsWithTerms && startsWithTerms.size() > 0) {
                List startsWithTermsList = []
                for (startsWithTerm in startsWithTerms) {
                    startsWithTermsList << [term:startsWithTerm.term]
                }
                startswithterms startsWithTermsList
            }

            if (baseformResult && baseformResult.size() > 0) {
                baseforms baseformResult
            }

        }
    }
        
    def substring() {
      if (!params.offset) params.offset = "0"
      if (!params.max) params.max = "20"
      int offset = Integer.parseInt(params.offset)
      int maxMatches = Integer.parseInt(params.max)
      List partialMatchResult = searchService.searchPartialResult(params.q, offset, maxMatches)
      int totalMatches = searchService.getPartialResultTotalMatches(params.q)
      [matches: partialMatchResult, totalMatches: totalMatches]
    }

    /**
     * Create the in-memory database of all terms for fast substring search
     */
    def createMemoryDatabase() {
      if (!IpTools.isLocalHost(request)) {
        throw new Exception("Access denied from " + IpTools.getRealIpAddress(request))
      }
      log.info("Creating in-memory database, request by " + IpTools.getRealIpAddress(request))
      memoryDatabaseCreationService.createMemoryDatabase(grailsApplication.config.thesaurus.hiddenSynsets)
      log.info("Finished creating in-memory database")
      render "OK"
    }

    /**
     * Get lists from korrekturen.de - specific to openthesaurus.de.
     */
    def refreshRemoteWordLists() {
      if (!IpTools.isLocalHost(request)) {
        throw new Exception("Access denied from " + IpTools.getRealIpAddress(request))
      }
      wordListService.refreshWordList()
      wordListService.refreshGenderList()
      wordListService.refreshCommonMistakesList()
      render "OK"
    }

    /**
     * Split a string and return an array so that each non-empty
     * line is one array item.
     */
    String[] getTermsFromTextArea(String str) {
        String[] terms = str.split("[\n\r]")
        return terms.findAll { term -> term.trim() != "" }
    }

    def listBySize() {
        def direction = params.direction == 'asc' ? 'asc' : 'desc'
        int offset = params.offset ? params.offset.toInteger() : 0
        List synsets = []
        def sql = new Sql(dataSource)
        sql.eachRow("select synset.id, count(synset_id) from term, synset" +
                " where term.synset_id = synset.id and synset.is_visible = 1" +
                " group by synset_id order by count(synset_id) ${direction}" +
                " limit ${offset}, 10", 
            { row -> synsets.add(Synset.get(row[0])) })
        int totalMatches = Synset.countByIsVisible(true) 
        [synsets: synsets, totalMatches: totalMatches, direction: direction]
    }

    def variation() {
      String limit = ""
      if (params.id == 'ch') {
        limit = "schweizerisch"
      } else if (params.id == 'at') {
        limit = "österreichisch"
      } else {
        throw new Exception("Unknown variation '${params.id}'")
      }
      String headline = message(code:'variation.headline.' + params.id)
      String title = message(code:'variation.title.' + params.id)
      String intro = message(code:'variation.intro.' + params.id)
      def matchCount = Term.createCriteria().count {
          tags {
              eq('name', limit)
          }
          synset {
              eq('isVisible', true)
          }
      }
      def termList = Term.createCriteria().list {
          tags {
              eq('name', limit)
          }
          synset {
              eq('isVisible', true)
          }
          order('word', 'asc')
          firstResult(params.offset ? params.offset.toInteger() : 0)
          maxResults(params.max ? params.max.toInteger() : 20)
      }
      [headline: headline, title: title, intro: intro,
       termList: termList, matchCount: matchCount]
    }

    def edit() {
        long startTime = System.currentTimeMillis()
        if (!params.containsKey("id")) {
            response.sendError(404)
            return
        }
        def synset = Synset.get(params.id)
        if (!synset) {
            response.sendError(404)
        } else {
            if (!params.max) params.max = 10
            if (!params.sort) params.sort = "creationDate"
            if (!params.order) params.order = "desc"
            def eventListCount = UserEvent.countBySynset(synset)
            def eventList = UserEvent.findAllBySynset(synset,
                    [order:'desc', sort:'creationDate', offset: params.offset, max: params.max])
            if (grailsApplication.config.thesaurus.hiddenEventIds) {
                List hiddenEventIds = []
                hiddenEventIds = grailsApplication.config.thesaurus.hiddenEventIds.split(",\\s*")
                eventList = eventList.findAll({
                    !hiddenEventIds.contains(Long.toString(it.id))
                })
            }
            def diffs = [:]
            def typeNames = [:]
            UserEventTools tools = new UserEventTools()
            tools.buildMetaInformation(eventList, diffs, typeNames)
            boolean showOrigSource =
                grailsApplication.config.thesaurus.showOriginalSource == "true"
            long runTime = System.currentTimeMillis() - startTime
            return [ synset : synset, eventListCount : eventListCount, eventList : eventList,
                     diffs: diffs, typeNames : typeNames, showOrigSource : showOrigSource,
                     readOnlyMode: readOnlyMode(), runTime : runTime ]
        }
    }

    def hide() {
        hideSynset(true, message(code:'edit.delete.missing.comment'), message(code:'edit.delete.success'))
    }
    
    def unhide() {
        hideSynset(false, message(code:'edit.delete.missing.comment'), message(code:'edit.undelete.success'))
    }
    
    private hideSynset(boolean hide, String errorMsg, String successMsg) {
        def synset = Synset.get(params.id)
        def origSynset = synset.clone()
        
        if (!params.changeComment || params.changeComment.trim().equals("")) {
            synset.errors.reject('thesaurus.error', [].toArray(), errorMsg)
            render(view:'edit',model:[synset:synset, showOnlyDeleteButton:true], contentType:"text/html", encoding:"UTF-8")
            return
        }
        
        // "delete" the synset: 
        synset.isVisible = !hide
        
        LogInfo logInfo = new LogInfo(session, IpTools.getRealIpAddress(request),
            origSynset, synset, params.changeComment)
        if (!synset.hasErrors() && synset.saveAndLog(logInfo)) {
            flash.message = successMsg
            redirect(action:'edit',id:synset.id)
        } else {
            synset.errors.reject('thesaurus.error', [].toArray(), 'Could not save and/or log changes')
            render(view:'edit',model:[synset:synset], contentType:"text/html", encoding:"UTF-8")
        }
    }
    
    def update() {
        def synset = Synset.get(params.id)
        def origSynset = new Synset(synset)

        if (synset) {
            try {
                addSynsetLinks(synset)
                deleteTerms(synset)
                deleteCategoryLinks(synset)
                deleteSynsetLinks(synset)
                // add a category link:
                int newCategoryCount = 0
                while (newCategoryCount < Integer.parseInt(grailsApplication.config.thesaurus.maxNewCategories)) {
                    if (params['category.id_'+newCategoryCount] == "null") {
                        newCategoryCount++
                        continue
                    }
                    addCategory(synset, params['category.id_' + newCategoryCount])
                    newCategoryCount++
                }
                addNewTerms(synset)
            } catch (Exception e) {
                log.warn(synset.toString() + ": " + e.toString())
                synset.errors.reject(e.getMessage(), [].toArray(), e.getMessage())
                render(view:'edit',model:[synset:synset], contentType:"text/html", encoding:"UTF-8")
                return
            }

            LogInfo logInfo = new LogInfo(session, IpTools.getRealIpAddress(request), origSynset, synset, params.changeComment)
            if (!synset.hasErrors() && synset.saveAndLog(logInfo)) {
                flash.message = message(code:'edit.updated')
                redirect(action:'edit',id:synset.id)
            } else {
                synset.errors.reject('thesaurus.error', [].toArray(), 'Could not save and/or log changes')
                render(view:'edit',model:[synset:synset], contentType:"text/html", encoding:"UTF-8")
            }
        } else {
            flash.message = "Concept not found with id ${params.id}"
            redirect(action:'edit',id:params.id)
        }
    }

    private void addSynsetLinks(Synset synset) {
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
                    throw new Exception(message(code:'thesaurus.error.synset.selfreference'))
                } else {
                    addSynsetLink(synset, targetSynset, linkTypeToUse)
                }
            }
        }
    }

    private void deleteTerms(Synset synset) {
      List deleteTermIds = []
      for (term in synset.terms) {
          if (params['delete_' + term.id] == 'delete') {
              deleteTermIds.add(term.id)
          }
      }
      if (synset.terms.size() - deleteTermIds.size() <= 0) {
          throw new Exception(message(code:'thesaurus.empty.synset'))
      }
      for (deleteID in deleteTermIds) {
          Term delTerm = Term.get(deleteID)
          List<TermLink> termLinks1 = TermLink.findAllByTerm(delTerm)
          for (termLink in termLinks1) {
              delTerm.deleteTermLink(termLink)
          }
          List<TermLink> termLinks2 = TermLink.findAllByTargetTerm(delTerm)
          for (termLink in termLinks2) {
              termLink.targetTerm.deleteTermLink(termLink)
          }
          synset.removeTerm(delTerm)
      }
  }

    private void deleteCategoryLinks(Synset synset) {
        List catLinksToDelete = []
        for (catLink in synset.categoryLinks) {
            if (params['delete_catLinkId_' + catLink.id] == 'delete') {
                catLinksToDelete.add(catLink)
            }
        }
        for (catLink in catLinksToDelete) {
            synset.removeLink(catLink)
        }
    }

    private void deleteSynsetLinks(Synset synset) {
        List synsetLinkIdsToDelete = []
        for (synsetLink in synset.sortedSynsetLinks()) {
            String linkName = params['delete_' + synsetLink.linkType.linkName + '_' + synsetLink.id]
            if (linkName == 'delete') {
                synsetLinkIdsToDelete.add(synsetLink.id)
            }
        }
        for (synsetLinkId in synsetLinkIdsToDelete) {
            SynsetLink synsetLink = SynsetLink.get(synsetLinkId)
            String logText =
                "removing link: ${StringEscapeUtils.unescapeHtml(synsetLink.targetSynset.toShortString())} " +
                        "${synsetLink.linkType.verbName} " +
                        "${StringEscapeUtils.unescapeHtml(synsetLink.synset.toShortString())}"
            logSynsetLink(logText, synset, synsetLink)
            synset.removeFromSynsetLinks(synsetLink)
            synsetLink.delete()
        }
    }

    /**
     * Add the category to given synset with the given id, re-render
     * page in case of errors.
     */
    private void addCategory(Synset synset, String categoryID) {
        Category category = Category.get(categoryID)
        def catLink = new CategoryLink(synset, category)
        if (synset.containsCategoryLink(catLink)) {
            synset.errors.reject('thesaurus.duplicate.link', [].toArray(), 'already in concept')
            render(view:'edit',model:[synset:synset], contentType:"text/html", encoding:"UTF-8")
            return
        }
        synset.addCategoryLink(catLink)
    }

    private void addNewTerms(Synset synset) {
        int newTermCount = 0
        while (newTermCount < Integer.parseInt(grailsApplication.config.thesaurus.maxNewTerms)) {
            if (!params['word_' + newTermCount]) {
                newTermCount++
                continue
            }
            def language = Language.get(params['language.id_' + newTermCount])
            Term newTerm = new Term(params['word_' + newTermCount], language, synset)
            if (params['level.id_' + newTermCount] && params['level.id_' + newTermCount] != "null") {
                newTerm.level = TermLevel.get(params['level.id_' + newTermCount])
            }
            if (params['tags_' + newTermCount]) {
                String[] tags = params['tags_' + newTermCount].split(",\\s*")
                newTerm.addTags(session, tags)
            }
            LogInfo logInfo = new LogInfo(session, IpTools.getRealIpAddress(request), null, newTerm, params.changeComment)
            if (synset.containsWord(params['word_' + newTermCount])) {
                throw new Exception(message(code:'thesaurus.duplicate.term', args: [newTerm.word], encodeAs: 'Text'))
            }
            if (!newTerm.validate()) {
                throw new Exception(message(code:'thesaurus.invalid.term', args: [newTerm.word, newTerm.errors], encodeAs: 'Text'))
            }
            try {
                newTerm.extendedValidate()
            } catch (IllegalArgumentException e) {
                throw new Exception(message(code:'thesaurus.invalid.term', args: [newTerm.word, e.getMessage()], encodeAs: 'Text'))
            }
            synset.addTerm(newTerm)
            def saved = newTerm.saveAndLog(logInfo)
            if (!saved) {
                throw new Exception(message(code:'thesaurus.error.saving.changes', args: [newTerm.word, newTerm.errors], encodeAs: 'Text'))
            }
            newTermCount++
        }
    }

  private void logSynsetLink(String logText, Synset synset, SynsetLink synsetLink) {
        LogInfo linkLogInfo = new LogInfo(session, IpTools.getRealIpAddress(request), synsetLink, logText, params.changeComment)
        boolean saved = synset.saveAndLog(linkLogInfo)
        if (!saved) {
            throw new Exception("Could not save approve log: ${synset.errors}")
        }
    }

    def create() {
        def synset = new Synset()
        return ['synset':synset]
    }

    /**
     * Add the given word to the given synset (called via Ajax).
     */
    def addSynonym() {
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
                model:[id:synset.id, language: firstLanguage])
    }

    def save() {
        def synset = new Synset(params)
        synset.isVisible = true
        String searchTerms = ""
        List termsToCreate = []
        int numTerms = Integer.parseInt(params.numTerms)
        // iterate over all terms to be added to the new synset:
        for (i in 0..numTerms-1) {
            String word = params["word_"+i]
            Language language = Language.get(params["language.id_"+i])
            Term term = new Term(word, language, synset)
            if (params["level.id_"+i] && params["level.id_"+i] != 'null') {
                term.level = Level.get(params["level.id_"+i])
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
            } catch (IllegalArgumentException e) {
                String[] wordError = [term.word, e.toString()].toArray()
                synset.errors.rejectValue(null, 'thesaurus.invalid.term', wordError, "")
                render(view:'multiSearch', model:[synset:synset,
                     searchTerms:getTermsFromTextArea(searchTerms)],
                     contentType:"text/html", encoding:"UTF-8")
                return
            }
        }
        LogInfo logInfo = getLogInfo(null, synset, params.changeComment)
        if (!synset.hasErrors() && synset.saveAndLog(logInfo, false)) {
            for (term in termsToCreate) {
                synset.addToTerms(term)
                logInfo = new LogInfo(session, IpTools.getRealIpAddress(request), null, synset, params.changeComment)
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
            flash.message = message(code:'create.created')
            redirect(action:'edit',id:synset.id)
        }
        else {
            render(view:'multiSearch', model:[synset:synset,
                   searchTerms:getTermsFromTextArea(searchTerms)],
                   contentType:"text/html", encoding:"UTF-8")
        }
    }

    /**
     * Add the synset link, re-render page in case of errors.
     */
    void addSynsetLink(Synset fromSynset, Synset toSynset, LinkType linkType) {
        def synsetLink = new SynsetLink(fromSynset, toSynset, linkType)
        if (fromSynset.containsSynsetLink(synsetLink)) {
            fromSynset.errors.reject('thesaurus.duplicate.link',
                [].toArray(), 'already in concept')
            render(view:'edit',model:[synset:fromSynset],
                    contentType:"text/html", encoding:"UTF-8")
            return
        }
        fromSynset.addSynsetLink(synsetLink)
        def saved = synsetLink.saveAndLog()
        if (!synsetLink.validate() || !saved) {
            fromSynset.errors = synsetLink.errors
            render(view:'edit',model:[synset:fromSynset],
                    contentType:"text/html", encoding:"UTF-8")
            return
        }
        String logText =
            "adding link:<br/><br/>${StringEscapeUtils.unescapeHtml(synsetLink.targetSynset.toShortString())}<br/>" +
            "<b>${synsetLink.linkType.verbName}</b><br/>" +
            "${StringEscapeUtils.unescapeHtml(synsetLink.synset.toShortString())}"
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
