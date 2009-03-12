  
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title>Check terms</title>
    </head>
    <body>

        <div class="body">

            <h1>Check for uppercase-only terms (${wordList.size()} matches)</h1>

            <g:if test="${flash.message}">
	            <div class="message">${flash.message}</div>
            </g:if>
            
            <table>
                <tr>
                    <th>Term</th>
                </tr>
               <g:each in="${wordList}" status="i" var="word">
                    <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        <td><g:link controller="synset" action="search" 
                            params="[q: word]">${word.toString()?.encodeAsHTML()}</g:link></td>
                    </tr>
               </g:each>
			</table>
			
        </div>
    </body>
</html>
