<!doctype html>
<%@page import="com.vionto.vithesaurus.*" %>
<g:javascript library="prototype" />
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

</body>
</html>
