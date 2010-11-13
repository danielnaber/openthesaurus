<%@page import="com.vionto.vithesaurus.*" %>  
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title>LinkType List</title>
    </head>
    <body>
        <div class="nav">
            <span class="menuButton"><a class="home" href="${createLinkTo(dir:'')}">Home</a></span>
            <span class="menuButton"><g:link class="create" action="create">New LinkType</g:link></span>
        </div>
        <div class="body">

            <hr/>

            <h2>LinkType List</h2>

            <g:if test="${flash.message}">
              <div class="message">${flash.message}</div>
            </g:if>
          
            <div class="colspanlist">
                <table>
                    <thead>
                        <tr>
                        
                   	        <g:sortableColumn property="id" title="Id" />
                        
                   	        <g:sortableColumn property="linkName" title="Link Name" />
                        
                            <g:sortableColumn property="verbName" title="Verb Name" />

                   	        <g:sortableColumn property="otherDirectionLinkName" title="Other Direction Link Name" />

                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${linkTypeList}" status="i" var="linkType">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        
                            <td><g:link action="show" id="${linkType.id}">${linkType.id?.toString()?.encodeAsHTML()}</g:link></td>
                        
                            <td>${linkType.linkName?.toString()?.encodeAsHTML()}</td>

                            <td>${linkType.verbName?.toString()?.encodeAsHTML()}</td>
                        
                            <td>${linkType.otherDirectionLinkName?.toString()?.encodeAsHTML()}</td>
                        
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
            <div class="paginateButtons">
                <g:paginate total="${LinkType.count()}" />
            </div>
        </div>
    </body>
</html>
