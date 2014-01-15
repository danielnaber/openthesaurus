<div style="margin-top:23px">
<g:if test="${session.user}">
    <g:link controller="user" action="edit"><g:message code="user.edit.link"/></g:link>
    <span class="d">&middot;</span>
    <g:link controller="synset" action="create"><g:message code="user.create.synset"/></g:link>
</g:if>
</div>