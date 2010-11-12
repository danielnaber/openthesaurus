<%@page import="com.vionto.vithesaurus.*" %>  
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title><g:message code="statistics.title" /></title>
    </head>
    <body>

        <hr />
            
          <table style="width:100%" class="statistics">
          <tr>
              <td valign="top">

                  <h2><g:message code="statistics.headline" /></h2>

                  <table>

                      <tr class="prop">
                          <td valign="top" class="name"><g:message code="statistics.synsets" /></td>
                          <td valign="top" class="value"><g:decimal number="${Synset.countByIsVisible(true)}" /></td>
                      </tr>

                      <tr class="prop">
                          <td valign="top" class="name"><g:message code="statistics.terms" /></td>
                          <td valign="top" class="value"><g:decimal number="${Term.count()}" /></td>
                      </tr>

                      <tr class="prop">
                          <td valign="top" class="name"><g:message code="statistics.changes_last_7_days" /></td>
                          <td valign="top" class="value"><g:decimal number="${latestChangesAllSections}" /></td>
                      </tr>

                  </table>
              </td>

            <td>&nbsp;&nbsp;&nbsp;</td>

              <td>

                  <h2><g:message code="statistics.top.users" /></h2>

                  <table>
                  <g:each in="${topUsers}" var="topUser">
                  <tr>
                      <td>
                          <g:if test="${topUser.displayName}">
                              ${topUser.displayName.encodeAsHTML()}
                          </g:if>
                          <g:else>
                              <span class="metaInfo"><g:message code="statistics.anonymous.user" /></span>
                          </g:else>
                      </td>
                      <td>${topUser.actions}</td>
                  </tr>
                  </g:each>
                  </table>
              </td>
          </tr>
          </table>
						
        <g:render template="/ads/statistics_bottom"/>
        
    </body>
</html>
