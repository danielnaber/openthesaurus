
<%@ page import="com.vionto.vithesaurus.TermLevel" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title>TermLevel List</title>
    </head>
    <body>
        <div class="nav">
            <span class="menuButton"><a class="home" href="${createLinkTo(dir:'')}">Home</a></span>
            <span class="menuButton"><g:link class="create" action="create">New TermLevel</g:link></span>
        </div>
        <div class="body">

            <hr/>
            <h2>TermLevel List</h2>

            <g:if test="${flash.message}">
              <div class="message">${flash.message}</div>
            </g:if>

            <div class="list">
                <table>
                    <thead>
                        <tr>
                        
                   	        <g:sortableColumn property="id" title="Id" />
                        
                   	        <g:sortableColumn property="levelName" title="Level Name" />
                        
                   	        <g:sortableColumn property="shortLevelName" title="Short Level Name" />
                        
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${termLevelInstanceList}" status="i" var="termLevelInstance">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        
                            <td><g:link action="show" id="${termLevelInstance.id}">${fieldValue(bean:termLevelInstance, field:'id')}</g:link></td>
                        
                            <td>${fieldValue(bean:termLevelInstance, field:'levelName')}</td>
                        
                            <td>${fieldValue(bean:termLevelInstance, field:'shortLevelName')}</td>
                        
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
            <div class="paginateButtons">
                <g:paginate total="${TermLevel.count()}" />
            </div>
        </div>
    </body>
</html>
