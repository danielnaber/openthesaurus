<%@page import="com.vionto.vithesaurus.*" %>  
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title>User List</title>
    </head>
    <body>
        <div class="body">

            <h2>User List (${ThesaurusUser.count()})</h2>

            <g:if test="${flash.message}">
              <div class="message">${flash.message}</div>
            </g:if>

            <div class="colspanlist">
                <table>
                    <thead>
                        <tr>
                           <g:sortableColumn property="realName" title="DisplayName" />
                           <g:sortableColumn property="userId" title="Email" />
                           <g:sortableColumn property="permission" title="Perm" />
                           <g:sortableColumn property="creationDate" title="Registration" />
                           <g:sortableColumn property="confirmationDate" title="Confirmed" />
                           <g:sortableColumn property="lastLoginDate" title="Last Login" />
                           <th>Events</th>
                           <g:sortableColumn property="blocked" title="Blocked" />
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${userList}" status="i" var="user">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                            <td valign="top"><g:link controller="user" action="profile" params="${[uid:user.id]}">${user.realName?.encodeAsHTML()}</g:link></td>
                            <td valign="top"><a href="mailto:${user.userId?.toString()?.encodeAsURL()}">${user.userId?.toString()?.encodeAsHTML()}</a></td>
                            <td valign="top">${user.permission?.toString()?.encodeAsHTML()}</td>
                            <td valign="top"><g:formatDate format="yyyy-MM-dd HH:mm" date="${user.creationDate}"/></td>
                            <td valign="top"><g:formatDate format="yyyy-MM-dd HH:mm" date="${user.confirmationDate}"/></td>
                            <td valign="top"><g:formatDate format="yyyy-MM-dd" date="${user.lastLoginDate}"/></td>
                            <td valign="top" align="right"><g:link controller="userEvent" action="list" params="${[uid:user.id]}">${UserEvent.countByByUser(user)}</g:link></td>
                            <td valign="top">${user.blocked ? "yes" : ""}</td>
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
            <div class="paginateButtons">
                <g:paginate total="${ThesaurusUser.count()}" />
            </div>
        </div>
    </body>
</html>
