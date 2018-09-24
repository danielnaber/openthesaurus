  
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <g:set var="preventSearchFocus" value="true" scope="request" />
        <title><g:message code="user.login.title"/></title>         
    </head>
    <body>
        <main class="main">
            <div class="container">
                <section class="main-content content-page form-block">
                    <div class="form-block__header">
                        <h1 class="form-block__title">
                            <g:message code="user.login.headline" />
                        </h1>
                        <g:if test="${flash.message}">
                            <div class="message form-block__message">${flash.message}</div>
                        </g:if>
                        <g:hasErrors bean="${user}">
                            <div class="errors form-block__errors">
                                <g:renderErrors bean="${user}" as="list" />
                            </div>
                        </g:hasErrors>
                        <g:if test="${grailsApplication.config.thesaurus.readOnly == 'true'}">
                            <div class="form-block__description">
                                <g:message code="server.read.only.no.login" />
                            </div>
                        </g:if>
                        <g:else>
                            <div class="form-block__description">
                                <g:message code="user.login.register" />
                            </div>
                        </g:else>
                    </div>
                    <g:if test="${grailsApplication.config.thesaurus.readOnly != 'true'}">
                        <g:form action="login" method="post" name="loginform" class="form-block__form">
                            <input 
                                type="hidden" 
                                name="returnUrl" 
                                value="${params.returnUrl?.encodeAsHTML()}" 
                            />
                            <div class="form-group">
                                <label for='userId' class="form-group__label">
                                    <g:message code="user.login.form.username" />
                                </label>
                                <%-- not using type="email" because of user 'admin'... --%>
                                <input
                                    class="form-control"
                                    autofocus 
                                    size="30" 
                                    type="text" 
                                    placeholder="${message(code:'user.register.email.placeholder')}" 
                                    spellcheck="false"
                                    id='userId' 
                                    name='userId' 
                                    value="${params.userId?.encodeAsHTML()}" 
                                    required
                                />
                            </div>
                            <div class="form-group">
                                <label for='password' class="form-group__label">
                                    <g:message code="user.login.form.password" />
                                </label>
                                <input 
                                    class="form-control"
                                    size="30" 
                                    type="password" 
                                    id='password' 
                                    name='password' 
                                    value="" 
                                    required 
                                />
                            </div>
                            <div class="form-group form-group--text">
                                <div style="margin-top: 5px">
                                    <g:message code="user.login.forgot.password" />
                                </div>
                            </div>
                            <div class="form-group form-group--text">
                                <input 
                                    type="checkbox" 
                                    name='logincookie' 
                                    id='logincookie' 
                                />
                                <label for='logincookie'>
                                    <g:message code="user.login.form.logincookie" />
                                </label>
                            </div>
                            <div class="form-group">
                                <button 
                                    class="button button--primary" 
                                    type="submit"
                                >${message(code:'user.login.form.submit')}</button>
                            </div>
                        </g:form>
                    </g:if>
                </section>
            </div>
        </main>
    </body>
</html>
