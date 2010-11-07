<%@page import="com.vionto.vithesaurus.*" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title><g:message code="substring.title" args="${[params.q.encodeAsHTML()]}"/></title>
    </head>
    <body>

          <hr />

          <h2><g:message code="substring.headline" args="${[params.q.encodeAsHTML()]}"/></h2>

          <g:if test="${flash.message}">
              <div class="message">${flash.message}</div>
          </g:if>

          <ul>
              <g:each in="${matches}" status="i" var="term">
                  <li><g:link action="search" params="${[q:term.term]}">${term.highlightTerm}</g:link></li>
              </g:each>
              <g:if test="${totalMatches == 0}">
                  <li><g:message code="result.no.matches"/></li>
              </g:if>
          </ul>

          <br />


          <g:if test="${totalMatches > 20}">
              <div class="paginateButtons">
                  <g:paginate total="${totalMatches}" params="${[q: params.q]}" />
              </div>
          </g:if>
			
    </body>
</html>
