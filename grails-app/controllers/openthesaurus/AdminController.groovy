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
import com.vionto.vithesaurus.tools.StringTools
import org.apache.commons.codec.digest.DigestUtils
import org.mindrot.jbcrypt.BCrypt

class AdminController extends BaseController {

    def index() {
        final int resultLimit = 10
        def latestUsers = ThesaurusUser.withCriteria {
          order("creationDate", "desc")
          maxResults(resultLimit)
        }
        [latestUsers: latestUsers, resultLimit: resultLimit]
    }
    
    /**
     * One-time migration: wraps every user's existing MD5 hash inside bcrypt.
     * MUST be called exactly once. Idempotent — skips users whose password
     * already starts with "$2a$" (i.e., already migrated).
     * Call via POST from admin panel, then remove this action.
     */
    def migratePasswordsToBcrypt() {
        if (request.method != 'POST') {
            render """
                <h2>Migrate all passwords from MD5 to bcrypt</h2>
                <p>This wraps each user's existing MD5 hash inside bcrypt(cost=12).</p>
                <p><strong>Back up the database first.</strong> This cannot be undone.</p>
                <form method='POST'>
                    <input type='submit' value='Run migration'
                           onclick="return confirm('Are you sure? Did you back up the database?')"/>
                </form>
            """
            return
        }
 
        int migrated = 0
        int skipped = 0
        int failed = 0
        List<String> errors = []
 
        List<ThesaurusUser> allUsers = ThesaurusUser.list()
 
        for (ThesaurusUser user : allUsers) {
            // Skip already-migrated users (idempotent)
            if (user.password?.startsWith('$2a$') || user.password?.startsWith('$2b$')) {
                skipped++
                continue
            }
 
            // Skip placeholder/expired passwords
            if (user.password == null || user.password == '__expired__') {
                skipped++
                continue
            }
 
            try {
                // Wrap the existing MD5 hash in bcrypt.
                // The salt field is preserved — the login flow uses it to know
                // this user needs md5(input, salt) before bcrypt comparison.
                String bcryptHash = BCrypt.hashpw(user.password, BCrypt.gensalt(12))
                user.password = bcryptHash
                boolean saved = user.save(flush: true)
                if (!saved) {
                    failed++
                    errors.add("${user.userId}: validation failed — ${user.errors}")
                } else {
                    migrated++
                }
            } catch (Exception e) {
                failed++
                errors.add("${user.userId}: ${e.message}")
            }
 
            if ((migrated + skipped + failed) % 50 == 0) {
                log.info("Migration progress: ${migrated} migrated, ${skipped} skipped, ${failed} failed")
            }
        }
 
        log.info("Password migration complete: ${migrated} migrated, ${skipped} skipped, ${failed} failed")
 
        StringBuilder report = new StringBuilder()
        report.append("<h2>Migration complete</h2>")
        report.append("<p><strong>Migrated:</strong> ${migrated}</p>")
        report.append("<p><strong>Skipped (already migrated / expired):</strong> ${skipped}</p>")
        report.append("<p><strong>Failed:</strong> ${failed}</p>")
        if (errors) {
            report.append("<h3>Errors:</h3><ul>")
            for (String err : errors) {
                report.append("<li>${err.encodeAsHTML()}</li>")
            }
            report.append("</ul>")
        }
        report.append("<p><em>Remove this action from AdminController now.</em></p>")
        render report.toString()
    }

    // clean old, inactive users, i.e. delete their accounts:
    def cleanUsers() {
        def pageSize = 500
        def c = ThesaurusUser.createCriteria()
        Date registrationDate = new Date()
        registrationDate.year = registrationDate.year - 1
        Date loginDate = new Date()
        loginDate.year = loginDate.year - 1
        render("Showing old users with no activity ever:<br>")
        render("Registration Date before: " + registrationDate + "<br>")
        render("Last Login Date before: " + loginDate + "<br>")
        def result = c.list {
            lt("creationDate", registrationDate)
            or {
                lt("lastLoginDate", loginDate)
                isNull("lastLoginDate")
            }
            eq("blocked", false)
        }
        render(result.size() + " total matches (incl. active users), showing up to " + pageSize + ":<br>")
        int count = 0
        for (user in result) {
            def c2 = UserEvent.createCriteria()
            def userEvents = c2.list {
                eq("byUser", user)
            }
            def c3 = UserSynsetEvent.createCriteria()
            def userSynsetEvents = c3.list {
                eq("byUser", user)
            }
            if (userEvents.size() == 0 && userSynsetEvents.size() == 0) {
                render(userEvents.size() + " " + userSynsetEvents.size() + " " + user.creationDate.toString() + " " + user.lastLoginDate.toString() + " " + user.userId + "<br>")
                if (request.method == 'POST') {
                    log.info("Deleting old user in admin/cleanUsers(): " + user.userId)
                    user.delete()
                    render "&nbsp;&nbsp;&nbsp;" + user.userId + ": user deleted!<br>"
                }
                count++
                if (count >= pageSize) {
                    break
                }
            }
        }
        if (request.method != 'POST') {
            render "<form method='post'><input type='submit' value='Delete shown users (" + count + ")'></form>"
        }
        return ""
    }

    def prepareAudioImport() {
    }

    /*def importAudio() {
        int count = 0
        Scanner sc = new Scanner(new File(params.path))
        Audio.executeUpdate('delete from Audio')
        while (sc.hasNextLine()) {
            String line = sc.nextLine()
            String[] parts = line.split("\\|")
            String word
            String urlSuffix
            if (parts.length == 1) {
                word = parts[0].replaceFirst("^De-", "").replaceFirst("\\.ogg", "").replaceFirst("_", " ")
                urlSuffix = parts[0]
            } else if (parts.length == 2) {
                word = parts[1]
                urlSuffix = parts[0]
            } else {
                log.warn("Could not parse line: " + line)
                continue
            }
            String md5sum = DigestUtils.md5Hex(urlSuffix.replace(' ', '_'))
            String md5path = md5sum.substring(0, 1) + "/" + md5sum.substring(0, 2) + "/"  //  e.g. "5/5e/"
            String url = "https://upload.wikimedia.org/wikipedia/commons/" + md5path + urlSuffix
            // TODO: extract author and license:
            Audio audio = new Audio(word: word, url: url, author: "-", license: "-")
            audio.save(failOnError: true)
            count++
            if (count % 100 == 0) {
                log.info("Audio import ${count}...")
            }
        }
        flash.message = "Imported ${count} terms"
        redirect(action: 'index')
    }*/

    def listUnusedTags() {
        def list = Tag.findAll()
        list.sort()
        LinkedHashMap tagToCount = new LinkedHashMap()
        List tagList = Tag.findAll()
        for (Tag tag : tagList) {
            def count = Term.createCriteria().count {
                tags {
                    eq('name', tag.name)
                }
            }
            if (count == 0) {
                tagToCount.put(tag, 0)
            }
        }
        [tagToCount: tagToCount]
    }

    def checkNormalizedTermIntegrity() {
        int count = runTermIntegrityCheck(false)
        render "<br>Checked ${count} terms."
        render "<form action='updateNormalizedTerms' method='post'>"
        render "  <input type='submit' value='Update Normalized Fields'/>"
        render "</form>"
    }

    def updateNormalizedTerms() {
        if (request.method != 'POST') {
            throw new Exception("Please call using method=POST")
        }
        int count = runTermIntegrityCheck(true)
        render "<br>Ran over ${count} terms."
    }

    private int runTermIntegrityCheck(boolean doUpdate) {
        List terms = Term.list()
        int count = 0
        int found = 0
        for (term in terms) {
            if (!term.synset.isVisible) {
                continue
            }
            String normalizedWord = StringTools.normalize(term.word)
            if (normalizedWord == term.word) {
                normalizedWord = null
            }
            if (normalizedWord != term.word && normalizedWord != term.normalizedWord) {
                render "${found}. Error1: <a href='../term/edit/${term.id}'>'${term.normalizedWord}' should be '${normalizedWord}'</a><br />"
                found++
                if (doUpdate) {
                    log.info("Setting normalizedWord '${term.normalizedWord}' to '${normalizedWord}'")
                    term.normalizedWord = normalizedWord
                }
            }
            String normalizedWord2 = StringTools.normalize2(term.word)
            if (normalizedWord2 == term.word || normalizedWord2 == normalizedWord) {
                normalizedWord2 = null
            }
            if (normalizedWord2 != term.normalizedWord2) {
                render "${found}. Error2: <a href='../term/edit/${term.id}'>'${term.normalizedWord2}' should be '${normalizedWord2}'</a><br />"
                found++
                if (doUpdate) {
                    log.info("Setting normalizedWord2 '${term.normalizedWord2}' to '${normalizedWord2}'")
                    term.normalizedWord2 = normalizedWord2
                }
            }
            count++
            //if (found > 10) { break }
        }
        count
    }

    def tagging() {
    }

    def prepareTagging() {
        Tag newTag = getTag(true)
        List<Term> terms = getTerms()
        Map termToNew = new HashMap()
        for (term in terms) {
            termToNew.put(term, applyPattern(term.word, params.pattern))
        }
        [terms: terms, termToNew: termToNew, newTag: newTag, pattern: params.pattern]
    }

    def doTagging() {
        Tag newTag = getTag(false)
        List<Term> terms = getTerms()
        for (term in terms) {
            term.word = applyPattern(term.word, params.pattern)
            term.addToTags(newTag)
            term.save(failOnError: true)
        }
        flash.message = "Tagged ${terms.size()} terms"
        redirect(action: 'tagging')
    }

    private Tag getTag(boolean allowCreation) {
        if (params.tags.contains(",")) {
            throw new Exception("Words can only be tagged with one tag: ${params.tags}")
        }
        String tagName = params.tags
        Tag newTag = Tag.findByName(tagName)
        if (!newTag) {
            if (allowCreation) {
                newTag = new Tag()
                newTag.name = tagName
                newTag.created = new Date()
                newTag.createdBy = session.user.userId
                newTag.save(failOnError: true)
            } else {
                throw new Exception("Unknown tag '${params.tags}'")
            }
        }
        return newTag
    }

    private List<Term> getTerms() {
        def c = Term.createCriteria()
        List result = c.list {
            like('word', "%" + params.pattern + "%")
            synset {
                eq('isVisible', true)
            }
        }
        return result
    }

    private applyPattern(String word, String pattern) {
        return word.replaceAll(pattern, "").replaceAll("  +", " ").trim();
    }

}
