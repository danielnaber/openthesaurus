/**
 * Simple number formatter for integers, which applies Java default formatting.
 * For example, turns "10000" into "10.000" (or "10,000", depending on locale).
 */
class DecimalFormatTagLib {
    
    def decimal = {
            attrs ->
            java.text.DecimalFormat df = new java.text.DecimalFormat()
            out << df.format(attrs.get("number"))
    }
    
}
