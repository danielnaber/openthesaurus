
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title><g:message code="user.change.password.title"/></title>
    </head>
    <body>

        <div class="body">

            <hr/>

            <h2><g:message code="user.change.password.headline"/></h2>

            <g:if test="${flash.message}">
              <div class="message">${flash.message}</div>
            </g:if>

            <g:form controller="user" method="post">
                <div class="dialog">
                    <table>
                        <tbody>

                            <tr class='prop'>
                                <td valign='top' class='name'>
                                    <g:message code="user.change.user.name"/>
                                </td>
                                <td valign='top' class='value'>
                                    ${user.userId.encodeAsHTML()}
                                </td>
                            </tr>

                            <tr class='prop'>
                                <td valign='top' class='name'>
                                    <g:message code="user.edit.display.name"/>
                                </td>
                                <td valign='top' class='value'>
                                    ${user.realName ? user.realName.encodeAsHTML() : "-"}
                                </td>
                            </tr>

                            <tr class='prop'>
                                <td valign='top' class='name'>
                                    <g:message code="user.change.password.password"/>
                                </td>
                                <td valign='top' class='value'>
                                    <g:passwordField name="password1"/>
                                </td>
                            </tr> 

                            <tr class='prop'>
                                <td valign='top' class='name'>
                                    <g:message code="user.change.password.password.repeat"/>
                                </td>
                                <td valign='top' class='value'>
                                    <g:passwordField name="password2"/>
                                </td>
                            </tr>

                            <tr>
                                <td></td>
                                <td >
                                    <div class="buttons">
                                        <span class="button"><g:actionSubmit  action="doChangePassword" class="save" value="${message(code:'user.change.password.submit')}" /></span>
                                    </div>
                                </td>
                            </tr>

                        </tbody>
                    </table>
                </div>
            </g:form>
        </div>
    </body>
</html>
