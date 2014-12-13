<%@page import="com.vionto.vithesaurus.*" %>
<html>
<head>
    <title>Tag Words - OpenThesaurus</title>
    <meta name="layout" content="main" />
    <g:render template="/taggingIncludes"/>
</head>
<body>

<hr/>

<h2>Tag Words</h2>

<g:if test="${flash.message}">
    <div class="message">${flash.message}</div>
</g:if>

<g:form action="prepareTagging" method="get" style="width:400px">
    In all words that match regular expression <input name="pattern"/>, remove
    the text matched by the regular expression and add tag:<br/>
    <input id="tags" name="tags" type="text" value=""/><br/>
    <input type="submit" value="Continue...">
</g:form>

</body>
</html>
