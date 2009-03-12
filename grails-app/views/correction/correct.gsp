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
            <h1>Corrections</h1>
            <g:if test="${flash.message}">
                <div class="message">${flash.message}</div>
            </g:if>
            <div class="buttons">
                <span class="button"><g:actionSubmit action="${action}"
                    value="${name}" /></span>
            </div>
        </div>

        </g:form>
        
    </body>
</html>
