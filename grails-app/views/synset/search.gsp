<%@page import="com.vionto.vithesaurus.*" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
   		<meta name="layout" content="main" />
        <title><g:message code='result.matches.for.title' args="${[params.q]}"/></title>

        <g:if test="${descriptionText}">
          <meta name="description" content="${message(code:'result.matches.for.description', args:[descriptionText.encodeAsHTML()])}"/>
        </g:if>
        <g:if test="${withAd}">
        </g:if>
    </head>
    <body>

    <div id="searchSpace">

        <g:render template="searchinternal"/>

    </div>
        
    </body>
</html>
