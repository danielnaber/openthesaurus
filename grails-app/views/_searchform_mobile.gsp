<%@page import="com.vionto.vithesaurus.*" %>

<g:form name="searchform" class="mainpage_mobile" action="search" controller="synset" method="get">

    <input name="q" value="${params?.q?.encodeAsHTML()}" />&nbsp;
    
    <g:if test="${Section.count() > 1}">
	    <g:select name="section.id" from="${Section.list().sort()}" optionKey="id"
	        value="${params['section.id']}" noSelection="['null':'-thesaurus-']" style="width:120px" />
    </g:if>
        
    <g:if test="${Source.count() > 1}">
    	<g:select name="source.id" from="${Source.list().sort()}" optionKey="id"
        	value="${params['source.id']}" noSelection="['null':'-source-']" style="width:120px" />
    </g:if>

    <input class="submit" type="submit" value="<g:message code="search.button"/>" />
    <br />
    <br />
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
	document.searchform.q.select();
// -->
</script>
