<%@ page import="com.vionto.vithesaurus.WordGrammar" %>  
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title>WordGrammar List</title>
    </head>
    <body>
        <div class="nav">
            <span class="menuButton"><a class="home" href="${createLinkTo(dir:'')}">Home</a></span>
            <span class="menuButton"><g:link class="create" action="create">New WordGrammar</g:link></span>
        </div>
        <div class="body">

            <hr/>
            <h2>WordGrammar List</h2>

            <g:if test="${flash.message}">
              <div class="message">${flash.message}</div>
            </g:if>

            <div class="colspanlist">
                <table>
                    <thead>
                        <tr>
                        
                   	        <g:sortableColumn property="id" title="Id" />
                        
                   	        <g:sortableColumn property="form" title="Form" />
                        
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${wordGrammarList}" status="i" var="wordGrammar">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        
                            <td><g:link action="show" id="${wordGrammar.id}">${wordGrammar.id?.toString()?.encodeAsHTML()}</g:link></td>
                        
                            <td>${wordGrammar.form?.toString()?.encodeAsHTML()}</td>
                        
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
            <div class="paginateButtons">
                <g:paginate total="${WordGrammar.count()}" />
            </div>
        </div>
    </body>
</html>
