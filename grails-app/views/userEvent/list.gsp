<%@page import="com.vionto.vithesaurus.*" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title><g:message code="changelist.title"/></title>
        <meta name="robots" content="noindex, nofollow" />
        <link rel="alternate" type="application/rss+xml" title="<g:message code='rss.title'/>" href="/feed" />
        <script type="text/javascript" src="${createLinkTo(dir:'js',file:'blockies.js')}"></script>
    </head>
    <body>

          <h2><g:message code="changelist.headline"/></h2>

          <g:if test="${flash.message}">
              <div class="message">${flash.message}</div>
          </g:if>

          <g:if test="${user}">
            <g:if test="${user.realName}">
                <g:set var="userName" value="${user.realName.encodeAsHTML()}"/>
            </g:if>
            <g:else>
                <g:set var="userName"><span class="anonUserId">#${user.id}</span></g:set>
            </g:else>
            <h3><g:message code="edit.changelog.user"/> <g:link controller="user" action="profile" params="${[uid:user.id]}">${userName}</g:link>
                (<g:decimal number="${totalMatches}"/> <g:message code="edit.changelog.hits"/>)
                &mdash; <g:link action="list"><g:message code="edit.changelog.reset.filter"/></g:link>
            </h3>
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

                          <th><g:message code='edit.changelog.change'/></th>

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

                          <td valign="top" align="center" rowspan="2">
                              <g:if test="${newEntry}">
                                  <g:link controller="user" action="profile" params="${[uid:userEvent.byUser.id]}">
                                      <g:render template="/identicon" model="${[user: userEvent.byUser, count: i]}"/>
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
                              id="${userEvent.synset.id}">${userEvent.synset?.toShortString(3).toString().encodeAsHTML()}</g:link></td>

                      </tr>
                      <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                          <td></td>
                          <td>${diffs.get(userEvent)
                                  .replaceAll("&lt;br/&gt;", "<br/>")
                                  .replaceAll("&lt;b&gt;", "<b>")
                                  .replaceAll("&lt;/b&gt;", "</b>")
                                  .replace("|", " | ")  /* make text breakable (for mobile) */
                                  .replace("=", "= ")  /* make text breakable (for mobile) */
                                  }
                              <g:if test="${userEvent.changeDesc}">
                                  <br/>
                                  <g:message code='edit.changelog.comment'/> ${userEvent.changeDesc?.toString().encodeAsHTML()}
                              </g:if>
                          </td>
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
            <g:message code="edit.changelog.itemsperpage"/>: <g:select name="max" from="${[10,25,50]}" value="${params.max}"/>
            <g:message code="edit.changelog.jumptopage"/>: <g:textField name="jumpToPage" size="3"/>
            <g:if test="${!user}">
                <g:message code="edit.changelog.hideuser"/>: <g:textField name="hideUsers" size="12" value="${params.hideUsers?.encodeAsHTML()}"/>
            </g:if>
            <g:submitButton name="name" value="${message(code:'edit.changelog.change')}"/>
          </g:form>

          <br/>
          <a href="/feed"><g:message code="changelist.feed"/></a>

    </body>
</html>
