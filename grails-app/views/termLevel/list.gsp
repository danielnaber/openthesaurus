
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
                            <th></th>
                        
                            <g:sortableColumn property="levelName" title="Level Name" />
                            <th></th>
                        
                            <g:sortableColumn property="shortLevelName" title="Short Level Name" />
                            <th></th>
                        
                            <g:sortableColumn property="sortValue" title="Sort Value" />
                        
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${termLevelInstanceList}" status="i" var="termLevelInstance">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        
                            <td>${fieldValue(bean:termLevelInstance, field:'id')}</td>
                            <td></td>
                        
                            <td><g:link action="show" id="${termLevelInstance.id}">${fieldValue(bean:termLevelInstance, field:'levelName')}</g:link></td>
                            <td></td>
                        
                            <td>${fieldValue(bean:termLevelInstance, field:'shortLevelName')}</td>
                            <td></td>
                            
                            <td>${fieldValue(bean:termLevelInstance, field:'sortValue')}</td>
                        
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
