  
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <g:set var="preventSearchFocus" value="true" scope="request" />
        <meta name="layout" content="main" />
        <title><g:message code="user.lost.password.title"/></title>         
    </head>
    <body>
        <main class="main">
            <div class="container">
                <section class="main-content content-page form-block">
                    <div class="form-block__header">
                        <h1 class="form-block__title">
                            <g:message code="user.lost.password.headline"/>
                        </h1>
                        <g:if test="${flash.message}">
                            <div class="message form-block__description">${flash.message}</div>
                        </g:if>
                        <div class="form-block__description">
                            <g:message code="user.lost.password.intro" />
                        </div>
                        <g:hasErrors bean="${user}">
                            <div class="error form-block__errors">
                                <g:renderErrors bean="${user}" as="list" />
                            </div>
                        </g:hasErrors>
                    </div>
                    <g:form 
                        action="requestPasswordReset" 
                        method="post" 
                        name="loginform" 
                        class="form-block__form"
                    >
                        <div class="form-group">
                            <label for='userId' class="form-group__label">
                                <g:message code="user.login.form.username"/>
                            </label>
                            <input 
                                class="form-control"
                                autofocus="" 
                                size="40" 
                                type="email" 
                                placeholder="${message(code:'user.register.email.placeholder')}"
                                id='userId' 
                                name='userId' 
                                value="${params.userId?.encodeAsHTML()}" 
                                spellcheck="false" 
                                required 
                            />
                        </div>
                        <div class="form-group">
                            <button
                                class="button button--primary"
                                type="submit"
                            >${message(code:'user.lost.password.form.submit')}</button>
                        </div>
                    </g:form>
                </section>
            </div>
        </main>
        <script type="text/javascript">
            document.loginform.userId.focus();
        </script>
    </body>
</html>
