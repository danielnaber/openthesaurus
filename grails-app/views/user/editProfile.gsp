
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <g:set var="preventSearchFocus" value="true" scope="request" />
        <meta name="layout" content="main" />
        <title><g:message code="user.change.profile.title"/></title>
    </head>
    <body>

        <div class="body">

            <hr/>

            <h2><g:message code="user.change.profile.headline"/></h2>

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
                                    <g:message code="user.change.profile.password"/>
                                </td>
                                <td valign='top' class='value'>
                                    <g:passwordField name="password1" autofocus="" /> <span class="metaInfo"><g:message code="user.change.profile.password.hint"/></span>
                                </td>
                            </tr> 

                            <tr class='prop'>
                                <td valign='top' class='name'>
                                    <g:message code="user.change.profile.password.repeat"/>
                                </td>
                                <td valign='top' class='value'>
                                    <g:passwordField name="password2"/> <span class="metaInfo"><g:message code="user.change.profile.password.hint"/></span>
                                </td>
                            </tr>

                            <tr class='prop'>
                                <td valign='top' class='name'>
                                    <g:message code="user.change.profile.description"/>
                                </td>
                                <td valign='top' class='value'>
                                    <textarea maxlength="1000" name="publicIntro" rows="5" cols="50" placeholder="${message(code:'user.change.profile.description.hint')}">${user.publicIntro.encodeAsHTML()}</textarea>
                                </td>
                            </tr>

                            <tr>
                                <td></td>
                                <td >
                                    <div class="buttons">
                                        <span class="button"><g:actionSubmit action="saveProfile" class="submitButton" value="${message(code:'user.change.profile.submit')}" /></span>
                                        &nbsp;&nbsp;&nbsp;
                                        <g:link action="edit"><g:message code="user.change.profile.cancel"/></g:link>
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
