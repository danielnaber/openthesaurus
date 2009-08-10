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
package com.vionto.vithesaurus;

/**
 * The language attached to each Term.
 */
class Language {
    
  String longForm
  String shortForm
  /** If disabled == true, cannot be selected when creating new synsets or terms */
  Boolean isDisabled

  static mapping = {
      //id generator:'sequence', params:[sequence:'language_seq']
  }

  Language() {
  }
  
  Language(String longForm, String shortForm) {
      this.longForm = longForm
      this.shortForm = shortForm
  }
  
  static constraints = {
      shortForm(unique:true)
      longForm(unique:true)
      isDisabled(nullable:true)
  }
  
  String toString() {
      return longForm
  }

  public int hashCode() {
      return longForm.hashCode() + shortForm.hashCode()
  }
  
  public boolean equals(Object other) {
      if (other instanceof Language) {
          return other.longForm == longForm && other.shortForm == shortForm
      } else {
          return false
      }
  }
  
}
