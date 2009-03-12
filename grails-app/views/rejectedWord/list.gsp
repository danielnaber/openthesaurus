
<%@ page import="com.vionto.vithesaurus.RejectedWord" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title>Rejected Word List</title>
    </head>
    <body>
        <div class="nav">
            <span class="menuButton"><a class="home" href="${createLinkTo(dir:'')}">Home</a></span>
            <span class="menuButton"><g:link class="create" action="create">New RejectedWord</g:link></span>
        </div>
        <div class="body">
        
            <h1>Rejected Word List</h1>
            
            <p><g:link controller="synsetSuggestion">Also see the list of suggested concepts.</g:link></p>
            <br/>
            
            <g:if test="${flash.message}">
                <div class="message">${flash.message}</div>
            </g:if>
            
            <div class="list">
                <table>
                    <thead>
                        <tr>
                        
                            <g:sortableColumn property="word" title="Word" />

                   	        <g:sortableColumn property="rejectionDate" title="Rejection Date" />
                        
                   	        <th>User</th>
                   	    
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${rejectedWordList}" status="i" var="rejectedWord">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        
                            <td><g:link action="edit" id="${rejectedWord.id}">${rejectedWord.word?.encodeAsHTML()}</g:link></td>
                        
                            <td>${rejectedWord.rejectionDate?.encodeAsHTML()}</td>
                        
                            <td>${rejectedWord.user?.encodeAsHTML()}</td>
                        
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
            <div class="paginateButtons">
                <g:paginate total="${RejectedWord.count()}" />
            </div>
        </div>
    </body>
</html>
