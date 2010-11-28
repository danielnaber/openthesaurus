<%@page import="com.vionto.vithesaurus.*" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
   		<meta name="layout" content="main" />
        <title><g:message code='result.matches.for.title' args="${[params.q.encodeAsHTML()]}"/></title>

        <g:if test="${descriptionText}">
          <meta name="description" content="Gefundene Synonyme: ${descriptionText.encodeAsHTML()}..."/>
        </g:if>

    </head>
    <body>

        <table width="980">
        <tr>
          <td colspan="3" valign="top">
            <hr style="margin-top:20px;margin-bottom:10px"/>
          </td>
          <td width="10"></td>
          <td width="180" rowspan="3" valign="top">
            <div style="margin-top:20px">
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
          <td width="10"></td>
        </tr>

        <tr>
          <td valign="top">
            <table>
              <tr>
                <td>
                  <g:render template="mainmatches"/>

                  <g:set var="cleanTerm" value="${params.q.trim()}" />
                  <g:if test="${totalMatches == 0}">
                      <g:render template="addterm" model="${[term:cleanTerm]}" />
                  </g:if>

                  <hr style="margin-top:20px" />
                  
                  <g:render template="partialmatches"/>

                  <hr style="margin-top:20px" />

                  <h2>Nicht das Richtige dabei?</h2>

                  <g:render template="addterm" model="${[term:cleanTerm]}" />

                  <g:render template="/ads/resultpage_bottom"/>
                  
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

                  <hr style="margin-top:20px" />

                  <g:render template="wikipedia"/>

                  <g:render template="/ads/resultpage_results"/>

                  <hr style="margin-top:20px" />

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
