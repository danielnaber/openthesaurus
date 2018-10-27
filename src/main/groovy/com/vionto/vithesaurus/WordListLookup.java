/**
 * OpenThesaurus - web-based thesaurus management tool
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
