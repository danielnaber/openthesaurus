<%@page import="com.vionto.vithesaurus.tools.StringTools" %>
<%@page import="java.util.regex.Pattern" %>
<%@page import="java.util.regex.Matcher" %>

<section class="main-content main-page">

    <g:if test="${params.home != 'true'}">
        <div style="position: absolute; right: 10px; top: 10px"><a href="#" onclick="closePopup();return false;"><img
                src="${createLinkTo(dir:'images',file:'close_grey.png')}?v2" width="20" height="20" alt="${message(code:'popup.alt.attribute')}" title="${message(code:'popup.title.attribute')}"></a></div>
    </g:if>

    <g:if test="${synsetList.size() == 0}">
        <div class="metaInfo" style="margin-top:8px;margin-bottom:4px">
            <div class="main-content-section">
                <g:message code="result.ajax.no.exact.matches.for" args="${[params.q.toString()]}"/>
                <g:if test="${mostSimilarTerm}">
                    <g:set var="simTerm" value="${mostSimilarTerm.term}"/>
                    - meinten Sie&nbsp;<g:link url="${createLinkTo(dir:'synonyme')}/${simTerm.encodeAsURL()}">${simTerm.encodeAsHTML()}</g:link>?
                </g:if>
            </div>
        </div>
    </g:if>
    <g:else>

        <%
            String q = params.q?.trim()
            String quotedQuery = Pattern.quote(q)
            String directPatternStr = "\\b(" + quotedQuery + ")\\b";
            Pattern directPattern = Pattern.compile(directPatternStr, Pattern.CASE_INSENSITIVE);
        %>
        <g:each in="${synsetList}" status="i" var="synset">
            <div class="main-content-section">
                <div class="synonyms">
                    <g:if test="${i < 10}">
                        <g:each in="${synset?.terms?.sort()}" var="term">
                            <g:set var="match" value='${term.toString()?.toLowerCase()}'/>
                            <%
                                Matcher directMatcher = directPattern.matcher(term.toString());
                                String directMatchingTerm = directMatcher.replaceAll("___beginhighlight___\$1___endhighlight___");
                                directMatchingTerm = directMatchingTerm.encodeAsHTML();
                                directMatchingTerm = directMatchingTerm.replace("___beginhighlight___", "<span class=\"synsetmatchDirect\">");
                                directMatchingTerm = directMatchingTerm.replace("___endhighlight___", "</span>");
                                if (term.normalizedWord?.equalsIgnoreCase(StringTools.normalize(q)) || term.normalizedWord2?.equalsIgnoreCase(StringTools.normalize2(q))) {
                                    directMatchingTerm = '<span class="synsetmatchDirect">' + directMatchingTerm + '</span>'
                                }
                            %>
                            <span class="synonyms-item"><a href="#">
                                <g:link url="${createLinkTo(dir:'synonyme')}/${term.toString().replace('/', '___').encodeAsURL()}">
                                    ${directMatchingTerm}
                                    <g:render template="metaInfo" model="${[term:term]}"/>
                                </g:link>
                            </a></span>
                        </g:each>
                    </g:if>
                </div>
            </div>
        </g:each>
        <g:if test="${synsetList.size() > 10}">
            <div class="main-content-section">
                <span class="metaInfo"><g:message code="result.ajax.more.exact.matches" /></span>
                &nbsp;<g:link controller="synset" action="search" params="${[q: params.q]}"><g:message code="result.ajax.show.all.exact.matches" /></g:link>
            </div>
        </g:if>
    </g:else>

    <g:if test="${substringSynsetList.size() == 0}">
        <div class="main-content-section">
            <g:if test="${params.q.trim().length() < minLengthForSubstringQuery}">
                <g:message code="result.ajax.too.short" args="${[minLengthForSubstringQuery]}"/>
            </g:if>
            <g:else>
                <g:message code="result.ajax.no.substring.matches.for" args="${[params.q]}"/>
            </g:else>
        </div>
    </g:if>
    <g:else>
        <%
        Pattern pattern = Pattern.compile("(" + Pattern.quote(params.q.encodeAsHTML()) + ")", Pattern.CASE_INSENSITIVE);
        %>
        <g:each in="${substringSynsetList}" status="i" var="synset">
            <div class="main-content-section">
                <g:if test="${i < 5}">
                    <div style="margin-bottom:10px">
                        <g:set var="firstVal" value="${true}"/>
                        <g:each in="${synset?.terms?.sort()}" var="term">
                            <g:set var="match" value='${term.toString()?.toLowerCase()}'/>
                            <g:if test="${!firstVal}">
                                <span class="d">&middot;</span>
                            </g:if>
                            <%
                            Matcher matcher = pattern.matcher(term.toString().encodeAsHTML());
                            String matchingTerm = matcher.replaceAll("<span class=\"synsetmatchDirect\">\$1</span>");
                            %>
                            <g:link url="${createLinkTo(dir:'synonyme')}/${term.toString().encodeAsURL()}">
                                ${matchingTerm}
                                <g:render template="metaInfo" model="${[term:term]}"/>
                            </g:link>
                            <g:set var="firstVal" value="${false}"/>
                        </g:each>
                    </div>
                </g:if>
            </div>
        </g:each>
        <g:if test="${substringSynsetList.size() > 5}">
            <div class="main-content-section">
                <span class="metaInfo"><g:message code="result.ajax.more.substring.matches" /></span>
                &nbsp;<g:link controller="synset" action="substring" params="${[q: params.q]}"><g:message code="result.ajax.show.all.exact.matches" /></g:link>
            </div>
        </g:if>
    </g:else>
    
    <div class="main-content-section nowrap">
        <g:link controller="synset" action="create" params="[term : params.q]">
            <button type="button" class="button button-icon button-addsynonym">
                <i class="fa fa-plus-circle"></i>
            </button>
            <span>
                <g:message code="result.create.synset" args="${[params.q]}" />
            </span>
        </g:link>
    </div>
</section>
