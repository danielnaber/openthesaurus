<%@page import="com.vionto.vithesaurus.*" %>  
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title>${title}</title>
    </head>
    <body>

          <hr />
    
          <p><g:link controller="woerter"><g:message code="word.list.backlink" /></g:link></p>

          <h2>${headline}</h2>

          <div style="float:right;margin-left:20px">
              <g:render template="/ads/variation_right"/>
          </div>

          <p>${intro}</p>

          <ul>
              <g:each in="${termList}" var="term">
                  <li><g:link action="search" params="${[q: term.normalizedWord]}"
                      >${term.encodeAsHTML()}</g:link>
                      <%
                      int i = 0
                      %>
                      <g:each in="${term.synset.sortedTerms()}" var="synsetTerm">
                          <g:if test="${i < 3 && synsetTerm.word.indexOf(term.word) == -1}">
                              <span class="d">&middot;</span> ${synsetTerm.encodeAsHTML()}
                              <%
                              i++
                              %>
                          </g:if>
                          <g:elseif test="${i == 3}">
                              <span class="d">&middot;</span> ...
                              <%
                              i++
                              %>
                          </g:elseif>
                      </g:each>
                  </li>
              </g:each>
          </ul>
			            
    </body>
</html>
