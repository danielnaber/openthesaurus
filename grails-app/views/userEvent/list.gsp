<%@page import="com.vionto.vithesaurus.*" %>  
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title><g:message code="changelist.title"/></title>
        <meta name="description" content="Liste der Änderungen an den OpenThesaurus-Daten, die von der Community vorgenommen wurden."/>
        <meta name="robots" content="noindex, nofollow" />
    </head>
    <body>

        <hr />

          <h2><g:message code="changelist.headline"/></h2>

          <g:if test="${flash.message}">
              <div class="message">${flash.message}</div>
          </g:if>

          <g:if test="${user}">
            <g:if test="${user.realName}">
                <h3>von Benutzer ${user.realName.encodeAsHTML()} (<g:decimal number="${totalMatches}"/> Treffer)</h3>
            </g:if>
            <g:else>
                <h3>von Benutzer <span class="anonUserId">#${user.id}</span> (<g:decimal number="${totalMatches}"/> Treffer)</h3>
            </g:else>
          </g:if>

          <g:render template="navigation"/>

          <div class="colspanlist">
              <table>
                  <thead>
                      <tr>

                          <%
                          // workaround for http://jira.codehaus.org/browse/GRAILS-3042:
                          filteredParams = params.findAll { entry, val -> entry != 'sort'}
                          %>

                          <g:sortableColumn style="width:110px" property="creationDate" title="${message(code:'changelist.column.date')}"
                              params="${filteredParams}"/>

                          <g:sortableColumn property="byUser" title="${message(code:'changelist.column.user')}"
                              params="${filteredParams}"/>

                          <th></th>

                          <g:sortableColumn property="changeDesc" title="${message(code:'changelist.column.comment')}"
                              params="${filteredParams}"/>

                      </tr>
                  </thead>
                  <tbody>
                  <g:each in="${userEventList}" status="i" var="userEvent">
                      <g:if test="${prevSynsetId != userEvent.synset.id || prevUserId != userEvent.byUser.id}">
                          <g:set var="newEntry" value="${true}"/>
                      </g:if>
                      <g:else>
                          <g:set var="newEntry" value="${false}"/>
                      </g:else>
                      <g:set var="prevSynsetId" value="${userEvent.synset.id}"/>
                      <g:set var="prevUserId" value="${userEvent.byUser.id}"/>
                      <tr class="${(i % 2) == 0 ? 'odd' : 'even'}" style="${newEntry ? 'border-top-width: 1px; border-top-style: solid; border-top-color: #aaa;' : ''}">

                          <td valign="top">
                              <g:if test="${newEntry}">
                                  <g:formatDate format="yyyy-MM-dd" date="${userEvent.creationDate}"/>
                                  <span class="metaInfo"><g:formatDate format="HH:mm" date="${userEvent.creationDate}"/></span>
                              </g:if>
                          </td>

                          <td valign="top">
                              <g:if test="${newEntry}">
                                  <g:link params="${[uid:userEvent.byUser.id]}">
                                      <g:if test="${userEvent.byUser.realName}">
                                          ${userEvent.byUser.realName.encodeAsHTML()}
                                      </g:if>
                                      <g:else>
                                          <span class="anonUserId">#${userEvent.byUser.id}</span>
                                      </g:else>
                                  </g:link>
                              </g:if>
                          </td>

                          <td valign="top"><g:link controller="synset" action="edit"
                              id="${userEvent.synset.id}">${userEvent.synset?.toShortString(3).toString()}</g:link></td>

                          <td valign="top">${userEvent.changeDesc?.toString()?.encodeAsHTML()}</td>

                      </tr>
                      <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                          <td></td>
                          <td></td>
                          <td>${diffs.get(userEvent)}</td>
                      </tr>
                  </g:each>
                  </tbody>
              </table>
          </div>

          <g:render template="navigation"/>

          <g:form style="margin-top:15px">
            <g:if test="${user}">
              <g:hiddenField name="uid" value="${user.id}"/>
            </g:if>
            <g:hiddenField name="offset" value="${params.offset}"/>
            Einträge pro Seite: <g:select name="max" from="${[10,25,50]}" value="${params.max}"/>
            Springen zu Seite: <g:textField name="jumpToPage" size="3"/>
            <g:submitButton name="name" value="Ändern"/>
          </g:form>

    </body>
</html>
