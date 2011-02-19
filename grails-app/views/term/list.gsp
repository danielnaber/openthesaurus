<%@page import="com.vionto.vithesaurus.*" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title><g:message code="a_to_z.title" /></title>
    </head>
    <body>

        <hr/>

        <h2><g:message code="a_to_z.headline" /></h2>

        <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
        </g:if>

        <div class="list">
            <table>
                <tbody>
                <g:each in="${termList}" status="i" var="term">
                    <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">

                        <td><g:link controller="synset" action="search" params="${['q': term]}">${term.toString().encodeAsHTML()}</g:link></td>

                    </tr>
                </g:each>
                </tbody>
            </table>
        </div>
        <div class="paginateButtons">
          <%-- FIXME: count terms! --%>
            <g:paginate total="${Synset.countByIsVisible(true)}" />
        </div>

    </body>
</html>
