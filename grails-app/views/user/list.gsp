<%@page import="com.vionto.vithesaurus.*" %>  
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title>User List</title>
    </head>
    <body>
        <div class="nav">
            <span class="menuButton"><a class="home" href="${createLinkTo(dir:'')}">Home</a></span>
            <span class="menuButton"><g:link class="create" action="create">New User</g:link></span>
        </div>
        <div class="body">
            <h1>User List</h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <div class="list">
                <table>
                    <thead>
                        <tr>
                        
                   	        <g:sortableColumn property="id" title="Id" />
                        
                   	        <g:sortableColumn property="userId" title="UserID" />
                        
                   	        <g:sortableColumn property="permission" title="Permission" />
                        
                   	        <g:sortableColumn property="creationDate" title="Creation Date" />
                        
                   	        <g:sortableColumn property="lastLoginDate" title="Last Login Date" />
                        
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${userList}" status="i" var="user">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        
                            <td><g:link action="edit" id="${user.id}">${user.id?.toString()?.encodeAsHTML()}</g:link></td>
                        
                            <td><g:link action="edit" id="${user.id}">${user.userId?.toString()?.encodeAsHTML()}</g:link></td>
                        
                            <td>${user.permission?.toString()?.encodeAsHTML()}</td>
                        
                            <td><g:formatDate format="yyyy-MM-dd HH:mm:ss" date="${user.creationDate}"/></td>

                            <td><g:formatDate format="yyyy-MM-dd HH:mm:ss" date="${user.lastLoginDate}"/></td>
                        
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
