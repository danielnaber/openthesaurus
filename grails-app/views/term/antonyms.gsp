<%@page import="com.vionto.vithesaurus.*" %>
<html>
    <head>
        <meta name="layout" content="main" />
        <title><g:message code="antonyms.title" /></title>
    </head>
    <body>

        <hr/>

        <p><g:link controller="woerter"><g:message code="word.list.backlink" /></g:link></p>

        <h2><g:message code="antonyms.headline" /> (${matchCount})</h2>

        <div class="list">
            <table>
                <tbody>
                <g:each in="${termLinks}" var="termLink">
                    <tr>
                        <td style="padding: 2px">
                          <g:link controller="term" action="edit" id="${termLink.term.id}">${termLink.term.encodeAsHTML()}</g:link> ~
                          <g:link controller="term" action="edit" id="${termLink.targetTerm.id}">${termLink.targetTerm.encodeAsHTML()}</g:link>
                        </td>
                    </tr>
                </g:each>
                </tbody>
            </table>
        </div>

        <div class="paginateButtons">
            <g:paginate total="${matchCount}"/>
        </div>

    </body>
</html>
