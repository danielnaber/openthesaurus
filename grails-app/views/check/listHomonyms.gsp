<%@page import="com.vionto.vithesaurus.*" %>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title>Check Homonyms</title>
    </head>
    <body>

        <div class="body">

            <g:if test="${params['section.id'] != '0'}">
                <h1>Check Homonyms (${homonyms.size()} matches)</h1>
            </g:if>
            <g:else>
                <h1>Check Homonyms</h1>
            </g:else>

            <form method="get">
                <g:select name="section.id" from="${Section.list().sort()}" optionKey="id"
                                value="${params['section.id']}" noSelection="['null':'-all-']" style="width:120px" />
                &nbsp;<label for="caseSwitch"><g:checkBox id="caseSwitch" name="ignoreCase"
                    value="${params.ignoreCase}"/> Include terms that differ only in upper/lowercase</label>
                &nbsp;
                <input type="submit" value="Go" />
            </form>
            
            
            <g:if test="${flash.message}">
	            <div class="message">${flash.message}</div>
            </g:if>
            
            <g:if test="${params['section.id'] == '0'}">
                Please select a thesaurus for homonym detection.
            </g:if>
            <g:else>
	            <table>
	                <tr>
	                    <th>Term</th>
	                    <th>Occurences</th>
	                </tr>
	                <g:each in="${homonyms}" status="i" var="word">
	                    <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
	                        <td>
	                            <g:if test="${params['section.id']}">
	                                <g:link controller="synset" action="search" 
	                                  params="[q: word, 'section.id': params['section.id']]">${word.encodeAsHTML()}</g:link>
	                            </g:if>
	                            <g:else>
	                                <g:link controller="synset" action="search" 
	                                  params="[q: word]">${word.encodeAsHTML()}</g:link>
	                            </g:else>
	                        </td>
	                        <td>${homonymCounts.get(i).toString()?.encodeAsHTML()}</td>
	                    </tr>
	                </g:each>
	            </table>
            </g:else>
            
        </div>
    </body>
</html>
