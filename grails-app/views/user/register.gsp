<%@page import="com.vionto.vithesaurus.*" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <g:set var="preventSearchFocus" value="true" scope="request" />
        <meta name="layout" content="main" />
        <title><g:message code="user.register.title"/></title>         
    </head>
    <body>

        <main class="main">
            <div class="container">
                <section class="main-content content-page form-block">
                    <div class="form-block__header">
                        <h1 class="form-block__title">
                            <g:message code="user.register.headline" />
                        </h1>
                        <div class="form-block__description">
                            <g:message code="user.register.intro"/>
                        </div>
                    </div>

                    <g:if test="${flash.message}">
                        <div class="message form-block__message">${flash.message}</div>
                    </g:if>

                    <g:hasErrors bean="${user}">
                        <div class="error form-block__errors">
                            <g:renderErrors bean="${user}" />
                        </div>
                    </g:hasErrors>
                
                    <g:form 
                        action="doRegister" 
                        method="post" 
                        name="loginform" 
                        class="form-block__form"
                    >
                        <div class="form-group">
                            <label for='userId' class="form-group__label">
                                <g:message code="user.login.form.username" />
                            </label>
                            <input 
                                class="form-control"
                                autofocus="" 
                                size="30" 
                                type="email" 
                                placeholder="${message(code:'user.register.email.placeholder')}"
                                id='userId' 
                                name='userId' 
                                value="${params.userId?.encodeAsHTML()}" 
                                required 
                            />
                            <div class="metaInfo form-text">
                                <g:message code="user.register.email.description"/>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for='visibleName' class="form-group__label">
                                <g:message code="user.register.display.name" />
                            </label>
                            <input 
                                class="form-control"
                                size="30" 
                                type="text" 
                                placeholder="${message(code:'user.register.display.name.placeholder')}"
                                id='visibleName' 
                                name='visibleName' 
                                value="${params.visibleName?.encodeAsHTML()}" 
                                required 
                            />
                            <div class="metaInfo form-text">
                                <g:message code="user.register.display.name.description"/>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for='password1' class="form-group__label">
                                <g:message code="user.login.form.password"/>
                            </label>
                            <input 
                                class="form-control"
                                size="30" 
                                type="password" 
                                id='password1' 
                                name='password1' 
                                value="${params.password1?.encodeAsHTML()}" 
                                required 
                            />
                        </div>
                        <div class="form-group">
                            <label for='password2' class="form-group__label">
                                <g:message code="user.register.form.password.repeat" />
                            </label>
                            <input
                                class="form-control"
                                size="30" 
                                type="password" 
                                id='password2' 
                                name='password2' 
                                value="${params.password2?.encodeAsHTML()}" 
                                required 
                            />
                        </div>
                        <div class="form-group form-group--text">
                            <g:checkBox 
                                name="acceptLicense" 
                                checked="${params.acceptLicense == 'on'}" 
                                required="true" 
                            />
                            <label for="acceptLicense">
                                <g:message code="user.register.form.accept.license1" />
                            </label>
                        </div>
                        <div class="form-group form-group--text">
                            <g:checkBox 
                                name="acceptPrivacyPolicy" 
                                checked="${params.acceptLicense == 'on'}" 
                                required="true" 
                            />
                            <label for="acceptPrivacyPolicy">
                                <g:message code="user.register.form.accept.license2" />
                            </label>
                        </div>
                        <g:if test="${ThesaurusConfigurationEntry.findByKey('captcha.question')}">
                            <div class="form-group">
                                <label for='captcha' class="form-group__label">
                                    <g:message code="user.register.form.captcha"/>
                                </label>
                                <div>
                                    ${ThesaurusConfigurationEntry.findByKey('captcha.question').value}
                                    <input 
                                        type="text" 
                                        id="captcha" 
                                        name="cap" 
                                        size="5" 
                                        value="${params.cap?.encodeAsHTML()}" 
                                        required 
                                    />
                                </div>
                            </div>
                        </g:if>
                        <div class="form-group">
                            <button
                                class="button button--primary"
                                type="submit"
                            >${message(code:'user.register.form.submit')}</button>
                        </div>

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
                    </g:form>

                </section>
            </div>
        </main>
    
        <script type="text/javascript">
            document.loginform.userId.focus();
        </script>
    </body>
</html>
