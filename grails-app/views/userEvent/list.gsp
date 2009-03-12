<%@page import="com.vionto.vithesaurus.*" %>  
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title>UserEvent List</title>
    </head>
    <body>
        <div class="nav">
            <span class="menuButton"><a class="home" href="${createLinkTo(dir:'')}">Home</a></span>
        </div>
        <div class="body">
            
            <h1>UserEvent List (${totalMatches} matches)</h1>
            
            <g:if test="${flash.message}">
                    <div class="message">${flash.message}</div>
            </g:if>
            
            <form method="get">
                Filter by user or change description (use % as joker):
                <input name="filter" value="${params?.filter?.encodeAsHTML()}" />
                <input type="submit" value="Go" />
            </form>
            
            <div class="colspanlist">
                <table>
                    <thead>
                        <tr>
                        
                            <%
                            // workaround for http://jira.codehaus.org/browse/GRAILS-3042:
                            filteredParams = params.findAll { entry, val -> entry != 'sort'}
                            %>
                        
                            <g:sortableColumn property="creationDate" title="Date" 
                                params="${filteredParams}"/>
                        
                            <th>Concept</th>

                            <g:sortableColumn property="byUser" title="User"
                                params="${filteredParams}"/>
                   	    
                            <g:sortableColumn property="ipAddress" title="IP Address"
                                params="${filteredParams}"/>
                        
                            <g:sortableColumn property="changeDesc" title="Change Description"
                                params="${filteredParams}"/>
                        
                            <th>Type</th>

                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${userEventList}" status="i" var="userEvent">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        
                            <td><g:formatDate format="yyyy-MM-dd HH:mm:ss" date="${userEvent.creationDate}"/></td>

                            <td><g:link controller="synset" action="edit" 
                                id="${userEvent.synset.id}">${userEvent.synset?.toShortString(3).toString()?.encodeAsHTML()}</g:link></td>

                            <td>${userEvent.byUser?.toString()?.encodeAsHTML()}</td>
                        
                            <td>${userEvent.ipAddress?.toString()?.encodeAsHTML()}</td>
                        
                            <td>${userEvent.changeDesc?.toString()?.encodeAsHTML()}</td>
                            
                            <td>${typeNames.get(userEvent)}</td>
                                
                        </tr>
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                            <td></td>
                            <td colspan="6">${diffs.get(userEvent)}</td>
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
            <div class="paginateButtons">
                <g:paginate total="${totalMatches}" params="${params}" />
            </div>
        </div>
    </body>
</html>
