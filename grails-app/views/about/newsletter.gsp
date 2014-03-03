<%@page import="java.text.*" %>
<html>
    <head>
        <meta name="layout" content="main" />
        <g:set var="preventSearchFocus" value="true" scope="request" />
        <title><g:message code="newsletter.title"/></title>
    </head>
    <body>

        <hr />

        <g:if test="${grailsApplication.config.thesaurus.serverId == 'de'}">
            
        <div class="dialog">

            <h2><g:message code="newsletter.headline"/></h2>

            <p>Unser Newsletter informiert in unregelmäßigen Abständen (alle paar Wochen oder Monate) über Neuigkeiten auf OpenThesaurus:</p>

            <form method="post" action="http://lists.berlios.de/mailman/subscribe/openthesaurus-discuss">
                <table>
                    <tbody>
                        <tr>
                            <td><g:message code="user.login.form.username"/></td>
                            <td><input autofocus placeholder="${message(code:'user.register.email.placeholder')}" type="text" name="email" size="30"/></td>
                        </tr>
                        <tr>
                            <td></td>
                            <td><input class="submitButton" type="submit" value="Newsletter abonnieren"/></td>
                        </tr>
                        <tr>
                            <td></td>
                            <td>Zum <a href="https://lists.berlios.de/pipermail/openthesaurus-discuss/">Newsletter-Archiv</a>,
                                zur <a href="https://lists.berlios.de/mailman/listinfo/openthesaurus-discuss">Abmeldung</a>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </form>
            
        </div>

        </g:if>
        <g:else>
    
            (Nothing here yet)
    
        </g:else>

    </body>
</html>
