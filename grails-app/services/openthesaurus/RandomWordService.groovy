/**
 * OpenThesaurus - web-based thesaurus management tool
 * Copyright (C) 2013 Daniel Naber (www.danielnaber.de)
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

import com.vionto.vithesaurus.Term

class RandomWordService {

    static transactional = false

    def dataSource
    def grailsApplication
    
    List<String> words
    Random random
    
    def getRandomWords(int numberOfWords) {
        if (random == null) {
            long seed = Long.parseLong(grailsApplication.config.thesaurus.randomWordSeed)
            log.info("Initializing random generator with secret seed from configuration and current time")
            random = new Random(seed + System.currentTimeMillis())
        }
        if (words == null) {
            initWords()
        }
        List result = []
        for (int i = 0; i < numberOfWords; i++) {
            int randomNumber = random.nextInt(words.size())
            result.add(words.get(randomNumber))
        }
        return result
    }

    def getRandomWordsCount() {
        return words.size()
    }
    
    private initWords() {
        log.info("Initializing random words...")
        def allTerms = Term.withCriteria {
          synset {
            eq('isVisible', true)
          }
        }
        def noSpaceTerms = allTerms.findAll { term -> !term.word.contains(" ") }
        this.words = noSpaceTerms.flatten { term -> term.word }
        log.info("Initialized ${this.words.size()} random words.")
    }

}