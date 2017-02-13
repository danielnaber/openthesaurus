package com.vionto.vithesaurus

/**
 * Differences between two properties.
 */
class PropertyDifference {

    String propertyName
    String propertyValue1

    static constraints = {
        propertyName(nullable:true)
        propertyValue1(nullable:true)
    }
}
