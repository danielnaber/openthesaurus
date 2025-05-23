<!doctype html>
<%@page import="com.vionto.vithesaurus.*" %>
<html>
<head>
    <title><g:message code="homepage.title"/></title>
    <meta name="layout" content="homepage" />
</head>
<body>

<hr style="margin-bottom:16px"/>

<g:if test="${flash.message}">
    <div class="message">${flash.message}</div>
</g:if>

<div style="min-height:250px; margin:0 auto">
    <div id="searchSpace">
        <g:render template="/home/ads"/>
    </div>
</div>


</body>
</html>
