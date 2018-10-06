<g:set var="metaInfos" value="${[]}"/>
<g:if test="${term.level}">
    <% metaInfos.add("<span title='${term.level.levelName.encodeAsHTML()}'>" + term.level.shortLevelName.encodeAsHTML() + "</span>") %>
</g:if>
<g:if test="${term.tags}">
    <g:each in="${term.tags.sort()}" var="tag">
        <g:if test="${!tag.isInternal() || session.user}">
            <g:if test="${tag.shortName}">
                <% metaInfos.add("<span title='" + tag.name.encodeAsHTML() + "'>" + tag.shortName.encodeAsHTML() + "</span>") %>
            </g:if>
            <g:else>
                <% metaInfos.add(tag.name.encodeAsHTML()) %>
            </g:else>
        </g:if>
    </g:each>
</g:if>
<g:if test="${metaInfos.size() > 0}">
    <span class="metaInfo">(${metaInfos.join(", ")})</span>
</g:if>
