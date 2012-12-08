package com.vionto.vithesaurus;

/**
 * Return value for WordListService.
 */
public class WordListLookup {

  private final String term;
  private final String url;
  private final String metaInfo;

  public WordListLookup(String term, String url, String metaInfo) {
    this.term = term;
    this.url = url;
    this.metaInfo = metaInfo;
  }

  public String getTerm() {
    return term;
  }

  public String getUrl() {
    return url;
  }

  public String getMetaInfo() {
    return metaInfo;
  }
}
