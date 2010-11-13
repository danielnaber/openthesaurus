
<%@ page import="com.vionto.vithesaurus.TermLinkType" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title>TermLinkType List</title>
    </head>
    <body>
        <div class="nav">
            <span class="menuButton"><a class="home" href="${createLinkTo(dir:'')}">Home</a></span>
            <span class="menuButton"><g:link class="create" action="create">New TermLinkType</g:link></span>
        </div>
        <div class="body">

            <hr/>

            <h2>TermLinkType List</h2>

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
                    <g:each in="${termLinkTypeInstanceList}" status="i" var="termLinkTypeInstance">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        
                            <td><g:link action="show" id="${termLinkTypeInstance.id}">${fieldValue(bean:termLinkTypeInstance, field:'id')}</g:link></td>
                        
                            <td>${fieldValue(bean:termLinkTypeInstance, field:'linkName')}</td>
                        
                            <td>${fieldValue(bean:termLinkTypeInstance, field:'verbName')}</td>
                        
                            <td>${fieldValue(bean:termLinkTypeInstance, field:'otherDirectionLinkName')}</td>
                        
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
            <div class="paginateButtons">
                <g:paginate total="${TermLinkType.count()}" />
            </div>
        </div>
    </body>
</html>
