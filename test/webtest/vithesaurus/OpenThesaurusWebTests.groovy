/**
 * vithesaurus - web-based thesaurus management tool
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
package vithesaurus

import com.vionto.vithesaurus.Synset
import com.vionto.vithesaurus.Language
import com.vionto.vithesaurus.Term
import com.vionto.vithesaurus.TermLevel
import com.vionto.vithesaurus.CategoryLink
import com.vionto.vithesaurus.ThesaurusConfigurationEntry

class OpenThesaurusWebTests extends grails.util.WebTest {

   void testXml() {
       initData()

       invoke '/synset/createMemoryDatabase'
       verifyText('OK')

       invoke '/synonyme/search?q=test&format=text/xml'
       verifySynsets()

       // similarity search:
       invoke '/synonyme/search?q=txst&format=text/xml&similar=true'
       verifyXPath(xpath: "/matches/similarterms/term[@term ='Test' and @distance=1]")
       not {
           verifyXPath(xpath: "/matches/synset")
           verifyXPath(xpath: "/matches/substringterms")
       }

       // substring substring:
       invoke '/synonyme/search?q=te&format=text/xml&substring=true'
       verifyXPath(xpath: "/matches/substringterms/term[@term ='Tess öäüß']")
       verifyXPath(xpath: "/matches/substringterms/term[@term ='Test']")
       not {
           verifyXPath(xpath: "/matches/synset")
           verifyXPath(xpath: "/matches/similarterms")
       }

       invoke '/synonyme/search?q=te&format=text/xml&substring=true&substringFromResults=1'
       verifyXPath(xpath: "/matches/substringterms")
       verifyXPath(xpath: "/matches/substringterms/term[@term ='Test']")
       not {
           verifyXPath(xpath: "/matches/substringterms/term[@term ='Tess öäüß']")
           verifyXPath(xpath: "/matches/synset")
           verifyXPath(xpath: "/matches/similarterms")
       }

       invoke '/synonyme/search?q=te&format=text/xml&substring=true&substringMaxResults=1'
       verifyXPath(xpath: "/matches/substringterms/term[@term ='Tess öäüß']")
       not {
           verifyXPath(xpath: "/matches/substringterms/term[@term ='Test']")
           verifyXPath(xpath: "/matches/synset")
           verifyXPath(xpath: "/matches/similarterms")
       }

       // all search modes at once:
       invoke '/synonyme/search?q=test&format=text/xml&substring=true&mode=all'
       verifySynsets()
       verifyXPath(xpath: "/matches/startswithterms/term[@term ='Test']")

       invoke '/synonyme/search?q=tes&format=text/xml&substring=true&mode=all'
       verifyXPath(xpath: "/matches/similarterms/term[@term ='Test' and @distance=1]")
       verifyXPath(xpath: "/matches/substringterms/term[@term ='Tess öäüß']")
       verifyXPath(xpath: "/matches/substringterms/term[@term ='Test']")
       verifyXPath(xpath: "/matches/startswithterms/term[@term ='Tess öäüß']")
       verifyXPath(xpath: "/matches/startswithterms/term[@term ='Test']")
   }

    private void verifySynsets() {
        verifyXPath(xpath: '/matches/synset[@id=1]')
        verifyXPath(xpath: '/matches/synset[@id=1]/categories', '')
        verifyXPath(xpath: "/matches/synset[@id=1]/term[@term='Test']")
        verifyXPath(xpath: "/matches/synset[@id=1]/term[@term='Tess öäüß']")
        verifyXPath(xpath: "/matches/synset[@id=1]/term[@term='Tess öäüß' and @level='colloquial']")

        verifyXPath(xpath: '/matches/synset[@id=2]')
        verifyXPath(xpath: "/matches/synset[@id=2]/categories/category[@name = 'meine Kategorie']")

        not {
            verifyXPath(xpath: '/matches/synset[@id=3]')
        }
    }

    private void initData() {
        new TermLevel(levelName: 'colloquial', shortLevelName: 'coll').save(failOnError: true)
        new com.vionto.vithesaurus.Category(categoryName: 'meine Kategorie').save(failOnError: true)
        createSynset1()
        createSynset2()
        new ThesaurusConfigurationEntry(key: "requestLimitMaxRequests", value: "1000").save(failOnError: true)
    }

    private void createSynset1() {
        Synset synset = new Synset(isVisible: true)
        Language language = Language.findByShortForm("de")
        Term term1 = new Term("Test", language, synset)
        Term term2 = new Term("Tess öäüß", language, synset)
        term2.level = TermLevel.findByShortLevelName("coll")
        synset.save()
        synset.addToTerms(term1)
        term1.save()
        term2.save()
    }

    private void createSynset2() {
        Synset synset = new Synset(isVisible: true)
        Language language = Language.findByShortForm("de")
        Term term1 = new Term("Test", language, synset)
        synset.save()
        synset.addToTerms(term1)
        com.vionto.vithesaurus.Category category = com.vionto.vithesaurus.Category.findByCategoryName("meine Kategorie")
        CategoryLink categoryLink = new CategoryLink(category: category, synset: synset)
        categoryLink.save()
        synset.addToCategoryLinks(categoryLink)
        term1.save()
    }

    /*void testJson() {
        // TODO: test
    }

    void testJsonCallback() {
        // TODO: test
    }*/

}