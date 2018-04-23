<%@page import="java.text.*" %>
<html>
    <head>
        <meta name="layout" content="main" />
        <g:set var="preventSearchFocus" value="true" scope="request" />
        <title><g:message code="newsletter.title"/></title>
    </head>
    <body>

    <main class="main">
        <div class="container">
            <section class="main-content content-page">

                <h2><g:message code="newsletter.headline"/></h2>

                <p>Unser Newsletter informiert in unregelmäßigen Abständen (alle paar Wochen oder Monate) über Neuigkeiten auf OpenThesaurus.
                Wenn Sie den Newsletter abonnieren, stimmen Sie unserer <g:link action="imprint">Datenschutzerklärung</g:link> zu:</p>

                <form action="https://eu1.cleverreach.com/f/46260-126218/wcs/" method="post" target="_blank">
                    <table>
                        <tbody>
                        <tr>
                            <td><g:message code="user.login.form.username"/></td>
                            <td><input autofocus placeholder="${message(code:'user.register.email.placeholder')}"
                                       id="text2567502" name="email" value="" type="text" size="30"/></td>
                        </tr>
                        <tr>
                            <td></td>
                            <td><button class="submitButton" type="submit">Newsletter abonnieren</button></td>
                        </tr>
                        </tbody>
                    </table>
                </form>

            </section>
        </div>
    </main>
    
    </body>
</html>
