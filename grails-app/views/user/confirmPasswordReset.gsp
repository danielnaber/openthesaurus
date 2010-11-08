  
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title><g:message code="user.confirm.password.reset.title"/></title>         
    </head>
    <body>

        <hr/>

        <h2><g:message code="user.confirm.password.reset.headline"/></h2>

        <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
        </g:if>

        <g:hasErrors bean="${user}">
            <div class="errors">
                <g:renderErrors bean="${user}" as="list" />
            </div>
        </g:hasErrors>

        <g:form action="resetPassword" method="post" name="loginform">

        <input type="hidden" name="userId" value="${params.userId.encodeAsHTML()}"/>

        <input type="hidden" name="code" value="${params.code.encodeAsHTML()}"/>


            <div class="dialog">
                <table>
                    <tbody>

                        <tr class='prop'>
                            <td valign='top' class='name'>
                                <label for='userId'><g:message code="user.login.form.username"/></label>
                            </td>
                            <td valign='top' class='value'>
                                <input disabled="disabled" size="40" type="text" id='userId' name='userId' value="${user.userId.encodeAsHTML()}"/>
                            </td>
                        </tr>

                        <tr class='prop'>
                            <td valign='top' class='name'>
                                <label for='password'><g:message code="user.login.form.password"/></label>
                            </td>
                            <td valign='top' class='value'>
                                <input size="40" type="password" id='password1' name='password1' value="${params.password1?.encodeAsHTML()}"/>
                            </td>
                        </tr>

                        <tr class='prop'>
                            <td valign='top' class='name'>
                                <label for='password'><g:message code="user.register.form.password.repeat"/></label>
                            </td>
                            <td valign='top' class='value'>
                                <input size="40" type="password" id='password2' name='password2' value="${params.password2?.encodeAsHTML()}"/>
                            </td>
                        </tr>

                        <tr>
                            <td>
                            </td>
                            <td>
                                <div class="buttons">
                                    <span class="button"><input class="login" type="submit" value="${message(code:'user.confirm.password.reset.form.submit')}"></input></span>
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
