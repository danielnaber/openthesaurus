  
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <g:set var="preventSearchFocus" value="true" scope="request" />
        <meta name="layout" content="main" />
        <title><g:message code="user.lost.password.title"/></title>         
    </head>
    <body>

        <hr/>

        <h2><g:message code="user.lost.password.headline"/></h2>

        <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
        </g:if>

        <g:hasErrors bean="${user}">
            <div class="error">
                <g:renderErrors bean="${user}" as="list" />
            </div>
        </g:hasErrors>

        <g:form action="requestPasswordReset" method="post" name="loginform">
            <div class="dialog">
                <table>
                    <tbody>

                        <tr class='prop'>
                            <td valign='top' class='name' colspan="2">
                                <g:message code="user.lost.password.intro"/>
                            </td>
                        </tr>

                        <tr class='prop'>
                            <td valign='top' class='name'>
                                <label for='userId'><g:message code="user.login.form.username"/></label>
                            </td>
                            <td valign='top' class='value'>
                                <input autofocus="" size="40" type="email" placeholder="${message(code:'user.register.email.placeholder')}"
                                       id='userId' name='userId' value="${params.userId?.encodeAsHTML()}" spellcheck="false" required />
                            </td>
                        </tr>

                        <tr>
                            <td>
                            </td>
                            <td>
                                <div class="buttons">
                                    <input class="login submitButton" type="submit" value="${message(code:'user.lost.password.form.submit')}"/>
                                </div>
                            </td>
                        </tr>

                    </tbody>
                </table>
            </div>
        </g:form>
        
        <script type="text/javascript">
        <!--
            document.loginform.userId.focus();
        // -->
        </script>
        
    </body>
</html>
