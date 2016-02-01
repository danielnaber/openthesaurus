/**
 * OpenThesaurus - web-based thesaurus management tool
 * Copyright (C) 2016 Daniel Naber (www.danielnaber.de)
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

import com.vionto.vithesaurus.CategoryLink
import com.vionto.vithesaurus.LogInfo
import com.vionto.vithesaurus.Synset
import com.vionto.vithesaurus.SynsetLink
import com.vionto.vithesaurus.Term
import com.vionto.vithesaurus.TermLink
import com.vionto.vithesaurus.UserEvent
import com.vionto.vithesaurus.tools.IpTools

class MergeController extends BaseController {
    
    def beforeInterceptor = [action: this.&auth]

    static def allowedMethods = [doMerge:'POST']

    def index = {
        def userActions = UserEvent.countByByUser(session.user)
        if (userActions < Integer.parseInt(grailsApplication.config.thesaurus.minUserActionsForMerge)) {
            [warning: true, minActions: grailsApplication.config.thesaurus.minUserActionsForMerge]
        } else {
            Synset s1 = Synset.get(params.synset1)
            Synset s2 = Synset.get(params.synset2)
            [synset1: s1, synset2: s2]
        }
    }

    def doMerge = {
        Synset s1 = Synset.get(params.synset1)
        Synset origSynset = s1.clone()
        Synset s2 = Synset.get(params.synset2)
        log.info("Merging ${s1.id} and ${s2.id} by user ${session.user.id}")
        
        // terms:
        for (term in s2.terms) {
            Term newTerm = term.clone()
            if (!s1.containsWord(term.word)) {
                log.info("Adding term '${term}' to ${s1.id}")
                newTerm.synset = s1
                newTerm.termLinks = []
                // TODO: this is still buggy:
                /*for (termLink in term.termLinks) {
                    def newTermLink = new TermLink(termLink.term, termLink.targetTerm, termLink.linkType)
                    log.info("Adding direct term link '${newTermLink}' to ${s1.id}")
                    newTerm.addToTermLinks(newTermLink)
                }
                def termLinks = TermLink.findByTargetTerm(term)
                for (termLink in termLinks) {
                    def newTermLink = new TermLink(termLink.targetTerm, newTerm, termLink.linkType)
                    log.info("Adding indirect term link '${newTermLink}' to ${s1.id}")
                    newTerm.addToTermLinks(newTermLink)
                    termLink.delete()
                }*/
                s1.addTerm(newTerm)
            } else {
                log.info("Skipping existing term '${term}'")
            }
        }
        
        // categories:
        for (link in s2.categoryLinks) {
            if (!s1.containsCategoryLink(link)) {
                CategoryLink newLink = new CategoryLink(s1, link.category)
                log.info("Adding category '${link.category}' to ${s1.id}")
                s1.addCategoryLink(newLink)
            } else {
                log.info("Skipping existing category '${link.category}'")
            }
        }
        
        // super synsets and associated synsets:
        for (link in s2.synsetLinks) {
            if (!s1.containsSynsetLink(link)) {
                SynsetLink newLink = new SynsetLink(s1, link.targetSynset, link.linkType)
                log.info("Adding synset link '${link}' to ${s1.id}")
                s1.addSynsetLink(newLink)
            } else {
                log.info("Skipping existing synset link '${link}'")
            }
        }
        
        // sub synsets:
        def subLinks = SynsetLink.findByTargetSynset(s2)
        for (link in subLinks) {
            log.info("Changing synset link of '${link}' to target ${s1.id}")
            link.targetSynset = s1
            link.save(failOnError: true)
        }
        
        LogInfo logInfo1 = new LogInfo(session, IpTools.getRealIpAddress(request), origSynset, s1, "(merged with ${s2.id})")
        s1.saveAndLog(logInfo1)

        s2.setIsVisible(false)
        LogInfo logInfo2 = new LogInfo(session, IpTools.getRealIpAddress(request), null, s2, "(deleted after merge with ${s1.id})")
        s2.saveAndLog(logInfo2)
        
        log.info("Merging ${s1.id} and ${s2.id} by user ${session.user.id} finished")
        flash.message = message(code:'edit.merged')
        redirect(controller: 'synset', action: 'edit', id: s1.id)
    }

}
