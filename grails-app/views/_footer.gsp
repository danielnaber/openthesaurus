<div id="foot">
    
  <div class="footerColumn" style="margin-top: 44px; margin-right: 37px;">
      
      <div class="claim" style="margin-bottom: 23px">
          <g:message code="homepage.tagline"/>
      </div>

      <img style="width:100%;height:2px;margin-bottom:23px" src="${createLinkTo(dir:'images',file:'hr.png')}" alt="Separator"/>

      <ul style="float: left; margin-right: 40px">
          <li><g:link controller="search" action="index"><g:message code="powersearch.headline"/></g:link></li>
          <li><g:link controller="about" action="faq"><g:message code="homepage.faq"/></g:link></li>
          <li><g:link controller="about" action="api"><g:message code="homepage.api.short"/></g:link></li>
          <li><g:link controller="tag" action="list"><g:message code="homepage.tags"/></g:link></li>
          <li><g:link controller="about" action="download"><g:message code="homepage.download"/></g:link></li>
          <li><g:link controller="userEvent" action="list"><g:message code="changelog"/></g:link></li>
          <li><g:link controller="statistics"><g:message code="statistics"/></g:link></li>
          <li><g:link controller="about" action="imprint"><g:message code="homepage.imprint"/></g:link></li>
          <li><a href="https://languagetool.org/de">Rechtschreibprüfung</a></li>
      </ul>

      <ul>
        <li><g:link controller="wordList"><g:message code="homepage.wordlists"/></g:link></li>
        <li style="margin-bottom:18px"><g:link controller="about"><g:message code="homepage.about"/></g:link></li>

        <g:if test="${session.user}">
            <li><span style="color:white"><g:message code="user.successful.login" args="${[session.user.userId]}"/></span></li>
            <li><g:link controller="user" action="logout">Logout</g:link></li>
        </g:if>
        <g:else>
            <g:if test="${params.q}">
                <g:set var="linkParams" value="${[q: params.q, controllerName: webRequest.getControllerName(),
                        actionName:webRequest.getActionName(), origId: params.id]}" />
            </g:if>
            <g:elseif test="${params.id}">
                <g:set var="linkParams" value="${[controllerName: webRequest.getControllerName(),
                        actionName:webRequest.getActionName(), origId: params.id]}" />
            </g:elseif>
            <g:else>
                <g:set var="linkParams" value="${[controllerName: webRequest.getControllerName(),
                        actionName:webRequest.getActionName()]}" />
            </g:else>
            <li><g:link controller="user" action="login" class="lightlink" params="${linkParams}"><g:message code="footer.login"/></g:link></li>
        </g:else>
      </ul>

  </div>
    
</div>
