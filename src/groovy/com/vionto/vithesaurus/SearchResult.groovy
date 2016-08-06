package com.vionto.vithesaurus

/**
 * Result of synset search.
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
    
    public String toString() {
        return synsetList
    }

}
