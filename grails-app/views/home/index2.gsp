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

<div style="min-height:250px; margin:0 auto">
    <div style="float: right; width: 300px; margin-right: 70px" id="moreSpace">
        <div style="position: fixed; width: 200px; height: 250px;">
            <g:render template="/synset/newad"/>
        </div>
    </div>
    <div id="searchSpace"></div>
</div>

</body>
</html>
