<div style="margin-top:23px">
<g:if test="${session.user}">
    <g:message code="user.successful.login" args="${[session.user.userId.toString()?.encodeAsHTML()]}"/>
    <g:if test="${session.user.userId.toString() == 'admin'}">
        <g:link controller="admin" action="index">[admin]</g:link>
    </g:if>
    <span class="d">&middot;</span>
    <g:link controller="user" action="edit"><g:message code="user.edit.link"/></g:link>
    <span class="d">&middot;</span>
    <g:link controller="user" action="logout"><g:message code="user.logout"/></g:link>
</g:if>
</div>