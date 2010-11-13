<%@page import="com.vionto.vithesaurus.*" %>  
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title>Source List</title>
    </head>
    <body>
        <div class="nav">
            <span class="menuButton"><a class="home" href="${createLinkTo(dir:'')}">Home</a></span>
            <span class="menuButton"><g:link class="create" action="create">New Source</g:link></span>
        </div>
        <div class="body">

            <h1>Source List</h1>

            <g:if test="${flash.message}">
              <div class="message">${flash.message}</div>
            </g:if>

            <div class="colspanlist">
                <table>
                    <thead>
                        <tr>
                        
                   	        <g:sortableColumn property="id" title="Id" />
                        
                   	        <g:sortableColumn property="sourceName" title="Source Name" />
                        
                   	        <g:sortableColumn property="description" title="Description" />
                        
                   	        <g:sortableColumn property="uri" title="Uri" />
                        
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${sourceList}" status="i" var="source">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        
                            <td><g:link action="show" id="${source.id}">${source.id?.toString()?.encodeAsHTML()}</g:link></td>
                        
                            <td>${source.sourceName?.toString()?.encodeAsHTML()}</td>
                        
                            <td>${source.description?.toString()?.encodeAsHTML()}</td>
                        
                            <td>${source.uri?.toString()?.encodeAsHTML()}</td>
                        
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
            <div class="paginateButtons">
                <g:paginate total="${Source.count()}" />
            </div>
        </div>
    </body>
</html>
