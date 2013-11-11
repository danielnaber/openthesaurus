  
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <g:set var="preventSearchFocus" value="true" scope="request" />
        <title><g:message code="user.login.title"/></title>         
    </head>
    <body>

        <hr/>

        <h2><g:message code="user.login.headline"/></h2>

        <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
        </g:if>

        <g:hasErrors bean="${user}">
            <div class="errors">
                <g:renderErrors bean="${user}" as="list" />
            </div>
        </g:hasErrors>

        <g:form action="login" method="post" name="loginform">
            <input type="hidden" name="returnUrl" value="${params.returnUrl?.encodeAsHTML()}"/>
            <div class="dialog">
                <table>
                    <tbody>

                        <tr class='prop'>
                            <td valign='top' class='name' colspan="2">
                                <g:message code="user.login.register"/>
                            </td>
                        </tr>

                        <tr class='prop'>
                            <td valign='top' class='name'>
                                <label for='userId'><g:message code="user.login.form.username"/></label>
                            </td>
                            <td valign='top' class='value'>
                                <%-- not using type="email" because of user 'admin'... --%>
                                <input autofocus size="30" type="text" placeholder="${message(code:'user.register.email.placeholder')}" spellcheck="false"
                                       id='userId' name='userId' value="${params.userId?.encodeAsHTML()}" required/>
                            </td>
                        </tr>

                        <tr class='prop'>
                            <td valign='top' class='name'>
                                <label for='password'><g:message code="user.login.form.password"/></label>
                            </td>
                            <td valign='top' class='value'>
                                <input size="30" type="password" id='password' name='password' value="" required/><br/>
                                <div style="margin-top: 5px"><g:message code="user.login.forgot.password"/></div>
                            </td>
                        </tr>

                        <tr class='prop'>
                            <td valign='top' class='name'>
                            </td>
                            <td valign='top' class='value'>
                                <input type="checkbox" name='logincookie' id='logincookie' />&nbsp;<label for='logincookie'><g:message code="user.login.form.logincookie"/></label>
                            </td>
                        </tr>

                        <tr>
                            <td>
                            </td>
                            <td>
                                <div class="buttons">
                                    <input class="login submitButton" type="submit" value="${message(code:'user.login.form.submit')}"/>
                                </div>
                            </td>
                        </tr>

                    </tbody>
                </table>
            </div>
        </g:form>

    </body>
</html>
