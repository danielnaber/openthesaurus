<%@page import="java.util.regex.Pattern; com.vionto.vithesaurus.tools.*" %>
<g:if test="${totalMatches > 0}">

    <g:each in="${synsetList}" status="i" var="synset">

        <div style="margin-bottom: 10px;margin-top:16px">

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
                    <g:set var="lowercaseNormTerm2" value="${term.normalizedWord2?.toLowerCase()}"/>
                    <g:set var="lowercaseQuery" value="${params.q.toLowerCase()}"/>
                    <%-- keep in sync with SearchService.groovy: --%>
                    <g:set var="lowercaseQuery2" value="${lowercaseQuery.replaceAll('^(sich|etwas) ', '')}"/>

                    <%
                        long antonymTime = System.currentTimeMillis();
                    %>
                    <g:set var="antonymInfo" value=""/>
                    <g:set var="antonymTitle" value=""/>
                    <g:set var="termLinkInfos" value="${term.termLinkInfos()}"/>
                    <g:if test="${termLinkInfos.size() > 0}">
                        <g:set var="termLinkInfo" value="${term.termLinkInfos().get(0)}"/>
                        <g:if test="${termLinkInfo.linkName == message(code:'edit.link.antonym.db.name')}">
                            <g:set var="antonymInfo"><sup><a href="${termLinkInfo.term2.word.encodeAsURL()}"><span class="antonymMarker">G</span></a></sup></g:set>
                            <g:set var="antonymTitle"><g:message code="edit.antonym.title.attribute"
                                args="${[termLinkInfo.term2.word, termLinkInfo.term2.synset.toShortStringWithShortLevel(20, true)]}"/></g:set>
                        </g:if>
                    </g:if>
                    <%
                        long antonymTotalTime = System.currentTimeMillis() - antonymTime;
                    %>
                    <!-- time for antonyms: ${antonymTotalTime}ms -->

                    <span title="${antonymTitle}">
                        <g:if test="${substringMatchMode}">
                            <g:link action="search" params="${['q': StringTools.slashEscape(term.toString())]}"
                            >${displayTerm.replaceAll("(?i)(" + Pattern.quote(lowercaseQuery) + ")", "<span class='synsetmatch'>\$1</span>")}</g:link>${antonymInfo}${delim}
                        </g:if>
                        <g:elseif test="${lowercaseQuery == lowercaseTerm || lowercaseQuery == lowercaseNormTerm ||
                                lowercaseQuery2 == lowercaseTerm || lowercaseQuery2 == lowercaseNormTerm || lowercaseQuery == lowercaseNormTerm2}">
                            <span class="synsetmatch">${displayTerm}</span>${antonymInfo}${delim}
                        </g:elseif>
                        <g:else>
                            <g:link action="search" params="${['q': StringTools.slashEscape(term.toString())]}"
                            >${displayTerm}</g:link>${antonymInfo}${delim}
                        </g:else>
                    </span>

                    <g:set var="counter" value="${counter + 1}"/>
                </g:each>

                <g:set var="superSynsets" value="${[]}"/>
                <g:each in="${synset.synsetLinks}" var="synsetLink">
                    <g:if test="${synsetLink.linkType.linkName == message(code:'edit.link.super.synsets.db.name')}">
                        <%
                            superSynsets.add(synsetLink.targetSynset)
                        %>
                    </g:if>
                </g:each>
                <g:if test="${superSynsets}">
                    <div class="superordinate">
                        <span class="superordinateHead"><g:message code="edit.link.super.synsets"/></span>
                        <span class="superordinateTerms">
                            <g:render template="linkMatches" model="${[links:superSynsets, itemPrefix: 'span', itemSuffix: '/span', showSynsetDelimiter: true]}"/>
                        </span>
                    </div>
                </g:if>

                <g:set var="subSynsets" value="${[]}"/>
                <g:set var="moreSubSynsets" value="${[]}"/>
                <g:each in="${synset.sortedSynsetLinks()}" var="synsetLink">
                    <g:if test="${synsetLink.linkType.linkName == message(code:'edit.link.sub.synsets.db.name')}">
                        <g:if test="${subSynsets.size() < 3}">
                            <%
                                subSynsets.add(synsetLink.targetSynset)
                            %>
                        </g:if>
                        <g:else>
                            <%
                                moreSubSynsets.add(synsetLink.targetSynset)
                            %>
                        </g:else>
                    </g:if>
                </g:each>
                <g:if test="${subSynsets}">
                    <div class="superordinate">
                        <span class="superordinateHead"><g:message code="edit.link.sub.synsets"/></span>
                        <ul class="associationList">
                            <g:render template="linkMatches" model="${[links:subSynsets, itemPrefix: 'li', itemSuffix: '/li']}"/>
                            <g:if test="${moreSubSynsets}">
                                <li id="subSynsetShowLink${synset.id}"><a href="#" class="moreLessLink" onclick="$('subSynset${synset.id}').show();$('subSynsetShowLink${synset.id}').hide();return false;"><g:message code="result.link.show.all"/></a></li>
                            </g:if>
                        </ul>
                        <g:if test="${moreSubSynsets}">
                            <ul id="subSynset${synset.id}" class="associationList" style="display: none">
                                <g:render template="linkMatches" model="${[links:moreSubSynsets, itemPrefix: 'li', itemSuffix: '/li']}"/>
                                <li><a href="#" class="moreLessLink" onclick="$('subSynset${synset.id}').hide();$('subSynsetShowLink${synset.id}').show();return false;"><g:message code="result.link.show.less"/></a></li>
                            </ul>
                        </g:if>
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
                    <div class="associations">
                        <span class="superordinateHead"><g:message code="edit.link.associations"/></span>
                        <ul class="associationList">
                            <g:render template="linkMatches" model="${[links:associationSynsets, itemPrefix: 'li', itemSuffix: '/li']}"/>
                            <g:if test="${moreAssociationSynsets}">
                                <li id="associationShowLink${synset.id}"><a href="#" class="moreLessLink" onclick="$('association${synset.id}').show();$('associationShowLink${synset.id}').hide();return false;"><g:message code="result.link.show.all"/></a></li>
                            </g:if>
                        </ul>
                        <g:if test="${moreAssociationSynsets}">
                            <ul id="association${synset.id}" class="associationList" style="display: none">
                                <g:render template="linkMatches" model="${[links:moreAssociationSynsets, itemPrefix: 'li', itemSuffix: '/li']}"/>
                                <li><a href="#" class="moreLessLink" onclick="$('association${synset.id}').hide();$('associationShowLink${synset.id}').show();return false;"><g:message code="result.link.show.less"/></a></li>
                            </ul>
                        </g:if>
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
