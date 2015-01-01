<g:set var="metaInfos" value="${[]}"/>
<g:if test="${term.level}">
    <% metaInfos.add(term.level.shortLevelName) %>
</g:if>
<g:if test="${term.tags}">
    <g:each in="${term.tags.sort()}" var="tag">
        <% metaInfos.add(tag.shortName ? tag.shortName : tag.name) %>
    </g:each>
</g:if>
<g:if test="${metaInfos.size() > 0}">
    <span class="metaInfo">(${metaInfos.join(", ")})</span>
</g:if>
