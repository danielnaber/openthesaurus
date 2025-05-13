<div id="navigation">
    <div id="navibar">
        <table style="width:100%">
            <tr>
                <td>
                    <!--<span class="mobileOnly"><g:link controller="home">openthesaurus.de</g:link>&nbsp;&nbsp;&nbsp;</span>-->
                    <g:link controller="wordList"><g:message code="homepage.wordlists"/></g:link>
                    &nbsp;&nbsp;&nbsp;<g:link controller="about"><g:message code="homepage.about"/></g:link>
                </td>
                <td style="text-align: right" id="right-navibar">
                    <g:if test="${session.user}">
                        <g:if test="${session.user.userId.toString() == 'admin'}">
                            <g:link controller="admin" action="index"><span class="adminOnly"><g:message code="user.successful.login" args="${[session.user.userId]}"/></span></g:link>
                        </g:if>
                        <g:else>
                            <span style="color:white"><g:message code="user.successful.login" args="${[session.user.userId]}"/></span>
                        </g:else>
                        &nbsp;
                        <g:link controller="user" action="logout">Logout</g:link>
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
                        <g:link controller="user" action="login" class="lightlink" params="${linkParams}"><g:message code="footer.login"/></g:link>
                    </g:else>
                </td>
            </tr>
        </table>
    </div>
    <g:if test="${session.user && grailsApplication.config.thesaurus.readOnly == 'true'}">
        <div style="color:white;border-width: 2px; background-color: darkorange;padding:8px">
            <g:message code="server.read.only"/>
        </div>
    </g:if>
</div>

