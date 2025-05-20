<%@page import="com.vionto.vithesaurus.*" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title><g:message code="by.size.title" /></title>
        <meta name="robots" content="noindex, nofollow"/>
    </head>
    <body>

        <p><g:link controller="wordList"><g:message code="word.list.backlink" /></g:link></p>

        <h2><g:message code="by.size.headline" /></h2>

        <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
        </g:if>

        <div class="list">
            <ul>
                <g:each in="${synsets}" var="synset">
                    <li>
                        ${synset.terms.size()} ${synset.terms.size() == 1 ? 'Wort' : 'Wörter'}:
                        <g:link controller="synset" action="edit" id="${synset.id}">${synset.toShortStringWithShortLevel(15, true).encodeAsHTML()}</g:link>
                    </li>
                </g:each>
            </ul>
        </div>
    
    <div class="paginateButtons">
        <g:paginate total="${totalMatches}" params="${[direction: direction]}" />
    </div>

    </body>
</html>
