/**
 * OpenThesaurus - web-based thesaurus management tool
 * Copyright (C) 2014 Daniel Naber (www.danielnaber.de)
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
package com.vionto.vithesaurus

import grails.persistence.Entity

@Entity
class Tag implements Comparable<Tag> {

    String name
    String shortName
    String color
    Date created
    String createdBy
    Boolean isVisible

    static constraints = {
        name(unique:true)
        shortName(unique:true, nullable: true)
        color(nullable:true)
        isVisible(nullable:true)
    }

    String getBackgroundColor() {
        if (color) {
            return color
        } else {
            if (isInternal()) {
                return "#f2a929"
            } else {
                return "#aaaaaa"
            }
        }
    }

    /** Whether this is an internal tag that's only to be displayed to logged-in users. */
    boolean isInternal() {
        return name?.startsWith(":")
    }
    
    boolean isVisible() {
        return isVisible == null || isVisible == true
    }

    @Override
    int compareTo(Tag other) {
        return name.compareTo(other.name)
    }

    @Override
    public String toString() {
        return name
    }

    @Override
    boolean equals(Object other) {
        if (other instanceof Tag) {
            return other.name == name
        } else {
            return false
        }
    }

    @Override
    int hashCode() {
        return name.hashCode()
    }
}
