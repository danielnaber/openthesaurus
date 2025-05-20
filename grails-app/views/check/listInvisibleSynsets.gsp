  
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title>Check for invisible concepts</title>
    </head>
    <body>

        <div class="body">
            
            <h2>Check for invisible concepts (${totalMatches} matches)</h2>

            <div class="warning">Please note that this page displays invisible concepts that
            cannot be found using the normal search feature.</div>

            <g:if test="${flash.message}">
                <div class="message">${flash.message}</div>
            </g:if>
            
            <form method="get">
                Filter by term (use % as joker):
                <input name="filter" value="${params?.filter?.encodeAsHTML()}" />
                <input type="submit" value="Go" />
            </form>
            
            <ul>
               <g:each in="${synsetList}" status="i" var="synset">
                    <li>
                        <g:link controller="synset" action="edit" 
                            id="${synset.id}">${synset?.toString()?.encodeAsHTML()}</g:link>
                    </li>
               </g:each>
            </ul>

            <div class="paginateButtons">
                <g:paginate total="${totalMatches}" params="${params}" />
            </div>
            
        </div>
    </body>
</html>
