<%@page import="com.vionto.vithesaurus.*" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title><g:message code="association.title" /></title>
        <meta name="robots" content="noindex, nofollow"/>
    </head>
    <body>

        <hr/>

        <p><g:link controller="woerter"><g:message code="word.list.backlink" /></g:link></p>

        <h2><g:message code="association.headline" /></h2>

        <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
        </g:if>

        <div class="list">
            <ul>
                <g:each in="${synsets}" var="synset">
                    <li style="margin-bottom: 1px"><g:link controller="synset" action="edit" id="${synset.id}">${synset.toShortStringWithShortLevel(5, true).encodeAsHTML()}</g:link>
                        <ul style="margin-bottom: 12px;margin-top: 1px">
                            <g:each in="${synset.synsetLinks}" var="synsetLink">
                                <g:if test="${synsetLink.linkType == desiredLinkType}">
                                    <li style="margin-top: 1px">${synsetLink.targetSynset.toShortStringWithShortLevel(5, true).encodeAsHTML()}</li>
                                </g:if>
                            </g:each>
                        </ul>
                    </li>
                </g:each>
            </ul>
        </div>
        
        <div class="paginateButtons">
            <g:paginate total="${synsetCount}" />
        </div>

    </body>
</html>
