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
package com.vionto.vithesaurus

/**
 * Comparison of Groovy objects.
 */
class DiffTool {
    
    // ignore properties that are not specific to our objects and get..() methods
    // that do not refer to real properties:
    final static IGNORE_PROPS = ["class", "metaClass", "all", "properties", "errors",
                                 "constraints", "log", "hasMany", "version", "sortedTerms",
                                 "userEvents", "sortedSynsetLinks", "mapping",
                                 "tERM_REGEXP", "pREFERRED_TERM_LANGS", "uRI_PREFIX",
                                 "TERM_REGEXP", "PREFERRED_TERM_LANGS", "URI_PREFIX"]

    /**
     * Compares two objects by comparing their properties and returns
     * the difference. A hard-coded list of "internal" properties
     * like "class" etc. is ignored when making the comparison.
     */
    static List diff(Object oldObj, Object newObj) {
        if (newObj == null) {
          throw new IllegalArgumentException("newObj cannot be null")
        }
        //
        if (oldObj == null) {
          // okay, no old object to compate to, so let's "compare"
          // to an empty object
          oldObj = new Object()
        }
        List diffs = new ArrayList()
        Map newObjprops = new HashMap()
        for (prop in oldObj.metaClass.properties) {
            if (ignoreProp(prop)) {
                continue
            }
            newObjprops.put(prop.name, oldObj.getProperty(prop.name))
        }
        // find all props that differ or that are not in newObj:
        for (prop in oldObj.metaClass.properties) {
            if (ignoreProp(prop)) {
                continue
            }
            if (newObj.metaClass.hasProperty(newObj, prop.name)) {
                if (oldObj.getProperty(prop.name) == newObj.getProperty(prop.name)) {
                    // nothing
                } else {
                    Object val1 = oldObj.getProperty(prop.name)
                    Object val2 = newObj.getProperty(prop.name)
                    diffs.add(new PropertyValueDifference(prop.name, val1, val2))
                    //println "Prop differs: " + prop.name + ": " + val1 + " <-> " + val2
                }
            } else {
                diffs.add(new MissingProperty(prop.name, oldObj.getProperty(prop.name)))
                //println "Prop not found in newObj: " + prop.name
            }
        }
        // find all props that are not in oldObj:
        for (prop in newObj.metaClass.properties) {
            if (ignoreProp(prop)) {
                continue
            }
            if (!oldObj.metaClass.hasProperty(oldObj, prop.name)) {
                //println "Prop not found in oldObj: " + prop.name
                diffs.add(new NewProperty(prop.name, newObj.getProperty(prop.name)))
            }            
        }
        return diffs
    }
    
    static boolean ignoreProp(def prop) {
        return prop.name in IGNORE_PROPS
    }
        
}

/**
 * Differences between two properties.
 */
abstract class PropertyDifference {
    String propertyName
    String propertyValue1
}

/**
 * Information about a property that exists in one object but
 * not in the other object to which it was compared.
 */
class MissingProperty extends PropertyDifference {
    MissingProperty(String propertyName, Object propertyValue1) {
        this.propertyName = propertyName
        this.propertyValue1 = propertyValue1
    }
    String toString() {
        return "removed: ${propertyName}: ${propertyValue1}" 
    }
}

/**
 * Like MissingProperty but for the opposite direction.
 */
class NewProperty extends PropertyDifference {
    NewProperty(String propertyName, Object propertyValue1) {
        this.propertyName = propertyName
        this.propertyValue1 = propertyValue1
    }
    String toString() {
        return "added: ${propertyName}: ${propertyValue1}" 
    }
}

/**
 * Information about a property thta has different values in two
 * objects that are compared.
 */
class PropertyValueDifference extends PropertyDifference {
    String propertyValue2
    PropertyValueDifference(String propertyName, Object propertyValue1,
            Object propertyValue2) {
        this.propertyName = propertyName
        this.propertyValue1 = propertyValue1
        this.propertyValue2 = propertyValue2
    }
    String toString() {
        StringBuilder s = new StringBuilder()
        s.append(propertyName)
        s.append(":")
        s.append(propertyValue1)
        s.append("=>")
        s.append(propertyValue2)
        return s.toString()
    }
}
