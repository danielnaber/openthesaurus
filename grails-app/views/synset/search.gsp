<%@page import="com.vionto.vithesaurus.*" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <g:if test="${mobileBrowser && false}">  <%-- TODO --%>
        	<meta name="layout" content="main_mobile" />
       	</g:if>
       	<g:else>
       		<meta name="layout" content="main" />
       	</g:else>
        <title><g:message code='result.matches.for.title' args="${[params.q.encodeAsHTML()]}"/></title>

        <g:if test="${descriptionText}">
          <meta name="description" content="Gefundene Synonyme: ${descriptionText.encodeAsHTML()}..."/>
        </g:if>

    </head>
    <body>

        <table width="980">
        <tr>
          <td colspan="3" valign="top">
            <hr style="margin-top:30px"/>
          </td>
          <td width="20"></td>
          <td width="200" rowspan="3" valign="top">
            <div style="margin-top:30px">
              <g:render template="/ads/resultpage"/>
            </div>
          </td>
        </tr>
        <tr>
          <td width="365">
            <h1>Ergebnisse</h1>
          </td>
          <td width="30"></td>
          <td width="365"></td>
          <td width="20"></td>
        </tr>

        <tr>
          <td valign="top">
            <table>
              <tr>
                <td>
                  <g:render template="mainmatches"/>

                  <g:set var="cleanTerm" value="${params.q.trim()}" />
                  <g:if test="${totalMatches == 0}">
                      <div style="margin-top: 10px">
                        <g:link action="create" params="[term : cleanTerm]">
                             <img src="../images/icon-add.png" alt="Add icon" />
                             <g:message code="result.create.synset" args="${[cleanTerm.encodeAsHTML()]}" />
                        </g:link>
                      </div>
                  </g:if>

                  <hr />
                  
                  <g:render template="partialmatches"/>

                  <hr style="margin-top:15px" />

                  <h2>Nicht das Richtige dabei?</h2>

                  <p class="addNewTerm">
                    <g:link action="create" params="[term : cleanTerm]">
                         <img src="../images/icon-add.png" alt="Add icon" />
                         <g:message code="result.create.synset" args="${[cleanTerm.encodeAsHTML()]}" />
                    </g:link>
                  </p>
                  
                </td>
              </tr>
            </table>
          </td>
          <td></td>
          <td valign="top">
            <table>
              <tr>
                <td>
                  <g:render template="wiktionary"/>

                  <hr style="margin-top:15px" />

                  <g:render template="wikipedia"/>

                  <g:render template="/ads/resultpage_results"/>

                  <hr style="margin-top:15px" />

                  <h2><g:message code="result.external.search" args="${[params.q.encodeAsHTML()]}"/></h2>

                  <g:render template="/external_links" model="${[q:params.q]}"/>
                  
                </td>
              </tr>
            </table>
          </td>
        </tr>
        </table>

    </body>
</html>
