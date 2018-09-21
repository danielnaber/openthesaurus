  
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
            <section class="main-content content-page login">

                <h1 class="login__title">
                    <g:message code="user.login.headline" />
                </h1>

                <g:if test="${flash.message}">
                    <div class="message login__message">${flash.message}</div>
                </g:if>

                <g:hasErrors bean="${user}">
                    <div class="errors">
                        <g:renderErrors bean="${user}" as="list" />
                    </div>
                </g:hasErrors>
            
                <g:if test="${grailsApplication.config.thesaurus.readOnly == 'true'}">
                    <g:message code="server.read.only.no.login" />
                </g:if>
                <g:else>
                    <div class="login__register-message">
                        <g:message code="user.login.register" />
                    </div>
                    <g:form action="login" method="post" name="loginform" class="login__form">
                        <input 
                            type="hidden" 
                            name="returnUrl" 
                            value="${params.returnUrl?.encodeAsHTML()}" 
                        />
                        <div class="form-group form-group--horizontal">
                            <div class="row">
                                <div class="col col-12 col-md-2">
                                    <label for='userId' class="label">
                                        <g:message code="user.login.form.username" />
                                    </label>
                                </div>
                                <div class="col col-12 col-md-10">
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
                            </div>
                        </div>
                        <div class="form-group form-group--horizontal">
                            <div class="row">
                                <div class="col col-12 col-md-2">
                                    <label for='password' class="label">
                                        <g:message code="user.login.form.password" />
                                    </label>
                                </div>
                                <div class="col col-12 col-md-10">
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
                            </div>
                        </div>
                        <div class="form-text">
                            <div class="row">
                                <div class="col col-12 offset-md-2 col-md-10">
                                    <div style="margin-top: 5px">
                                        <g:message code="user.login.forgot.password" />
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="form-text">
                            <div class="row">
                                <div class="col col-12 offset-md-2 col-md-10">
                                    <input 
                                        type="checkbox" 
                                        name='logincookie' 
                                        id='logincookie' 
                                    />
                                    <label for='logincookie'>
                                        <g:message code="user.login.form.logincookie" />
                                    </label>
                                </div>
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="row">
                                <div class="col col-12 offset-md-2 col-md-10">
                                    <button 
                                        class="login submitButton button button--primary" 
                                        type="submit"
                                    >${message(code:'user.login.form.submit')}</button>
                                </div>
                            </div>
                        </div>
                    </g:form>
                </g:else>

            </section>
        </div>
    </main>

    </body>
</html>
