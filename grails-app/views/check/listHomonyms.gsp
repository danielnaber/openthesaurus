<%@page import="com.vionto.vithesaurus.*" %>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title>Check Homonyms</title>
    </head>
    <body>

        <div class="body">
            
            <hr/>

            <g:if test="${params['section.id'] != '0'}">
                <h2>Check Homonyms (${homonyms.size()} matches)</h2>
            </g:if>
            <g:else>
                <h2>Check Homonyms</h2>
            </g:else>
            

            <form method="get">
                Maximum: <g:textField name="limit" value="${limit}"/> words
                <input type="submit" value="Go" />
            </form>


            <g:if test="${flash.message}">
                <div class="message">${flash.message}</div>
            </g:if>
            
            <table>
                <tr>
                    <th>Term</th>
                    <th>&nbsp;</th>
                    <th>Occurrences</th>
                </tr>
                <g:each in="${homonyms}" status="i" var="word">
                    <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        <td>
                            <g:link controller="synset" action="search" 
                              params="[q: word]">${word.encodeAsHTML()}</g:link>
                        </td>
                        <td></td>
                        <td>${homonymCounts.get(i).toString()?.encodeAsHTML()}</td>
                    </tr>
                </g:each>
            </table>
            
        </div>
    </body>
</html>
