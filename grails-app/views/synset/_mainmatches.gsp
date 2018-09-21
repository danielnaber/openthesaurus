<%@page import="com.vionto.vithesaurus.tools.*" %>
<g:if test="${totalMatches > 0}">

    <div class="main-content-section">

        <g:each in="${synsetList}" status="i" var="synset">

            <ul class="main-content-section-block wordtags wordtags-big">
                <g:set var="counter" value="${0}"/>
                <g:each in="${synset?.sortedTerms()}" var="term">
                    <g:set var="displayTerm" value="${term.toString().encodeAsHTML()}"/>
                    <g:set var="infos" value="${[]}"/>
                    <g:if test="${term.level}">
                        <%
                            infos.add("<span title='${term.level.levelName}'>" + term.level?.shortLevelName.encodeAsHTML() + "</span>");
                        %>
                    </g:if>
                    <g:if test="${term.tags}">
                        <g:each in="${term.tags.sort()}" var="tag">
                            <%
                                if (!tag.isInternal() || session.user) {
                                    String title = tag.name;
                                    if (tag.isInternal()) {
                                        title = message(code:'tag.internal.tooltip');
                                    }
                                    infos.add("<span title='${title}'>${tag.shortName ? tag.shortName : tag.name}</span>");
                                }
                            %>
                        </g:each>
                    </g:if>
                    <g:if test="${infos.size() > 0}">
                        <%
                            displayTerm = "${displayTerm} <span class='wordLevel'>(${infos.join(', ')})</span>";
                        %>
                    </g:if>
    
                    <g:set var="lowercaseTerm" value="${term.toString().toLowerCase()}"/>
                    <g:set var="lowercaseNormTerm" value="${term.normalizedWord?.toLowerCase()}"/>
                    <g:set var="lowercaseNormTerm2" value="${term.normalizedWord2?.toLowerCase()}"/>
                    <g:set var="lowercaseQuery" value="${params.q.toLowerCase()}"/>
                    <%-- keep in sync with SearchService.groovy: --%>
                    <g:set var="lowercaseQuery2" value="${lowercaseQuery.replaceAll('^(sich|etwas) ', '')}"/>
    
                    <g:set var="commentInfo" value=""/>
                    <g:if test="${term.userComment}">
                        <g:set var="commentInfo">
                            <span title="${term.userComment.encodeAsHTML()}" class="commentMarker">
                                <i class="fa fa-comment" aria-hidden="true"></i>
                            </span>
                        </g:set>
                    </g:if>
                    <%
                        long antonymTime = System.currentTimeMillis();
                    %>
                    <g:set var="antonymInfo" value=""/>
                    <g:set var="antonymTitle" value=""/>
                    <g:set var="termLinkInfos" value="${term.termLinkInfos()}"/>
                    <g:if test="${termLinkInfos.size() > 0}">
                        <g:set var="termLinkInfo" value="${term.termLinkInfos().get(0)}"/>
                        <g:if test="${termLinkInfo.linkName == message(code:'edit.link.antonym.db.name')}">
                            <g:set var="antonymTitle"><g:message code="edit.antonym.title.attribute"
                                                                 args="${[termLinkInfo.term2.word, termLinkInfo.term2.synset.toShortStringWithShortLevel(20, true)]}"/></g:set>
                            <g:set var="antonymInfo">
                                <span class="antonymMarker" title="${antonymTitle}">
                                    <a href="${termLinkInfo.term2.word.encodeAsURL()}">
                                        <i class="icon fa fa-bolt" aria-hidden="true"></i>
                                    </a>
                                </span>
                            </g:set>
                        </g:if>
                    </g:if>
                    <%
                        long antonymTotalTime = System.currentTimeMillis() - antonymTime;
                    %>
    
                    <li class="wordtag">
                        <span class="d">&middot;</span>
                        <g:if 
                            test="${lowercaseQuery == lowercaseTerm 
                                || lowercaseQuery == lowercaseNormTerm 
                                || lowercaseQuery2 == lowercaseTerm 
                                || lowercaseQuery2 == lowercaseNormTerm 
                                || lowercaseQuery == lowercaseNormTerm2}"
                        >
                            <g:render template="audio" model="${[term:term]}"/>
                            <span 
                                class="word word-dot word-match"
                            >
                                ${displayTerm}
                            </span>
                            ${commentInfo}
                            ${antonymInfo}
                        </g:if>
                        <g:else>
                            <span class="word word-dot">
                                <g:link 
                                    action="search" 
                                    params="${['q': StringTools.slashEscape(term.toString())]}"
                                >
                                    ${displayTerm}
                                </g:link>
                                ${commentInfo}
                                ${antonymInfo}
                                <!-- <g:render template="audio" model="${[term:term]}"/> -->
                            </span>
                        </g:else>
                    </li>
    
                    <g:set var="counter" value="${counter + 1}"/>
                </g:each>
    
            </ul>
            
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
                <div class="main-content-section-block">
                    <div class="main-content-section-block-heading"><g:message code='edit.categories'/>:</div>
                    <div class="main-content-section-block-line">
                        <div class="category">
                            <g:each var='cat' in='${categoryStrings}'>
                                <span class="word word-dot">${cat}</span>
                            </g:each>
                        </div>
                    </div>
                </div>
            </g:if>
    
            <g:set var="superSynsets" value="${[]}"/>
            <g:each in="${synset.synsetLinks}" var="synsetLink">
                <g:if test="${synsetLink.linkType.linkName == message(code:'edit.link.super.synsets.db.name')}">
                    <%
                        superSynsets.add(synsetLink.targetSynset)
                    %>
                </g:if>
            </g:each>
            <g:if test="${superSynsets}">
                <div class="main-content-section-block">
                    <div class="main-content-section-block-heading">
                        <g:message code="edit.link.super.synsets"/>
                    </div>
                    <div class="main-content-section-block-line">
                        <g:render template="linkMatches" model="${[links:superSynsets, itemPrefix: 'span class="word word-dot"', itemSuffix: '/span', showSynsetDelimiter: true]}"/>
                    </div>
                </div>
            </g:if>
    
    
            <g:set var="associationSynsets" value="${[]}"/>
            <g:set var="moreAssociationSynsets" value="${[]}"/>
            <g:each in="${synset.sortedSynsetLinks()}" var="synsetLink">
                <g:if test="${synsetLink.linkType.linkName == message(code:'edit.link.association.db.name')}">
                    <g:if test="${associationSynsets.size() < 3}">
                        <%
                            associationSynsets.add(synsetLink.targetSynset)
                        %>
                    </g:if>
                    <g:else>
                        <%
                            moreAssociationSynsets.add(synsetLink.targetSynset)
                        %>
                    </g:else>
                </g:if>
            </g:each>
            <g:if test="${associationSynsets}">
                <div class="main-content-section-block">
                    <div class="main-content-section-block-heading"><g:message code="edit.link.associations"/></div>
                    <div class="main-content-section-block-line">
                        <g:render template="linkMatches" model="${[links:associationSynsets, itemPrefix: 'span class="word word-dot"', itemSuffix: '/span']}"/>
                        <g:if test="${moreAssociationSynsets}">
                            <div id="associationShowLink${synset.id}"><a href="#" class="moreLessLink" onclick="$('#association${synset.id}').show();$('#associationShowLink${synset.id}').hide();return false;"><g:message code="result.link.show.all"/></a></div>
                        </g:if>
                    </div>
                    <g:if test="${moreAssociationSynsets}">
                        <ul id="association${synset.id}" class="associationList" style="display: none">
                            <g:render template="linkMatches" model="${[links:moreAssociationSynsets, itemPrefix: 'span class="word word-dot"', itemSuffix: '/span']}"/>
                            <span class="word word-dot"><a href="#" class="moreLessLink" onclick="$('#association${synset.id}').hide();$('#associationShowLink${synset.id}').show();return false;"><g:message code="result.link.show.less"/></a></span>
                        </ul>
                    </g:if>
                </div>
            </g:if>

            <div class="main-content-section-block">
                <div class="main-content-section-block-link">
                    <g:link action="edit" id="${synset.id}">
                        <g:message code="result.edit"/>
                    </g:link>
                </div>
            </div>
        
        </g:each>

    </div>

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
