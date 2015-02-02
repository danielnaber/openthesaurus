<%@page import="com.vionto.vithesaurus.*" %>
<html>
    <head>
        <meta name="layout" content="main" />
        <title><g:message code="levellist.title" args="${[termLevel.levelName]}" /></title>
        <meta name="robots" content="noindex, nofollow" />
    </head>
    <body>

        <hr/>

        <p><g:link controller="wordList"><g:message code="word.list.backlink" /></g:link></p>

        <h2><g:message code="levellist.headline" args="${[termLevel.levelName]}"/> (${matchCount})</h2>

        <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
        </g:if>

        <ul>
            <g:each in="${matches}" status="i" var="term">
                <li><g:link controller="synset" action="search" params="${['q': term]}">${term.toString().encodeAsHTML()}</g:link></li>
            </g:each>
        </ul>
        <div class="paginateButtons">
            <g:paginate total="${matchCount}" params="${[max: params.max, offset:params.offset, levelId:params.levelId]}"/>
        </div>

    </body>
</html>
