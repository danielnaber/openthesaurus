  
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title><g:message code="user.register.title"/></title>         
    </head>
    <body>

          <hr/>

          <h1><g:message code="user.register.headline"/></h1>

          <g:if test="${flash.message}">
              <div class="message">${flash.message}</div>
          </g:if>

          <p><g:message code="user.register.check.email" args="${[email.encodeAsHTML()]}"/></p>

          <g:if test="${params.subscribeToMailingList}">
            <p><g:message code="user.register.check.email.mailinglist"/></p>
          </g:if>
			        
    </body>
</html>
