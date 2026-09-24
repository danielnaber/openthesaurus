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

import com.vionto.vithesaurus.Synset

class RandomSynsetService {

    static transactional = false

    // Re-read the list of visible synset ids from the database at most this often,
    // so newly added/hidden synsets show up eventually without hitting the DB on
    // every request.
    static final long REFRESH_INTERVAL_MILLIS = 10 * 60 * 1000

    List<Long> synsetIds
    Random random
    long lastInit = 0

    def getRandomSynsets(int count) {
        if (random == null) {
            random = new Random()
        }
        if (synsetIds == null || System.currentTimeMillis() - lastInit > REFRESH_INTERVAL_MILLIS) {
            initSynsetIds()
        }
        List result = []
        Set<Integer> usedIndexes = new HashSet<>()
        int n = Math.min(count, synsetIds.size())
        while (result.size() < n) {
            int index = random.nextInt(synsetIds.size())
            if (usedIndexes.add(index)) {
                def synset = Synset.get(synsetIds.get(index))
                if (synset != null) {
                    result.add(synset)
                }
            }
        }
        return result
    }

    private synchronized initSynsetIds() {
        log.info("Initializing random synset ids...")
        this.synsetIds = Synset.createCriteria().list {
            eq('isVisible', true)
            projections {
                property('id')
            }
        }
        lastInit = System.currentTimeMillis()
        log.info("Initialized ${this.synsetIds.size()} random synset ids.")
    }

}
