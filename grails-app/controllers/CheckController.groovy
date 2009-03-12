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
import java.sql.Statement

/**
 * Several checks for potential quality problems. Some of these checks
 * use Oracle-specific syntax to get acceptable performance.
 */
class CheckController extends BaseController {

    def beforeInterceptor = [action: this.&auth]

    def dataSource       // will be injected
    def sessionFactory   // will be injected

    /**
     * Iterate over all synsets and call the extended validation.
     * Renders errors and logs them.
     */
    def validateSynsets = {
        log.info("running validateSynsets")
        def hibSession = sessionFactory.getCurrentSession()
        Connection conn = dataSource.getConnection()
        Statement st = conn.createStatement()
        ResultSet rs = st.executeQuery("""SELECT id
            FROM synset
            WHERE synset.is_visible = 1
            ORDER BY id""")
        int counter = 0
        long startTime = System.currentTimeMillis()
        while (rs.next()) {
            Synset synset = Synset.get(rs.getInt("id"))
            try {
                synset.extendedValidate(true)
                for (term in synset.terms) {
                    term.extendedValidate()
                }
            } catch (IllegalArgumentException e) {
                String msg = "validation error: ${e.getMessage()}"
                log.warn(msg)
                render "${msg}<br/>"
            }
            counter++
            if (counter % 50 == 0) {
                float time = (System.currentTimeMillis() - startTime) / 1000
                log.info("validating synset $counter (${time}s)")
                startTime = System.currentTimeMillis()
                hibSession.clear()
            }
        }
        st.close()
        conn.close()
    }

    /**
     * List all synsets that are not visible.
     */
    def listInvisibleSynsets = {
        if(!params.max) params.max = 10
        if(!params.sort) params.sort = "synsetPreferredTerm"
        params.offset = params.offset ? Integer.parseInt(params.offset) : 0
        // get the invisible synsets to display:
        def synsetList = Synset.withCriteria {
            eq('isVisible', false)
            if (params.filter) {
                terms {
                    ilike('word', params.filter)
                }
            }
            maxResults(10)
            firstResult(params.offset)
            order(params.sort)
        }
        // get the number of invisible synsets:
        int totalMatches = -1
        if (params.filter) {
            def synsetListComplete = Synset.withCriteria {
                eq('isVisible', false)
                terms {
                    ilike('word', params.filter)
                }
            }
            totalMatches = synsetListComplete.size()
        } else {
            totalMatches = Synset.countByIsVisible(false)
        }
        [ synsetList : synsetList, totalMatches : totalMatches ]
    }

    /**
     * Find concepts that have been imported and that need to be checked.
     */
    def listImportedSynsets = {
        if(!params.max) params.max = 10
        if(!params.sort) params.sort = "synsetPreferredTerm"
        def synsetList = Synset.withCriteria {
            eq('importStatus', 1)
            eq('isVisible', false)
        }
        int totalMatches = synsetList.size()
        render(view: "listSynsets", model:[synsetList : synsetList,
            title: "Check for automatically imported concepts that " +
            "need to be confirmed"])
    }

    /**
     * List homonyms, i.e. words that appear in more than one synset.
     */
    def listHomonyms = {
        log.info("running listHomonyms")
        if (params['section.id'] != "null" && Integer.parseInt(params['section.id']) == 0) {
            // special case to display to page faster (listing all
            // homonyms of all sections  is rarely useful anyway):
            [ wordMap : new HashMap() ]
        }
        Connection conn = dataSource.getConnection()
        Statement st = conn.createStatement()
        String sectionLimit = ""
        if (params['section.id'] && params['section.id'] != "null") {
            // example how to build cross-thesaurus homonym lists:
            //sectionLimit = "AND (synset.section_id = " +
            //    "${Integer.parseInt(params['section.id'])} OR synset.section_id = 4771269)"
            sectionLimit = "AND (synset.section_id = " +
                "${Integer.parseInt(params['section.id'])})"
        }
        // lowercase normalized:
        String sql
        if (params.ignoreCase) {
            sql = """SELECT lower(word),
                count(lower(word)) AS counter
                FROM term, synset
                WHERE
                    synset.id = term.synset_id AND
                    synset.is_visible = 1
                    $sectionLimit
                    GROUP BY lower(word) ORDER BY counter DESC"""
        } else {
            sql = """SELECT word,
                count(word) AS counter
                FROM term, synset
                WHERE
                    synset.id = term.synset_id AND
                    synset.is_visible = 1
                    $sectionLimit
                GROUP BY word ORDER BY counter DESC"""
        }
        log.debug("listHomonyms SQL: $sql")
        ResultSet rs = st.executeQuery(sql)
        List homonyms = []
        List homonymCounts = []
        while (rs.next()) {
            int counter = rs.getInt("counter")
            if (counter <= 1) {
                break
            }
            if (params.ignoreCase) {
                homonyms.add(rs.getString("lower(word)"))
            } else {
                homonyms.add(rs.getString("word"))
            }
            homonymCounts.add(counter)
        }
        st.close()
        conn.close()
        assert(homonyms.size() == homonymCounts.size())
        [ homonyms : homonyms, homonymCounts: homonymCounts ]
    }

    /**
     * List all terms that contain only uppercase characters.
     */
    def listUppercaseTerms = {
        log.info("running listUppercaseTerms")
        // This query makes sure we only get the words, which is *much*
        // faster than getting the complete objects via Term.list():
        def uppercaseWords = Term.executeQuery("select word from " +
                "com.vionto.vithesaurus.Term where word = upper(word)")
        [ wordList : uppercaseWords ]
    }

    /**
     * List empty synsets, i.e. synsets with no term (should never happen).
     */
    def listEmptySynsets = {
        log.info("running listEmptySynsets")
        List emptySynsets = []
        //
        // WARNING: only use SQL for read access (if all other ways fail
        // or are too slow), never write to the database directly using SQL!
        //
        Connection conn = dataSource.getConnection()
        Statement st = conn.createStatement()
        ResultSet rs = st.executeQuery("""select synset.id from synset, term
                where synset.id = term.synset_id(+) AND synset.is_visible = 1
                AND word IS NULL order by id""")
        while (rs.next()) {
            emptySynsets.add(Synset.get(rs.getInt("id")))
        }
        //emptySynsets = Synset.executeQuery("select synset.id from synset,
        //   term where synset.id = term.synset_id(+) AND word IS NULL order by id")
        // It seems we cannot make this query via HQL with executeQuery()
        // because that requires a mapping.
        [ synsetList : emptySynsets ]
    }

    /**
     * List synsets that are in no category at all.
     */
    def listNoCategorySynsets = {
        log.info("running listNoCategorySynsets")
        List synsets = []
        Connection conn = dataSource.getConnection()
        Statement st = conn.createStatement()
        ResultSet rs = st.executeQuery("""select synset.id from
                synset, category_link
                where
                synset.id = category_link.synset_id(+) AND
                synset.is_visible = 1 AND
                category_link.id IS NULL order by id""")
        while (rs.next()) {
            synsets.add(Synset.get(rs.getInt("id")))
        }
        render(view: "listSynsets", model:[synsetList : synsets,
            title: "Check for concepts without categories"])
    }

    /**
     * List synsets that have no preferred term at all.
     */
    def listNoPreferredTermSynsets = {
        log.info("running listNoPreferredTermSynsets")
        List synsets = []
        Connection conn = dataSource.getConnection()
        Statement st = conn.createStatement()
        ResultSet rs = st.executeQuery("""select synset.id from
                synset, preferred_term_link
                where
                synset.id = preferred_term_link.synset_id(+) AND
                synset.is_visible = 1 AND
                preferred_term_link.id IS NULL order by id""")
        while (rs.next()) {
            synsets.add(Synset.get(rs.getInt("id")))
        }
        log.info("done listNoCategorySynsets")
        render(view: "listSynsets", model:[synsetList : synsets,
            title: "Check for concepts without preferred terms"])
    }

}
