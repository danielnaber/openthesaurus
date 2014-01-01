<g:each in="${links}" var="item">
    <li title="${item.toShortStringWithShortLevel(20, true).encodeAsHTML()}">
        <g:each in="${item.sortedTerms()}" var="term" status="termCount">
            <g:if test="${termCount < 3}">
                <g:if test="${termCount > 0}">
                    &middot;
                </g:if>
                <g:if test="${term.level}">
                    <a href="${term.word.encodeAsURL()}">${term.word.encodeAsHTML()} (${term.level.shortLevelName.encodeAsHTML()})</a>
                </g:if>
                <g:else>
                    <a href="${term.word.encodeAsURL()}">${term.word.encodeAsHTML()}</a>
                </g:else>
            </g:if>
            <g:elseif test="${termCount == 3}">
                &middot; ...
            </g:elseif>
        </g:each>
    </li>
</g:each>
