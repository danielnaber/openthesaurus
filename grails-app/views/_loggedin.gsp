<div style="margin-top:23px">
<g:if test="${session.user}">
    <g:message code="user.successful.login" args="${[session.user.userId.toString()?.encodeAsHTML()]}"/>
    <g:if test="${session.user.userId.toString() == 'admin'}">
        <g:link controller="admin" action="index">[admin]</g:link>
    </g:if>
    <span class="d">&middot;</span>
    <g:link controller="user" action="edit">Logbuch</g:link>
    <span class="d">&middot;</span>
    <g:link controller="user" action="logout">Logout</g:link>
</g:if>
</div>