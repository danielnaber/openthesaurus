  
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title>Check for empty concepts</title>
    </head>
    <body>

        <div class="body">

            <h1>Check for empty concepts (${synsetList.size()} matches)</h1>

            <g:if test="${flash.message}">
	            <div class="message">${flash.message}</div>
            </g:if>
            
            <table>
                <tr>
                    <th width="45%">Preferred Term</th>
                    <th width="10%">Source</th>
                </tr>
               <g:each in="${synsetList}" status="i" var="synset">
                    <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        <td><g:link controller="synset" action="edit" 
                            id="${synset.id}">${synset?.preferredTerm().toString()?.encodeAsHTML()}</g:link></td>
                        <td>${synset?.source?.toString()?.encodeAsHTML()}</td>
                    </tr>
               </g:each>
			</table>
			
        </div>
    </body>
</html>
