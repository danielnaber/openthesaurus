  
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title><g:message code="user.request.password.reset.title"/></title>         
    </head>
    <body>

          <hr/>
    
          <h2><g:message code="user.request.password.reset.headline"/></h2>

          <g:if test="${flash.message}">
              <div class="message">${flash.message}</div>
          </g:if>

          <p><g:message code="user.request.password.intro" args="${[email]}"/></p>
        
    </body>
</html>
