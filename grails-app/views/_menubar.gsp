<a href="${createLinkTo(dir:'',file:'')}"><g:message code="homepage.link"/></a> -
 <g:link controller="about" action="imprint"><g:message code="homepage.imprint"/></g:link>
-
<g:if test="${session.user}">
    Logged in as ${session.user.userId.toString()?.encodeAsHTML()} -
    <g:link controller="user" action="logout">Logout</g:link>
</g:if>
<g:else>
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
