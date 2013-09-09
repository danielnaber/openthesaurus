<%@page import="com.vionto.vithesaurus.tools.*" %>
<g:if test="${totalMatches > 0}">

    <g:each in="${synsetList}" status="i" var="synset">

        <div style="margin-bottom: 10px;margin-top:0px">

            <g:set var="superSynsetStrings" value="${[]}"/>
            <g:each in="${synset.synsetLinks}" var="synsetLink">
                <g:if test="${synsetLink.linkType.linkName == 'Oberbegriff'}">
                    <%
                        superSynsetStrings.add(synsetLink.targetSynset.toShortStringWithShortLevel(3, false).encodeAsHTML())
                    %>
                </g:if>
            </g:each>
            <g:if test="${superSynsetStrings}">
                <div class="superordinate">
                    <span class="superordinateHead">Oberbegriffe:</span>
                    <span class="superordinateTerms">
                        ${superSynsetStrings.join(' | ')}</span>
                </div>
            </g:if>
            <g:else>
                <div class="superordinate"></div>
            </g:else>

            <g:set var="categoryStrings" value="${[]}"/>
            <g:if test="${synset.categoryLinks && synset.categoryLinks.size() > 0}">
                <g:each var='catLink' in='${synset.categoryLinks.sort()}'>
                    <g:set var="catLinkUrl" value="${createLink(controller:'term', action:'list', params:[categoryId: catLink.category.id])}"/>
                    <%
                        categoryStrings.add("<a href='${catLinkUrl}'>" + catLink.category + "</a>")
                    %>
                </g:each>
            </g:if>
            <g:if test="${categoryStrings}">
                <div class="category">
                    <span class="categoryHead"><g:message code='edit.categories'/>:</span>
                    <span class="categoryTerm">${categoryStrings.join(' | ')}</span>
                </div>
            </g:if>

            <div class="result">
                <g:set var="counter" value="${0}"/>
                <g:each in="${synset?.sortedTerms()}" var="term">
                    <g:if test="${term.level}">
                        <g:set var="displayTerm" value="${term.toString().encodeAsHTML() + ' (' + term.level?.shortLevelName.encodeAsHTML() + ')'}"/>
                        <%
                            displayTerm = displayTerm.replace(" (" + term.level?.shortLevelName.encodeAsHTML() + ")", " <span class='wordLevel'>(" + term.level?.shortLevelName.encodeAsHTML() + ")</span>");
                        %>
                    </g:if>
                    <g:else>
                        <g:set var="displayTerm" value="${term.toString().encodeAsHTML()}"/>
                    </g:else>

                    <g:if test="${counter == synset?.sortedTerms()?.size() - 1}">
                        <g:set var="delim" />
                    </g:if>
                    <g:else>
                        <g:set var="delim"><span class="d">&nbsp;&middot;</span></g:set>
                    </g:else>

                    <g:set var="lowercaseTerm" value="${term.toString().toLowerCase()}"/>
                    <g:set var="lowercaseNormTerm" value="${term.normalizedWord?.toLowerCase()}"/>
                    <g:set var="lowercaseQuery" value="${params.q.toLowerCase()}"/>
                    <g:set var="lowercaseQuery2" value="${lowercaseQuery.replaceAll('^sich ', '').replaceAll('^etwas ', '')}"/>
                    <g:if test="${lowercaseQuery == lowercaseTerm || lowercaseQuery == lowercaseNormTerm ||
                            lowercaseQuery2 == lowercaseTerm || lowercaseQuery2 == lowercaseNormTerm}">
                        <span class="synsetmatch">${displayTerm}</span>${delim}
                    </g:if>
                    <g:else>
                        <g:link action="search" params="${['q': StringTools.slashEscape(term.toString())]}"
                        >${displayTerm}</g:link>${delim}
                    </g:else>

                    <g:set var="counter" value="${counter + 1}"/>
                </g:each>

                <g:set var="associationSynsetStrings" value="${[]}"/>
                <g:each in="${synset.sortedSynsetLinks()}" var="synsetLink">
                    <g:if test="${synsetLink.linkType.linkName == 'Assoziation' && associationSynsetStrings.size() < 3}">
                        <%
                            associationSynsetStrings.add(synsetLink.targetSynset.toShortStringWithShortLevel(3, false).encodeAsHTML())
                        %>
                    </g:if>
                </g:each>
                <g:if test="${associationSynsetStrings}">
                    <div class="associations">
                        <span class="superordinateHead">Assoziationen:</span>
                        <span class="superordinateTerms">${associationSynsetStrings.join(' | ')}</span>
                    </div>
                </g:if>

                <g:link action="edit" id="${synset.id}">
                    <g:if test="${session.user}">
                        <span class="changeLink"><g:message code="result.edit"/></span>
                    </g:if>
                    <g:else>
                        <span class="changeLink"><g:message code="result.details"/></span>
                    </g:else>
                </g:link>
            </div>

        </div>

    </g:each>

</g:if>
<g:else>
    <h2><g:message code="result.no.matches"/></h2>
    <g:if test="${baseforms.size() > 0}">
        <div><strong><g:message code="result.no.matches.baseforms"/></strong><br/>
            <span class="result">
                <g:each in="${baseforms}" var="term" status="counter">
                    <g:link action="search" params="${[q: StringTools.slashEscape(term)]}">${term.encodeAsHTML()}</g:link>
                    <g:if test="${counter < baseforms.size()-1}">
                        <span class="d">&middot;</span>
                    </g:if>
                </g:each>
            </span>
        </div>
        <br />
    </g:if>
    <g:if test="${similarTerms.size > 0}">
        <div><strong><g:message code="result.no.matches.similar.words"/></strong><br/>
            <span class="result">
                <g:each in="${similarTerms}" var="term" status="counter">
                    <g:if test="${counter < 3}">
                        <g:link action="search" params="${[q: StringTools.slashEscape(term.term)]}">${term.term.encodeAsHTML()}</g:link>
                        <g:if test="${counter < Math.min(2, similarTerms.size()-1)}">
                            <span class="d">&middot;</span>
                        </g:if>
                    </g:if>
                </g:each>
            </span>
        </div>
        <br />
    </g:if>
</g:else>
