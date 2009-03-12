  
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title>Check for invisible concepts</title>
    </head>
    <body>

        <div class="body">
        
            <div class="warning">Please note that this page displays invisible concepts that
            cannot be found using the normal search feature.</div>

            <h1>Check for invisible concepts (${totalMatches} matches)</h1>

            <g:if test="${flash.message}">
	            <div class="message">${flash.message}</div>
            </g:if>
            
            <form method="get">
                Filter by term (use % as joker):
                <input name="filter" value="${params?.filter?.encodeAsHTML()}" />
                <input type="submit" value="Go" />
            </form>
            
            <table>
                <tr>
                    <th width="40%">Preferred Term</th>
                    <th width="40%">Other Terms</th>
                    <th width="10%">Thesaurus</th>
                    <th width="10%">Source</th>
                </tr>
               <g:each in="${synsetList}" status="i" var="synset">
                    <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        <td><g:link controller="synset" action="edit" 
                            id="${synset.id}">${synset?.preferredTerm().toString()?.encodeAsHTML()}</g:link></td>
                        <td>
                            <g:link controller="synset" action="edit" id="${synset.id}">
	                            <g:each in="${synset?.otherTerms()?.sort()}" var="term">
	                                ${term.toString()?.encodeAsHTML()}<br/>
	                            </g:each>
	                        </g:link>
	                    </td>
                        <td>${synset?.section?.toString()?.encodeAsHTML()}</td>
                        <td>${synset?.source?.toString()?.encodeAsHTML()}</td>
                    </tr>
               </g:each>
			</table>
			
            <div class="paginateButtons">
                <g:paginate total="${totalMatches}" params="${params}" />
            </div>
            
            <p>
            <br />
            <g:link controller="correction" action="askDeleteInvisible">Delete
                all Invisible concepts</g:link></p> 
			
        </div>
    </body>
</html>
