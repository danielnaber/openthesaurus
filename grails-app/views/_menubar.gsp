<a href="${createLinkTo(dir:'/',file:'')}"><g:message code="homepage.link"/></a>
<span class="d">&middot;</span>
 <g:link controller="about" action="imprint"><g:message code="homepage.imprint"/></g:link>
<g:if test="${session.user}">
	<span class="d">&middot;</span>
	<g:message code="user.successful.login" args="${[session.user.userId.toString()?.encodeAsHTML()]}"/>
    <span class="d">&middot;</span>
    <g:link controller="user" action="logout">Logout</g:link>
</g:if>
<g:else>
	<span class="d">&middot;</span>
    <g:if test="${params.q}">
        <g:link controller="user" action="login"
           params="[q: params.q, controllerName: webRequest.getControllerName(),
               actionName:webRequest.getActionName(), origId: params.id]">Login</g:link>
    </g:if>
    <g:elseif test="${params.id}">
        <g:link controller="user" action="login"
           params="[controllerName: webRequest.getControllerName(),
               actionName:webRequest.getActionName(), origId: params.id]">Login</g:link>
    </g:elseif>
    <g:else>
           <g:link controller="user" action="login"
              params="[controllerName: webRequest.getControllerName(),
                  actionName:webRequest.getActionName()]">Login</g:link>
    </g:else>
    
</g:else>

<span class="d">&middot;</span>
<a href="http://twitter.com/openthesaurus"><img style="vertical-align:text-top"
   	title="OpenThesaurus auf twitter" alt="twitter Logo" width="16" height="16"
   	src="${createLinkTo(dir:'/images',file:'twitter_link16x16.png')}"/> twitter</a>
