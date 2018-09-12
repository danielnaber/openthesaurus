<%@page import="com.vionto.vithesaurus.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title><g:message code="homepage.title"/></title>
    <meta name="layout" content="homepage" />
    <g:if test="${!session.user}">
        <script async='async' src='https://www.googletagservices.com/tag/js/gpt.js'></script>
        <script>
            var googletag = googletag || {};
            googletag.cmd = googletag.cmd || [];
        </script>
    </g:if>
</head>
<body>

<main class="main">
    
</main>

<g:render template="ad"/>

</body>
</html>