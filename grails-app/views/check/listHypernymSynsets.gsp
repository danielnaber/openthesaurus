  
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title>Concepts that are hypernyms</title>
    </head>
    <body>

        <div class="body">

            <h1>Concepts that are hypernyms</h1>

            <g:if test="${flash.message}">
	            <div class="message">${flash.message}</div>
            </g:if>
            
            <table>
                <tr>
                    <th width="45%">Preferred Term</th>
                    <th width="10%">number of hyponyms</th>
                </tr>
               <g:each in="${synsetList}" status="i" var="synset">
                    <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        <td><g:link controller="synset" action="edit" 
                            id="${synset.id}">${synset?.preferredTerm().toString()?.encodeAsHTML()}</g:link></td>
                        <td>${occurences[i]}</td>
                    </tr>
               </g:each>
			</table>
			
			<div class="paginateButtons">
                <g:paginate total="${totalMatches}" />
            </div>

			<div class="paginateButtons">
				<g:form method="get" controller="check" action="listHypernymSynsets">
	                Entries per page:
	                <input type="hidden" name="offset" value="${params.offset}"/> 
	                <input style="width:30px" type="text" name="max" value="${params.max}"/>
	                <g:actionSubmit class="save" value="Change" />
	            </g:form>
            </div>
            
			
        </div>
    </body>
</html>
