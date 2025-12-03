<g:each in="${links}" var="item" status="synsetCount">
    <g:if test="${showSynsetDelimiter && synsetCount > 0}">
        |
    </g:if>
    <${itemPrefix} title="${item.toShortStringWithShortLevel(20, true).encodeAsHTML()}">
        <g:set var="sortedTerms" value="${item.sortedTerms()}"/>
        <g:each in="${sortedTerms}" var="term" status="termCount">
            <g:if test="${termCount < 3}">
                <g:if test="${termCount > 0}">
                    &middot;
                </g:if>
                <g:if test="${termCount == 2 && sortedTerms.size() >= 3}">
                    <g:set var="ellipse" value="&hellip;" />
                </g:if>
                <g:else>
                    <g:set var="ellipse" value="" />
                </g:else>
                <g:if test="${term.level}">
                    <a href="${term.word.replace('/', '___').encodeAsURL()}">${term.word.encodeAsHTML()} (${term.level.shortLevelName.encodeAsHTML()})${ellipse}</a>
                </g:if>
                <g:else>
                    <a href="${term.word.replace('/', '___').encodeAsURL()}">${term.word.encodeAsHTML()}${ellipse}</a>
                </g:else>
            </g:if>
        </g:each>
    <${itemSuffix}>
</g:each>
