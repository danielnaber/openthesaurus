<!doctype html>
<%@page import="com.vionto.vithesaurus.*" %>
<html>
<head>
    <title><g:message code="homepage.title"/></title>
    <meta name="layout" content="homepage" />
    <g:if test="${withAd}">
    </g:if>
</head>
<body>

<hr/>

<g:if test="${flash.message}">
    <div class="message">${flash.message}</div>
</g:if>

<g:if test="${!params.test}">
    <g:render template="/home/ads"/>
</g:if>

</body>
</html>
