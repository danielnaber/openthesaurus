<%@page import="com.vionto.vithesaurus.*" %>  
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title><g:message code="statistics.title" /></title>
        <meta name="description" content="${message(code:'statistics.description')}" />
    </head>
    <body>

        <hr />

          <h1 style="margin-left: 4px"><g:message code="statistics.headline" /></h1>
    
          <div style="float:left; margin-right: 30px" class="statistics">

              <table width="315" class="statsTable">

                  <tr>
                      <td><h2><g:message code="statistics.general" /></h2></td>
                  </tr>

                  <tr class="prop">
                      <td width="215" valign="top" align="right" class="statName"><g:message code="statistics.synsets" /></td>
                      <td valign="top" class="value"><g:decimal number="${Synset.countByIsVisible(true)}" /></td>
                  </tr>

                  <tr class="prop2">
                      <td valign="top" align="right" class="statName"><g:message code="statistics.terms" /></td>
                      <td valign="top" class="value"><g:decimal number="${Term.countVisibleTerms()}" /></td>
                  </tr>

                  <tr class="prop">
                      <td valign="top" align="right" class="statName"><g:message code="statistics.terms.unique" /></td>
                      <td valign="top" class="value"><g:decimal number="${Term.countVisibleUniqueTerms()}" /></td>
                  </tr>

                  <tr class="prop2">
                      <td valign="top" align="right" class="statName"><g:link controller="association" action="list"><g:message code="statistics.associations" /></g:link></td>
                      <td valign="top" class="value"><g:decimal number="${associationCount}" /></td>
                  </tr>

                  <tr class="prop">
                      <td valign="top" align="right" class="statName"><g:link controller="term" action="antonyms"><g:message code="statistics.antonyms" /></g:link></td>
                      <td valign="top" class="value"><g:decimal number="${TermLink.countByLinkType(TermLinkType.findByLinkName('Antonym'))}" /></td>
                  </tr>

                  <tr class="prop2">
                      <td valign="top" align="right" class="statName"><g:link controller="tag"><g:message code="statistics.tags" /></g:link></td>
                      <td valign="top" class="value"><g:decimal number="${tagCount}" /></td>
                  </tr>

                  <tr class="prop">
                      <td valign="top" align="right" class="statName"><g:message code="statistics.changes_last_7_days" /></td>
                      <td valign="top" class="value"><g:decimal number="${latestChangesAllSections}" /></td>
                  </tr>
                  <tr>
                      <td colspan="2" align="right" class="metaInfo">Stand: <g:formatDate format="dd.MM.yyyy HH:mm" /></td>
                  </tr>
              </table>

          </div>

          <div style="float:left" class="statistics">

              <table width="315" class="statsTable">
                  <tr>
                      <td colspan="2"><h2><g:message code="statistics.top.users" /></h2></td>
                  </tr>
                  <g:each in="${topUsers}" var="topUser" status="i">
                      <g:set var="cssClass" value="${i % 2 == 0 ? 'prop' : 'prop2'}"/>
                      <tr class="${cssClass}">
                          <td align="right" class="statName">
                              <g:if test="${topUser.displayName}">
                                  <g:link controller="user" action="profile" params="${[uid: topUser.userId]}">${topUser.displayName.encodeAsHTML()}</g:link>
                              </g:if>
                              <g:else>
                                  <span class="metaInfo"><g:message code="statistics.anonymous.user" /></span>
                              </g:else>
                          </td>
                          <td class="value"><g:decimal number="${topUser.actions}"/></td>
                      </tr>
                  </g:each>
                  <g:if test="${!session.user}">
                      <tr>
                          <td colspan="2">
                              <div style="margin-top: 10px">
                                  <g:link controller="user" action="login" class="link"
                                          params="${linkParams}"><img align="top" src="${createLinkTo(dir:'images',file:'forum-bubble.png')}" alt="Forum-Icon" />&nbsp;<g:message code="statistics.register" /></g:link>
                              </div>
                          </td>
                      </tr>
                  </g:if>
                  <tr>
                      <td width="185"></td>
                      <td></td>
                  </tr>
              </table>

          </div>
    
          <div style="clear: both"></div>

        <g:render template="/ads/statistics_bottom"/>
        
    </body>
</html>
