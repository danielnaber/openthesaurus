  
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title><g:message code="user.reset.password.title"/></title>         
    </head>
    <body>

          <h1><g:message code="user.reset.password.headline"/></h1>

          <g:if test="${flash.message}">
              <div class="message">${flash.message}</div>
          </g:if>

          <p><g:message code="user.reset.password.done" args="${[user.userId.encodeAsHTML()]}"/></p>
			        
    </body>
</html>
