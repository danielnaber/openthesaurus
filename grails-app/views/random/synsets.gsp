<%@page import="com.vionto.vithesaurus.*" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title><g:message code="random.title" /></title>
        <meta name="robots" content="noindex, nofollow"/>
    </head>
    <body>

        <hr/>

        <p><g:link controller="woerter"><g:message code="word.list.backlink" /></g:link></p>

        <h2><g:message code="random.headline" /></h2>

        <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
        </g:if>

        <div class="list">
            <ul>
                <g:each in="${synsets}" status="i" var="synset">
                    <li><g:link controller="synset" action="edit" id="${synset.id}">${synset.toShortStringWithShortLevel(Integer.MAX_VALUE, true).encodeAsHTML()}</g:link>
                        <g:if test="${synset.categoryLinks}">
                            <br/>
                            <span class="metaInfo">Kategorien:</span>
                                <g:each in="${synset.categoryLinks}" var="category">
                                    <g:link controller="term" action="list" params="${[categoryId:category.category.id]}">
                                        <span class="metaInfo lightlink">${category.category.categoryName.encodeAsHTML()}</span></g:link>
                                </g:each>
                        </g:if>
                        <g:if test="${synset.sortedSynsetLinks()}">
                            <br/>
                            <g:each in="${synset.sortedSynsetLinks()}" var="link">
                                <g:set var="linkName" value="${link.linkType.toString().encodeAsHTML()}"/>
                                <span class="metaInfo">${linkName}:</span>
                                    <g:link controller='synset' action='edit' id="${link.targetSynset.id}">
                                        <span class="metaInfo lightlink" style="font-weight: normal">${link.targetSynset.toShortStringWithShortLevel(4, true).encodeAsHTML()}</span></g:link><br/>
                            </g:each>
                        </g:if>
                    </li>
                </g:each>
            </ul>
        </div>
        
        <br/><br/>
        <g:link action="synsets" params="${[time:System.currentTimeMillis()]}"><g:message code="random.reload" /></g:link>

    </body>
</html>
