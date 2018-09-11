<%@page import="com.vionto.vithesaurus.*" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title><g:message code="association.title" /></title>
        <meta name="robots" content="noindex, nofollow"/>
    </head>
    <body>

    <main class="main">
        <div class="container">
            <section class="main-content content-page">


        <p><g:link controller="wordList"><g:message code="word.list.backlink" /></g:link></p>

        <h2><g:message code="association.headline" args="${[synsetCount]}" /></h2>

        <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
        </g:if>

        <div class="list">
            <ul>
                <g:each in="${synsets}" var="synset">
                    <g:set var="syn" value="${synset.toShortStringWithShortLevel(5, true).encodeAsHTML()}"/>
                    <g:if test="${synset.terms.size() > 5}">
                        <g:set var="title" value="${synset.toShortStringWithShortLevel(25, true).encodeAsHTML()}"/>
                    </g:if>
                    <g:else>
                        <g:set var="title" value=""/>
                    </g:else>
                    <li title="${title}" style="margin-bottom: 1px"><g:link controller="synset" action="edit" id="${synset.id}">${syn}</g:link>
                        <ul style="margin-bottom: 12px;margin-top: 1px">
                            <g:set var="synsetLinks" value="${new ArrayList(synset.synsetLinks).sort()}"/>
                            <g:each in="${synsetLinks}" var="synsetLink">
                                <g:if test="${synsetLink.linkType == desiredLinkType}">
                                    <g:set var="targetSyn" value="${synsetLink.targetSynset.toShortStringWithShortLevel(5, true).encodeAsHTML()}"/>
                                    <g:if test="${synsetLink.targetSynset.terms.size() > 5}">
                                        <g:set var="title" value="${synsetLink.targetSynset.toShortStringWithShortLevel(25, true).encodeAsHTML()}"/>
                                    </g:if>
                                    <g:else>
                                        <g:set var="title" value=""/>
                                    </g:else>
                                    <li title="${title}" style="margin-top: 1px"><g:link controller="synset" action="edit" 
                                        id="${synsetLink.targetSynset.id}"><span style="color:#333344;font-weight: normal">${targetSyn}</span></g:link></li>
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

            </section>
        </div>
    </main>

    </body>
</html>
