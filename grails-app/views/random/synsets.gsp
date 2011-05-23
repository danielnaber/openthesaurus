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
                    <li><g:link controller="synset" action="edit" id="${synset.id}">${synset.toShortStringWithShortLevel(Integer.MAX_VALUE, true).encodeAsHTML()}</g:link></li>
                </g:each>
            </ul>
        </div>
        
        <br/><br/>
        <g:link action="synsets" params="${[time:System.currentTimeMillis()]}"><g:message code="random.reload" /></g:link>

    </body>
</html>
