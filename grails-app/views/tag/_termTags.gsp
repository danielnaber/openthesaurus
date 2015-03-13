<g:each in="${term.tags?.sort()}" var="tag">
    <g:set var="showTag" value="${!tag.isInternal() || session.user}"/>
    <g:if test="${showTag}">
        <g:set var="title" value="${tag.shortName ? tag.name.encodeAsHTML() : ''}"/>
        <g:if test="${tag.isInternal()}">
            <g:set var="title" value="${title + " " + message(code:'tag.internal.tooltip')}"/>
        </g:if>
        <g:link controller="tag" params="${[tag: tag.name]}"><span
                class="tag" style="background-color:${tag.getBackgroundColor()}"
                title="${title}">${tag.shortName ? tag.shortName.encodeAsHTML() : tag.name.encodeAsHTML()}</span></g:link>
    </g:if>
</g:each>
