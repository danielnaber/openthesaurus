<!doctype html>
<%@page import="com.vionto.vithesaurus.*" %>
<html>
<head>
    <title><g:message code="homepage.title"/></title>
    <meta name="layout" content="homepage" />
    <!-- yieldlove -->
    <script type='text/javascript'>
        var yieldlove_site_id = "openthesaurus.de_startseite";
    </script>
    <script type='text/javascript' src='//cdn-a.yieldlove.com/yieldlove-bidder.js?openthesaurus.de_startseite'></script>
    <script async='async' src='https://www.googletagservices.com/tag/js/gpt.js'></script>
    <script>
        var googletag = googletag || {};
        googletag.cmd = googletag.cmd || [];
    </script>
    <!-- yieldlove end -->
</head>
<body>

<hr/>

<g:if test="${flash.message}">
    <div class="message">${flash.message}</div>
</g:if>

<g:render template="/home/ads"/>

</body>
</html>
