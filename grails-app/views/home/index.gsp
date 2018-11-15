<!doctype html>
<%@page import="com.vionto.vithesaurus.*" %>
<html>
<head>
    <title><g:message code="homepage.title"/></title>
    <meta name="layout" content="homepage" />
    <script async='async' src='https://www.googletagservices.com/tag/js/gpt.js'></script>
    <script>
        var googletag = googletag || {};
        googletag.cmd = googletag.cmd || [];
    </script>
</head>
<body>

<hr/>

<g:if test="${flash.message}">
    <div class="message">${flash.message}</div>
</g:if>

<g:render template="/home/ads"/>

</body>
</html>
