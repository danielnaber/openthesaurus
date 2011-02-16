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

          <g:if test="${params.userId}">
            <p>Gefiltert: nur Benutzer ${params.userId.encodeAsHTML()}</p>
          </g:if>

          <g:if test="${session.user?.permission == 'admin'}">
              <form action="list" method="get" style="margin-bottom: 10px">
                <%-- TODO: i18n: Filter by user or change description (use % as joker): --%>
                  Nach Benutzer-ID suchen:
                  <input name="userId" value="${params?.userId?.encodeAsHTML()}" />
                  <input type="submit" value="Suchen" />
              </form>
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

                          <g:sortableColumn property="creationDate" title="${message(code:'changelist.column.date')}"
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
                      <tr class="${(i % 2) == 0 ? 'odd' : 'even'}" style="border-top-width: 1px; border-top-style: solid; border-top-color: #aaa;">

                          <td><g:formatDate format="yyyy-MM-dd'&nbsp;'HH:mm" date="${userEvent.creationDate}"/></td>

                          <td>${userEvent.byUser?.realName?.encodeAsHTML()}</td>

                          <td><g:link controller="synset" action="edit"
                              id="${userEvent.synset.id}">${userEvent.synset?.toShortString(3).toString()?.encodeAsHTML()}</g:link></td>

                          <td>${userEvent.changeDesc?.toString()?.encodeAsHTML()}</td>

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
            <g:if test="${params.userId}">
              <g:hiddenField name="userId" value="${params.userId.encodeAsHTML()}"/>
            </g:if>
            <g:hiddenField name="offset" value="${params.offset}"/>
            Einträge pro Seite: <g:select name="max" from="${[10,25,50]}" value="${params.max}"/>
            Springen zu Seite: <g:textField name="jumpToPage" size="3"/>
            <g:submitButton name="name" value="Ändern"/>
          </g:form>

    </body>
</html>
