<div style="margin-top:23px">
<g:if test="${session.user}">
    <g:message code="user.successful.login" args="${[session.user.userId]}"/>
    <g:if test="${session.user.userId.toString() == 'admin'}">
        <span class="adminOnly"><g:link controller="admin" action="index">[admin]</g:link></span>
    </g:if>
    <span class="d">&middot;</span>
    <g:link controller="user" action="edit"><g:message code="user.edit.link"/></g:link>
    <span class="d">&middot;</span>
    <g:link controller="synset" action="create"><g:message code="user.create.synset"/></g:link>
    <span class="d">&middot;</span>
    <g:link controller="user" action="logout"><g:message code="user.logout"/></g:link>
</g:if>
</div>