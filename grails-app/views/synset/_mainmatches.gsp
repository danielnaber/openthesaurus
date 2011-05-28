            <g:if test="${totalMatches > 0}">

                   <g:each in="${synsetList}" status="i" var="synset">

                      <div style="margin-bottom: 10px;margin-top:0px">

                            <g:set var="superSynsetStrings" value="${[]}"/>
                            <g:each in="${synset.synsetLinks}" var="synsetLink">
                              <g:if test="${synsetLink.linkType.linkName == 'Oberbegriff'}">
                                <%
                                superSynsetStrings.add(synsetLink.targetSynset.toShortStringWithShortLevel(3, false))
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
                              <div class="superordinate" />
                            </g:else>

                            <g:set var="categoryStrings" value="${[]}"/>
                            <g:if test="${synset.categoryLinks && synset.categoryLinks.size() > 0}">
                              <g:each var='catLink' in='${synset.categoryLinks.sort()}'>
                                <%
                                categoryStrings.add(catLink.category)
                                %>
                              </g:each>
                            </g:if>
                            <g:if test="${categoryStrings}">
                              <div class="category">
                                <span class="categoryHead"><g:message code='edit.categories'/></span>
                                <span class="categoryTerm">${categoryStrings.join(' | ')}</span>
                              </div>
                            </g:if>

                            <span class="result">
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
                                    <g:if test="${session.user}">
                                      <g:set var="delim"><span class="d">&nbsp;&ndash;</span></g:set>
                                    </g:if>
                                    <g:else>
                                      <g:set var="delim" />
                                    </g:else>
	                        	</g:if>
	                        	<g:else>
		                        	<g:set var="delim"><span class="d">&nbsp;&middot;</span></g:set>
	                        	</g:else>

	                        	<g:if test="${params.q.toLowerCase() == term.toString().toLowerCase() || params.q.toLowerCase() == term.normalizedWord?.toLowerCase()}">
                                	<span class="synsetmatch">${displayTerm}</span>${delim}
	                        	</g:if>
	                        	<g:else>
			                        <g:link action="search" params="${['q': term.toString()]}"
			                        	>${displayTerm}</g:link>${delim}
	                        	</g:else>

		                        <g:set var="counter" value="${counter + 1}"/>
                            </g:each>
                              <g:link action="edit" id="${synset.id}">
                                <g:if test="${session.user}">
                                  <span class="changeLink"><g:message code="result.edit"/></span>
                                </g:if>
                                <g:else>
                                  <span class="changeLink"><g:message code="result.details"/></span>
                                </g:else>
                              </g:link>
                            </span>

                        </div>
                   </g:each>
                   
            </g:if>
            <g:else>
            		<g:if test="${similarTerms.size > 0}">
            			<div style="margin-bottom:20px"><g:message code="result.no.matches.similar.words"/><br/>
							<g:each in="${similarTerms}" var="term" status="counter">
								<g:if test="${counter < 3}">
									<g:link action="search" params="${[q: term.term]}">${term.term}</g:link>
									<g:if test="${counter < Math.min(2, similarTerms.size()-1)}">
										<span class="d">&middot;</span>
									</g:if>
								</g:if>
							</g:each>
                        </div>
            		</g:if>
            		<g:else>
	            		<div style="margin-bottom:20px;font-weight:bold"><g:message code="result.no.matches"/></div>
            		</g:else>
            </g:else>
