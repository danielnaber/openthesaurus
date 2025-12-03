<%@page import="com.vionto.vithesaurus.tools.*" %>
<g:if test="${totalMatches > 0}">

    <g:each in="${synsetList}" status="i" var="synset">
        <!--REALMATCHES-->

        <div style="margin-bottom: 10px">

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
                <div class="mainResult">
                    <g:set var="counter" value="${0}"/>
                    <g:set var="sortedTerms" value="${synset?.sortedTerms()}"/>
                    <g:each in="${sortedTerms}" var="term">
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

                        <g:if test="${counter == sortedTerms?.size() - 1}">
                            <g:set var="delim" />
                        </g:if>
                        <g:else>
                            <g:set var="delim"><span class="d">&middot;</span></g:set>
                        </g:else>

                        <g:set var="lowercaseTerm" value="${term.toString().toLowerCase()}"/>
                        <g:set var="lowercaseNormTerm" value="${term.normalizedWord?.toLowerCase()}"/>
                        <g:set var="lowercaseNormTerm2" value="${term.normalizedWord2?.toLowerCase()}"/>
                        <g:set var="lowercaseQuery" value="${params.q.toLowerCase()}"/>
                        <%-- keep in sync with SearchService.groovy: --%>
                        <g:set var="lowercaseQuery2" value="${lowercaseQuery.replaceAll('^(sich|etwas) ', '')}"/>
                        <g:set var="lowercaseQueryNorm" value="${StringTools.normalize(lowercaseQuery)}"/>

                        <g:set var="commentInfo" value=""/>
                        <g:if test="${term.userComment}">
                            <g:set var="commentInfo"><span title="${term.userComment.encodeAsHTML()}" class="commentMarker"><img src="${createLinkTo(dir:'images', file:'balloon16.png')}"></span></g:set>
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
                                <g:set var="antonymTitle"><g:message code="edit.term.antonym"/>: <a href='/synonyme/edit/${termLinkInfo.term2.synset.id}'>${termLinkInfo.term2.word}</a></g:set>
                                <g:set var="antonymInfo"><span class="antonymMarker" title="${antonymTitle}"><img src="${createLinkTo(dir:'images', file:'lightning16.png')}"/></span></g:set>
                            </g:if>
                        </g:if>
                        <%
                            long antonymTotalTime = System.currentTimeMillis() - antonymTime;
                        %>
                        <!-- time for antonyms: ${antonymTotalTime}ms -->

                        <span>
                            <g:if test="${lowercaseQuery == lowercaseTerm || lowercaseQuery == lowercaseNormTerm ||
                                    lowercaseQuery2 == lowercaseTerm || lowercaseQuery2 == lowercaseNormTerm || lowercaseQuery == lowercaseNormTerm2 ||
                                    lowercaseQueryNorm == lowercaseNormTerm || lowercaseQueryNorm == lowercaseNormTerm2}">
                                <span class="synsetmatch">${displayTerm}</span>${commentInfo}${antonymInfo}<g:render template="audio" model="${[term:term]}"/>${delim}
                            </g:if>
                            <g:else>
                                <g:link action="search" params="${['q': StringTools.slashEscape(term.toString())]}"
                                >${displayTerm}</g:link>${commentInfo}${antonymInfo}<g:render template="audio" model="${[term:term]}"/>${delim}
                            </g:else>
                        </span>

                        <g:set var="counter" value="${counter + 1}"/>
                    </g:each>

                    <g:link action="edit" id="${synset.id}">
                        <img class="editIcon" align="top" src="${resource(dir:'images',file:'edit.png')}" alt="edit icon" title="${message(code:'result.edit')}"/>
                    </g:link>

                </div>

                <g:set var="superSynsets" value="${[]}"/>
                <g:each in="${synset.synsetLinks}" var="synsetLink">
                    <g:if test="${synsetLink.linkType.linkName == message(code:'edit.link.super.synsets.db.name')}">
                        <%
                            superSynsets.add(synsetLink.targetSynset)
                        %>
                    </g:if>
                </g:each>

                <g:set var="subSynsets" value="${[]}"/>
                <g:set var="moreSubSynsets" value="${[]}"/>
                <g:set var="sortedSynsetLinks" value="${synset.sortedSynsetLinks()}"/>
                <g:each in="${sortedSynsetLinks}" var="synsetLink">
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

                <g:set var="associationSynsets" value="${[]}"/>
                <g:set var="moreAssociationSynsets" value="${[]}"/>
                <g:each in="${sortedSynsetLinks}" var="synsetLink">
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

                <%
                List otherTypes = []
                List otherTypeIds = []
                if (superSynsets.size() > 0) {
                    otherTypes.add(message(code:'edit.link.super.synsets'))
                    otherTypeIds.add("superordinates")
                }
                if (subSynsets.size() > 0) {
                    otherTypes.add(message(code:'edit.link.sub.synsets'))
                    otherTypeIds.add("subordinates")
                }
                if (associationSynsets.size() > 0) {
                    otherTypes.add(message(code:'edit.link.associations'))
                    otherTypeIds.add("associations")
                }
                %>
                <g:if test="${otherTypes.size() == 1}">
                    <a class="superSubAssocLink" href="javascript:toggleAndTrack('superSubAssocDiv${synset.id}', 'superSubAssocLink clicked')">${otherTypes[0]} anzeigen</a>
                </g:if>
                <g:if test="${otherTypes.size() == 2}">
                    <a class="superSubAssocLink" href="javascript:toggleAndTrack('superSubAssocDiv${synset.id}', 'superSubAssocLink clicked')">${otherTypes[0]} &amp; ${otherTypes[1]} anzeigen</a>
                </g:if>
                <g:if test="${otherTypes.size() == 3}">
                    <a class="superSubAssocLink" href="javascript:toggleAndTrack('superSubAssocDiv${synset.id}', 'superSubAssocLink clicked')">${otherTypes[0]}, ${otherTypes[1]} &amp; ${otherTypes[2]} anzeigen</a>
                </g:if>

                <div id="superSubAssocDiv${synset.id}" style="display: none">

                    <g:if test="${superSynsets}">
                        <div class="superordinate" id="superordinates">
                            <span class="superordinateHead"><g:message code="edit.link.super.synsets"/></span>
                            <ul class="associationList">
                                <li><g:render template="linkMatches" model="${[links:superSynsets, itemPrefix: 'span', itemSuffix: '/span', showSynsetDelimiter: true]}"/></li>
                            </ul>
                        </div>
                    </g:if>

                    <g:if test="${subSynsets}">
                        <div class="superordinate" id="subordinates">
                            <span class="superordinateHead"><g:message code="edit.link.sub.synsets"/></span>
                            <ul class="associationList">
                                <g:render template="linkMatches" model="${[links:subSynsets, itemPrefix: 'li', itemSuffix: '/li']}"/>
                                <g:if test="${moreSubSynsets}">
                                    <li id="subSynsetShowLink${synset.id}"><a href="#" class="moreLessLink" onclick="$('#subSynset${synset.id}').show();$('#subSynsetShowLink${synset.id}').hide();return false;"><g:message code="result.link.show.all"/></a></li>
                                </g:if>
                            </ul>
                            <g:if test="${moreSubSynsets}">
                                <ul id="subSynset${synset.id}" class="associationList" style="display: none">
                                    <g:render template="linkMatches" model="${[links:moreSubSynsets, itemPrefix: 'li', itemSuffix: '/li']}"/>
                                    <li><a href="#" class="moreLessLink" onclick="$('#subSynset${synset.id}').hide();$('#subSynsetShowLink${synset.id}').show();return false;"><g:message code="result.link.show.less"/></a></li>
                                </ul>
                            </g:if>
                        </div>
                    </g:if>

                    <g:if test="${associationSynsets}">
                        <div class="associations" id="associations">
                            <span class="superordinateHead"><g:message code="edit.link.associations"/></span>
                            <ul class="associationList">
                                <g:render template="linkMatches" model="${[links:associationSynsets, itemPrefix: 'li', itemSuffix: '/li']}"/>
                                <g:if test="${moreAssociationSynsets}">
                                    <li id="associationShowLink${synset.id}"><a href="#" class="moreLessLink" onclick="$('#association${synset.id}').show();$('#associationShowLink${synset.id}').hide();return false;"><g:message code="result.link.show.all"/></a></li>
                                </g:if>
                            </ul>
                            <g:if test="${moreAssociationSynsets}">
                                <ul id="association${synset.id}" class="associationList" style="display: none">
                                    <g:render template="linkMatches" model="${[links:moreAssociationSynsets, itemPrefix: 'li', itemSuffix: '/li']}"/>
                                    <li><a href="#" class="moreLessLink" onclick="$('#association${synset.id}').hide();$('#associationShowLink${synset.id}').show();return false;"><g:message code="result.link.show.less"/></a></li>
                                </ul>
                            </g:if>
                        </div>
                    </g:if>

                </div>

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
