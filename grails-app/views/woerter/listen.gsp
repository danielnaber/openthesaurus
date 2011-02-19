<%@page import="com.vionto.vithesaurus.*" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title><g:message code="wordlists.title" /></title>
    </head>
    <body>

            <hr />

    	    <h2><g:message code="wordlists.head" /></h2>

            <ul>
              <%-- FIXME
              <li><g:link controller="term" action="list"><g:message code="a_to_z"/></g:link></li>
              --%>
              <li><g:link controller="synset" action="variation" id="at"><g:message code="austrian.words"/></g:link></li>
              <li><g:link controller="synset" action="variation" id="ch"><g:message code="swiss.words"/></g:link></li>
              <li><g:link controller="tree" action="index"><g:message code="tree.headline"/></g:link></li>
            </ul>

    </body>
</html>
