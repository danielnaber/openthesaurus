<div id="navigation">
    <div id="navibar">
        <table style="width:100%">
            <tr>
                <td>
                    <g:link controller="about">Über</g:link>
                    &nbsp;&nbsp;&nbsp;<g:link controller="woerter" action="listen"><g:message code="homepage.wordlists"/></g:link>
                    &nbsp;&nbsp;&nbsp;<a href="/jforum/forums/show/1.page">Forum</a>
                    &nbsp;&nbsp;&nbsp;<g:link controller="about" action="api"><g:message code="homepage.api.short"/></g:link>
                </td>
                <td style="text-align: right">
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
                        <g:link controller="user" action="login" class="lightlink" params="${linkParams}"><g:message code="footer.login"/></g:link>
                    </g:else>
                </td>
            </tr>
        </table>
    </div>
</div>
