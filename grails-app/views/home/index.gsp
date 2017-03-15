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

<g:if test="${!session.user}">
    <div style="margin-top:60px; text-align: center">
        <div id="desktopAd"><a rel="nofollow" href="https://languagetool.org"><img align="top" src="${resource(dir:'images/ads',file:'ad728x90-lt.jpg')}" alt="ad space"/></a></div>
        <div id="mobileAd"><a rel="nofollow" href="https://languagetool.org"><img align="top" src="${resource(dir:'images/ads',file:'ad350x200-lt.jpg')}" alt="ad space"/></a></div>
        <br><span style="color:#999999">Anzeige</span>
    </div>
    <div style="height:60px">&nbsp;</div>
</g:if>
<g:else>
    <div style="height:100px">&nbsp;</div>
</g:else>

</body>
</html>
