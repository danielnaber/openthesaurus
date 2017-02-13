package com.vionto.vithesaurus

/**
 * Differences between two properties.
 */
class PropertyDifference {

    String propertyName
    String propertyValue1

    static constraints = {
        propertyName(nullable:true, size: 0..5000)
        propertyValue1(nullable:true, size: 0..5000)
    }
}
