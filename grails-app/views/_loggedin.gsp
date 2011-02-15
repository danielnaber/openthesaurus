<div style="margin-top:23px">
<g:if test="${session.user}">
    <g:message code="user.successful.login" args="${[session.user.userId.toString()?.encodeAsHTML()]}"/>
    <span class="d">&middot;</span>
    <g:link controller="user" action="edit">Logbuch</g:link>
    <span class="d">&middot;</span>
    <g:link controller="user" action="logout">Logout</g:link>
</g:if>
</div>