          <td width="365">
            <h1><g:message code='result.matches.for.header' /></h1>
<%@page import="com.vionto.vithesaurus.*" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
   		<meta name="layout" content="main" />
        <title><g:message code='result.matches.for.title' args="${[params.q]}"/></title>

        <g:if test="${descriptionText}">
          <meta name="description" content="${message(code:'result.matches.for.description', args:[descriptionText.encodeAsHTML()])}"/>
        </g:if>

    </head>
    <body>

        <table width="980">
        <tr>
          <td colspan="3" valign="top">
            <hr style="margin-top:7px;margin-bottom:0px"/>
          </td>
          <td width="10"></td>
          <td width="180" rowspan="3" valign="top">
            <div style="margin-top:20px">
              <g:render template="/ads/resultpage"/>
            </div>
          </td>
        </tr>
        <tr>
          <td width="365"></td>
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

                  <h2><g:message code='result.matches.no.like' /></h2>

                  <g:render template="addterm" model="${[term:cleanTerm]}" />

                  <g:render template="forumlink" />

                </td>
              </tr>
            </table>
          </td>
          <td></td>
          <td valign="top">
            <table>
              <tr>
                <td>

                  <%-- this is specific to German OpenThesaurus, but it doesn't harm for other languages --%>
                  <g:if test="${remoteWordLookup || remoteGenderLookup || remoteMistakeLookup}">
                      <div style="margin-top: 20px">
                  </g:if>
                  <g:if test="${remoteWordLookup}">
                      <div style="margin-bottom: 5px">
                          <a href="${remoteWordLookup.url.encodeAsHTML()}">Tipps zur Rechtschreibung von '${params.q.trim().encodeAsHTML()}'
                          <br/>auf korrekturen.de</a>
                      </div>
                  </g:if>
                  <g:if test="${remoteGenderLookup}">
                      <div style="margin-bottom: 5px">
                          <g:if test="${remoteGenderLookup.metaInfo.contains(' / ')}">
                              Je nach Bedeutung heißt es ${remoteGenderLookup.metaInfo.encodeAsHTML().replaceAll("&lt;i&gt;", "<i>").replaceAll("&lt;/i&gt;", "</i>")}
                              ${remoteGenderLookup.term.encodeAsHTML()}.<br/>Details auf <a href="${remoteGenderLookup.url.encodeAsHTML()}">korrekturen.de</a>.
                          </g:if>
                          <g:else>
                              Der Artikel von ${remoteGenderLookup.term.encodeAsHTML()} ist: ${remoteGenderLookup.metaInfo.encodeAsHTML().replaceAll("&lt;i&gt;", "<i>").replaceAll("&lt;/i&gt;", "</i>")}
                              <br/>Mehr auf <a href="${remoteGenderLookup.url.encodeAsHTML()}">korrekturen.de</a>.
                          </g:else>
                      </div>
                  </g:if>
                  <g:if test="${remoteMistakeLookup}">
                      <div style="margin-bottom: 5px">
                          <a href="${remoteMistakeLookup.url.encodeAsHTML()}">Tipps zu typischen Fehlern mit '${params.q.trim().encodeAsHTML()}'
                          <br/>auf korrekturen.de</a>
                      </div>
                  </g:if>
                  <g:if test="${remoteWordLookup || remoteGenderLookup || remoteMistakeLookup}">
                      <hr style="margin-top:20px" />
                      </div>
                  </g:if>
                  <%-- end of part that's specific to German OpenThesaurus --%>

                  <g:render template="wiktionary"/>

                  <hr style="margin-top:20px" />

                  <g:render template="wikipedia"/>

                  <g:render template="/ads/resultpage_results"/>

                  <hr style="margin-top:20px" />

                  <h2><g:message code="result.external.search" args="${[params.q]}"/></h2>

                  <g:render template="/external_links" model="${[q:params.q]}"/>
                  
                </td>
              </tr>
            </table>
          </td>
        </tr>
        </table>

    </body>
</html>
