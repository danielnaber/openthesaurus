<%@page import="com.vionto.vithesaurus.*" %>

<g:form name="searchform" class="mainpage" action="search" controller="synset" method="get">

    <input name="q" value="${params?.q?.encodeAsHTML()}" />&nbsp;
    
    <g:if test="${Section.count() > 1}">
	    <g:select name="section.id" from="${Section.list().sort()}" optionKey="id"
	        value="${params['section.id']}" noSelection="['null':'-thesaurus-']" style="width:120px" />
    </g:if>
        
    <g:if test="${Source.count() > 1}">
    	<g:select name="source.id" from="${Source.list().sort()}" optionKey="id"
        	value="${params['source.id']}" noSelection="['null':'-source-']" style="width:120px" />
    </g:if>
    
    <g:if test="${Category.count() > 1}">
	    <select name="category.id" style="width:120px" id="category.id" >
	        <option value="null">-pref. category type-</option>
	        <g:each var="cat" in="${Category.findAllByIsOriginal(false).sort()}">
	            <g:if test="${params && cat.id.toString() == params['category.id']}">
	                <option selected="selected" value="${cat.id}">${cat.encodeAsHTML()}</option>
	            </g:if>
	            <g:else>
	                <option value="${cat.id}">${cat.encodeAsHTML()}</option>
	            </g:else>
	        </g:each>
	        <option value="-1">---pref. category---</option>
	        <g:each var="cat" in="${Category.list().sort()}">
	            <g:if test="${params && cat.id.toString() == params['category.id']}">
	                <option selected="selected" value="${cat.id}">${cat.toString()?.encodeAsHTML()}</option>
	            </g:if>
	            <g:else>
	                <option value="${cat.id}">${cat.toString()?.encodeAsHTML()}</option>
	            </g:else>
	        </g:each>
	    </select>
    </g:if>
    
    <input class="submit" type="submit" value="Search" />
    &nbsp;&nbsp;
    <span class="hintText"><g:link controller="search" action="help">Help</g:link></span>
    <br />
    <br/>
    <g:if test="${session.user}">
        <g:render template="/menubar"/>
    </g:if>
    <g:else>
        <g:render template="/menubar"/>
    </g:else>

</g:form>   
        
        
<script type="text/javascript">
<!--
    document.searchform.q.focus();
// -->
</script>
