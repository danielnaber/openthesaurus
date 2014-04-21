  
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title><g:message code="user.register.title"/></title>         
    </head>
    <body>

          <hr/>

          <h2><g:message code="user.register.headline"/></h2>

          <g:if test="${flash.message}">
              <div class="message">${flash.message}</div>
          </g:if>

          <p><g:message code="user.register.check.email" args="${[email]}"/></p>

          <g:if test="${grailsApplication.config.thesaurus.serverId == 'de'}">
              
              <p>Optional können Sie sich hier auch direkt für unseren Newsletter anmelden. Sie
              erhalten dann eine zweite E-Mail mit einem weiteren Aktivierungs-Link.
              Der Newsletter informiert mehrmals pro Jahr über Neuigkeiten auf openthesaurus.de:</p>

              <form action="http://46260.seu1.cleverreach.com/f/46260-126218/wcs/" method="post" target="_blank">
                  <input id="text2567502" name="email" value="${params.userId.encodeAsHTML()}" type="text" size="30" />
                  <button type="submit">Newsletter abonnieren</button>
              </form>
              
          </g:if>

    </body>
</html>
