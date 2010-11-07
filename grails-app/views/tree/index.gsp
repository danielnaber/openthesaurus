<%@page import="com.vionto.vithesaurus.*" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <g:if test="${synsetToOpen}">
        	<title>${synsetToOpen.toShortString().encodeAsHTML()} - <g:message code="tree.title" /></title>
        </g:if>
        <g:else>
	        <title><g:message code="tree.title" /></title>
        </g:else>
    </head>
    <body>

          <hr />
    
          <h2><g:message code="tree.headline" /></h2>

          <g:if test="${flash.message}">
              <div class="message">${flash.message}</div>
          </g:if>

          <table style="border:0px">
          <tr>
              <td><p><g:message code="tree.intro" /></p>

                  <h2><g:message code="tree.nouns" /></h2>

                  <ul class="tree">
                      <li>
                          <%=topNounSynset%>
                      </li>
                      <li>
                          <ul class="tree">
                              <%=nounTree%>
                          </ul>
                      </li>
                  </ul>

                  <h2><g:message code="tree.verbs" /></h2>

                  <ul class="tree">
                      <li>
                          <%=topVerbSynset%>
                      </li>
                      <li>
                          <ul class="tree">
                              <%=verbTree%>
                          </ul>
                      </li>
                  </ul>

              </td>
              <td><g:render template="/ads/tree_right"/></td>
          </tr>
          </table>

          <g:render template="/ads/tree_bottom"/>

    </body>
</html>
