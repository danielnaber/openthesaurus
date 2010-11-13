<%@page import="com.vionto.vithesaurus.*" %>  
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title>Language List</title>
    </head>
    <body>
        <div class="nav">
            <span class="menuButton"><a class="home" href="${createLinkTo(dir:'')}">Home</a></span>
            <span class="menuButton"><g:link class="create" action="create">New Language</g:link></span>
        </div>
        <div class="body">

            <hr/>

            <h2>Language List</h2>

            <g:if test="${flash.message}">
              <div class="message">${flash.message}</div>
            </g:if>

            <div class="colspanlist">
                <table>
                    <thead>
                        <tr>
                        
                   	        <g:sortableColumn property="id" title="Id" />
                        
                   	        <g:sortableColumn property="longForm" title="Long Form" />
                        
                   	        <g:sortableColumn property="shortForm" title="Short Form" />
                        
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${languageList}" status="i" var="language">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        
                            <td><g:link action="show" id="${language.id}">${language.id?.toString()?.encodeAsHTML()}</g:link></td>
                        
                            <td>${language.longForm?.toString()?.encodeAsHTML()}</td>
                        
                            <td>${language.shortForm?.toString()?.encodeAsHTML()}</td>
                        
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
            <div class="paginateButtons">
                <g:paginate total="${Language.count()}" />
            </div>
        </div>
    </body>
</html>
