<%@page import="com.vionto.vithesaurus.*" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <g:set var="preventSearchFocus" value="true" scope="request" />
        <meta name="layout" content="main" />
        <title><g:message code="user.register.title"/></title>         
    </head>
    <body>

        <h2><g:message code="user.register.headline"/></h2>

        <p><g:message code="user.register.intro"/></p>

        <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
        </g:if>

        <g:hasErrors bean="${user}">
          <div class="error">
              <g:renderErrors bean="${user}" />
          </div>
        </g:hasErrors>
    
        <g:form action="doRegister" method="post" name="loginform">
            <div class="dialog">
                <table>
                    <tbody>

                        <tr class='prop'>
                            <td valign='top' class='name'>
                                <label for='userId'><g:message code="user.login.form.username"/></label>
                            </td>
                            <td valign='top' class='value'>
                                <input autofocus="" type="email" placeholder="${message(code:'user.register.email.placeholder')}"
                                       id='userId' name='userId' value="${params.userId?.encodeAsHTML()}" required />
                                <br />
                                <span class="metaInfo"><g:message code="user.register.email.description"/></span>
                            </td>
                        </tr>

                        <tr class='prop'>
                            <td valign='top' class='name'>
                                <label for='visibleName'><g:message code="user.register.display.name"/></label>
                            </td>
                            <td valign='top' class='value'>
                                <input type="text" placeholder="${message(code:'user.register.display.name.placeholder')}"
                                       id='visibleName' name='visibleName' value="${params.visibleName?.encodeAsHTML()}" required />
                                <br />
                                <span class="metaInfo"><g:message code="user.register.display.name.description"/></span>
                            </td>
                        </tr>

                        <tr class='prop'>
                            <td valign='top' class='name'>
                                <label for='password1'><g:message code="user.login.form.password"/></label>
                            </td>
                            <td valign='top' class='value'>
                                <input type="password" id='password1' name='password1' value="${params.password1?.encodeAsHTML()}" required />
                            </td>
                        </tr>

                        <tr class='prop'>
                            <td valign='top' class='name'>
                                <label for='password2'><g:message code="user.register.form.password.repeat"/></label>
                            </td>
                            <td valign='top' class='value'>
                                <input type="password" id='password2' name='password2' value="${params.password2?.encodeAsHTML()}" required />
                            </td>
                        </tr>

                        <tr class='prop'>
                            <td valign='top' class='name'>
                            </td>
                            <td valign='top' class='value'>
                                <table>
                                    <tr>
                                        <td valign="top"><g:checkBox name="acceptLicense" checked="${params.acceptLicense == 'on'}" required="true" /></td>
                                        <td valign="top"><label for="acceptLicense"><g:message code="user.register.form.accept.license1"/></label></td>
                                    </tr>
                                </table>
                            </td>
                        </tr>

                        <tr class='prop'>
                            <td valign='top' class='name'>
                            </td>
                            <td valign='top' class='value'>
                                <table>
                                    <tr>
                                        <td valign="top"><g:checkBox name="acceptPrivacyPolicy" checked="${params.acceptLicense == 'on'}" required="true" /></td>
                                        <td valign="top"><label for="acceptPrivacyPolicy"><g:message code="user.register.form.accept.license2"/></label></td>
                                    </tr>
                                </table>
                            </td>
                        </tr>

                        <g:if test="${ThesaurusConfigurationEntry.findByKey('captcha.question')}">
                            <tr class='prop'>
                                <td valign='top' class='name' colspan="2">
                                    <label for='captcha'><b><g:message code="user.register.form.captcha"/></b></label>
                                </td>
                            </tr>
                            <tr>
                                <td>${ThesaurusConfigurationEntry.findByKey('captcha.question').value}</td>
                                <td valign='top' class='value'>
                                    <input type="text" id="captcha" name="cap" size="5" value="${params.cap?.encodeAsHTML()}" required /></td>
                            </tr>
                        </g:if>


                        <tr>
                            <td>
                            </td>
                            <td>
                                <div class="buttons">
                                    <input class="login submitButton" type="submit" value="${message(code:'user.register.form.submit')}"/>
                                </div>
                            </td>
                        </tr>

                        <%--
                        <g:if test="${message(code:'user.register.form.captcha.question')}">
                            <tr class='prop'>
                                <td valign='top' class='name'>
                                    <label for='password'><g:message code="user.register.form.captcha.question"/></label>
                                </td>
                                <td valign='top' class='value'>
                                    <input size="40" type="text" id='captcha' name='captcha' value=""/>
                                </td>
                            </tr>
                        </g:if>
                        --%>

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
