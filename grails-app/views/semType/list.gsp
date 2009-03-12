<%@ page import="com.vionto.vithesaurus.SemType" %>  
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title>SemType List</title>
    </head>
    <body>
        <div class="nav">
            <span class="menuButton"><a class="home" href="${createLinkTo(dir:'')}">Home</a></span>
            <span class="menuButton"><g:link class="create" action="create">New SemType</g:link></span>
        </div>
        <div class="body">
            <h1>SemType List</h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <div class="list">
                <table>
                    <thead>
                        <tr>
                        
                   	        <g:sortableColumn property="id" title="Id" />
                        
                   	        <g:sortableColumn property="semType" title="Sem Type" />
                        
                   	        <g:sortableColumn property="categoryType" title="Category Type" />
                        
                   	        <g:sortableColumn property="categoryTypeID" title="Category Type ID" />
                        
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${semTypeList}" status="i" var="semType">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        
                            <td><g:link action="show" id="${semType.id}">${semType.id?.toString()?.encodeAsHTML()}</g:link></td>
                        
                            <td>${semType.semType?.toString()?.encodeAsHTML()}</td>
                        
                            <td>${semType.categoryType?.toString()?.encodeAsHTML()}</td>
                        
                            <td>${semType.categoryTypeID?.toString()?.encodeAsHTML()}</td>
                        
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
            <div class="paginateButtons">
                <g:paginate total="${SemType.count()}" />
            </div>
        </div>
    </body>
</html>
