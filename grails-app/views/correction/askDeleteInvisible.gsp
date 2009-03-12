<%@page import="com.vionto.vithesaurus.*" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title>Corrections</title>
    </head>
    <body>

        <g:form controller="correction" method="post">

        <div class="body">
            <h1>Delete all ${counter} invisible concepts in Section '${name}'?</h1>
            <g:if test="${flash.message}">
                <div class="message">${flash.message}</div>
            </g:if>
            <div class="buttons">
                <span class="button"><g:actionSubmit action="doDeleteInvisible"
                    value="Delete all invisible concepts" /></span>
            </div>
        </div>

        </g:form>

    </body>
</html>
