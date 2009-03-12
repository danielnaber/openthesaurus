/**
 * These versions of the tags are identical to the original onse, except that
 * you can set the "disabled" property to true or false.
 * Also see
 * http://docs.codehaus.org/display/GRAILS/Contribute+a+Tag#ContributeaTag-managedCheckBox
 */
class ManagedFormsTagLib {

    /**
     * A helper tag for creating checkboxes
     */
    def managedCheckBox = { attrs ->
        attrs.id = attrs.id ? attrs.id : attrs.name    
        def value = attrs.remove('value')
        def name = attrs.remove('name')  
        def checked = attrs.remove('checked')
        def disabled = attrs.remove('disabled')
        if(checked == null) checked = true
        if(checked instanceof String) checked = Boolean.valueOf(checked)
       
        if(value == null) value = false
        out << "<input type=\"hidden\" name=\"_${name}\" /><input type=\"checkbox\" name=\"${name}\" "
        if(value && checked) {
            out << 'checked="checked" '
        }
        def outputValue = !(value instanceof Boolean || value?.class == boolean.class)
        if(outputValue) {
            out << "value=\"${value}\" "
        }
        if (disabled) {
            out << 'disabled="disabled" '
        }
        // process remaining attributes
        outputAttributes(attrs)
        // close the tag, with no body
        out << ' />'
    }

    /**
     * A helper tag for creating radio buttons. 
     */
    def managedRadio = { attrs ->
        def value = attrs.remove('value')
        def name = attrs.remove('name')
        def disabled = attrs.remove('disabled')
        def checked = (attrs.remove('checked') ? true : false)
        out << '<input type="radio" '
        out << "name=\"${name}\" "
        if (disabled) {
            out << 'disabled="disabled" '
        }
        if (checked) {
              out << 'checked="checked" '
        }
        out << "value=\"${value.toString().encodeAsHTML()}\" "
        // process remaining attributes
        outputAttributes(attrs)
        // close the tag, with no body
        out << ' />'
    }
    
    /**
     * Dump out attributes in HTML compliant fashion.
     * Copied from Grail's FormTagLib.groovy.
     */
    void outputAttributes(attrs) {
        attrs.each { k,v ->
            out << k << "=\"" << v.encodeAsHTML() << "\" "
        }
    }
    
}
