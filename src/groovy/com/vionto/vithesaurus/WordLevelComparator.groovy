package com.vionto.vithesaurus

/**
 * Compare so that synsets whose relevant term has no language level set is preferred.
 */
class WordLevelComparator implements Comparator {

    String query

    WordLevelComparator(String query) {
        this.query = query
    }

    @Override
    int compare(Object o1, Object o2) {
        Synset syn1 = (Synset) o1
        Synset syn2 = (Synset) o2
        int syn1Prio = hasLevelForQuery(syn1.terms) ? 1 : 0
        int syn2Prio = hasLevelForQuery(syn2.terms) ? 1 : 0
        return syn1Prio - syn2Prio
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
