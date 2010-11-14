
<%@ page import="com.vionto.vithesaurus.ThesaurusConfigurationEntry" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title>ThesaurusConfigurationEntry List</title>
    </head>
    <body>
        <div class="nav">
            <span class="menuButton"><a class="home" href="${createLinkTo(dir:'')}">Home</a></span>
            <span class="menuButton"><g:link class="create" action="create">New ThesaurusConfigurationEntry</g:link></span>
        </div>
        <div class="body">

            <hr/>

            <h2>ThesaurusConfigurationEntry List</h2>

            <g:if test="${flash.message}">
              <div class="message">${flash.message}</div>
            </g:if>
          
            <div class="colspanlist">
                <table>
                    <thead>
                        <tr>
                        
                   	        <g:sortableColumn property="key" title="Key" />
                        
                   	        <g:sortableColumn property="value" title="Value" />
                        
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${thesaurusConfigurationEntryList}" status="i" var="thesaurusConfigurationEntry">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        
                            <td><g:link action="show" id="${thesaurusConfigurationEntry.id}">${thesaurusConfigurationEntry.key?.encodeAsHTML()}</g:link></td>
                        
                            <td>${thesaurusConfigurationEntry.value?.encodeAsHTML()}</td>
                        
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
            <div class="paginateButtons">
                <g:paginate total="${ThesaurusConfigurationEntry.count()}" />
            </div>
        </div>
    </body>
</html>
