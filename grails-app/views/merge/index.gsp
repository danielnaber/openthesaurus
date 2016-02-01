<%@page import="com.vionto.vithesaurus.tools.StringTools; com.vionto.vithesaurus.*" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title><g:message code='edit.merge.title' /></title>
    </head>
    <body>

        <hr />

        <h1 style="margin-bottom:12px"><g:message code='edit.merge.headline'/></h1>
    
        <g:if test="${warning}">

            <g:message code="edit.merge.no.access" args="${[minActions]}"/>
            
        </g:if>
        <g:else>

            <h2><g:message code="edit.merge.group1"/></h2>

            ${synset1.toString()}

            <h2><g:message code="edit.merge.group2"/></h2>

            ${synset2.toString()}

            <p style="margin-top: 15px; font-weight: bold;"><g:message code="edit.merge.warning"/></p>

            <br>
            <form action="doMerge" method="post">
                <input type="hidden" name="synset1" value="${synset1.id}"/>
                <input type="hidden" name="synset2" value="${synset2.id}"/>
                <input type="submit" value="${message(code:'edit.merge.now')}" class="submitButton"/>
            </form>

        </g:else>
    
    </body>
</html>
