<!doctype html>
<%@page import="com.vionto.vithesaurus.*" %>
<html>
<head>
    <title><g:message code="homepage.title"/></title>
    <meta name="layout" content="homepage" />
</head>
<body>

<hr/>

<g:if test="${flash.message}">
    <div class="message">${flash.message}</div>
</g:if>

<g:if test="${params.ad == '1'}">
    <div style="margin-top:20px; text-align: center">
        <a rel="nofollow" href="https://languagetool.org"><img align="top" src="${resource(dir:'images/ads',file:'ad728x90.png')}" alt="ad space"/></a>
        <br><span style="color:#999999">Anzeige</span>
    </div>
    <div style="height:100px">&nbsp;</div>
</g:if>
<g:else>
    <div style="height:100px">&nbsp;</div>
</g:else>

</body>
</html>
