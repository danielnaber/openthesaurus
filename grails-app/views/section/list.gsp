<%@ page import="com.vionto.vithesaurus.Section" %>  
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title>Thesauri List</title>
    </head>
    <body>
        <div class="nav">
            <span class="menuButton"><a class="home" href="${createLinkTo(dir:'')}">Home</a></span>
            <span class="menuButton"><g:link class="create" action="create">New Thesaurus</g:link></span>
        </div>
        <div class="body">

            <hr/>
          
            <h2>Thesauri List</h2>
            
            <g:if test="${flash.message}">
                <div class="message">${flash.message}</div>
            </g:if>
            
            <div class="colspanlist">
                <table>
                    <thead>
                        <tr>
                        
                   	        <g:sortableColumn property="sectionName" title="Section Name" />

                            <g:sortableColumn property="priority" title="Sort Priority" />
                        
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${sectionList}" status="i" var="section">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        
                            <td><g:link action="show" id="${section.id}">${section.sectionName?.toString()?.encodeAsHTML()}</g:link></td>

                            <td>${section.priority?.encodeAsHTML()}</td>
                        
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
            <div class="paginateButtons">
                <g:paginate total="${Section.count()}" />
            </div>
        </div>
    </body>
</html>
