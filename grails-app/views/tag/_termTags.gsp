<g:each in="${term.tags?.sort()}" var="tag">
    <g:set var="showTag" value="${!tag.isInternal() || session.user}"/>
    <g:if test="${showTag}">
        <g:link controller="tag" params="${[tag: tag.name]}"><span
                class="tag" style="background-color:${tag.getBackgroundColor()}"
                title="${tag.shortName ? tag.name.encodeAsHTML() : ''}">${tag.shortName ? tag.shortName.encodeAsHTML() : tag.name.encodeAsHTML()}</span></g:link>
    </g:if>
</g:each>
