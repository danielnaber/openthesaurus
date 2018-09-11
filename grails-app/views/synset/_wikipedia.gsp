<%@page import="com.vionto.vithesaurus.tools.StringTools" %>

<div class="main-content-section-heading">
    <g:message code="result.wikipedia.headline"/>
</div>
<div class="main-content-section-block wordtags wordtags-big">

    <g:if test="${wikipediaResult}">
        <% int i = 0; %>
        <g:each in="${wikipediaResult}" var="term">
            <g:if test="${i == 0}">	<%-- skipping title --%>
                <g:set var="wikipediaTitle" value="${term}"/>
            </g:if>
            <g:elseif test="${i > 0 && i < wikipediaResult.size() - 1}">
                <span class="word word-dot"><g:link action="search" params="${[q: StringTools.slashEscape(StringTools.normalizeParenthesis(term))]}">${term.encodeAsHTML()}</g:link></span>
                <span class="d">&nbsp;&middot;&nbsp;</span>
            </g:elseif>
            <g:else>
                <span class="word word-dot"><g:link action="search" params="${[q: StringTools.slashEscape(StringTools.normalizeParenthesis(term))]}">${term.encodeAsHTML()}</g:link></span>
            </g:else>
            <% i++; %>
        </g:each>
    </g:if>
    <g:else>
        <span class="noMatches"><g:message code="result.no.matches"/></span>
    </g:else>
</div>
<div class="main-content-section-note">
    <div class="main-content-section-note-item">
        <g:message code="result.wikipedia.license"
                   args="${[wikipediaTitle.replaceAll(' ', '_').encodeAsURL(),wikipediaTitle,wikipediaTitle.encodeAsURL()]}"/>
    </div>
</div>
