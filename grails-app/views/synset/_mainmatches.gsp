            <g:if test="${totalMatches > 0}">

                   <g:each in="${synsetList}" status="i" var="synset">
                        <li>
		                    <g:set var="counter" value="${0}"/>
                            <g:each in="${synset?.sortedTerms()}" var="term">
                            	<g:if test="${term.level}">
		                        	<g:set var="displayTerm" value="${term.toString() + ' (' + term.level?.shortLevelName + ')'}"/>
                            	</g:if>
                            	<g:else>
		                        	<g:set var="displayTerm" value="${term.toString()}"/>
                            	</g:else>
	                        	
	                        	<g:if test="${counter == synset?.sortedTerms()?.size() - 1}">
		                        	<g:set var="delim"><span class="d">&nbsp;&ndash;</span></g:set>
	                        	</g:if>
	                        	<g:else>
		                        	<g:set var="delim"><span class="d">&nbsp;&middot;</span></g:set>
	                        	</g:else>
	                        	
	                        	<g:if test="${params.q.toLowerCase() == term.toString().toLowerCase()}">
                                	<span class="synsetmatch">${displayTerm.encodeAsHTML()}</span>${delim}
	                        	</g:if>
	                        	<g:else>
			                        <g:link action="search" params="${['q': term.toString()]}"
			                        	>${displayTerm.encodeAsHTML()}</g:link>${delim}
	                        	</g:else>
	                        	
		                        <g:set var="counter" value="${counter + 1}"/>
                            </g:each>
	                   		<g:link action="edit" id="${synset.id}">
	                   			<span style="color:#888"><g:message code="result.edit"/></span>
    	               		</g:link>

                            <g:set var="superSynsetStrings" value="${[]}"/>
                            <g:each in="${synset.synsetLinks}" var="synsetLink">
                              <g:if test="${synsetLink.linkType.linkName == 'Oberbegriff'}">
                                <%
                                superSynsetStrings.add(synsetLink.targetSynset.toShortStringWithShortLevel(3, false))
                                %>
                              </g:if>
                            </g:each>
                            <g:if test="${superSynsetStrings}">
                              <br />
                              <span class="termMetaInfo">
                              Oberbegriffe:
                              ${superSynsetStrings.join(' | ')}</span>
                            </g:if>

                            <g:set var="categoryStrings" value="${[]}"/>
                            <g:if test="${synset.categoryLinks && synset.categoryLinks.size() > 0}">
                              <span class="termMetaInfo">
                              <g:each var='catLink' in='${synset.categoryLinks.sort()}'>
                                <%
                                categoryStrings.add(catLink.category)
                                %>
                              </g:each>
                              </span>
                            </g:if>
                            <g:if test="${categoryStrings}">
                              <br />
                              <span class="termMetaInfo">
                              <g:message code='edit.categories'/>
                              ${categoryStrings.join(' | ')}</span>
                            </g:if>


                        </li>
                   </g:each>
                   
            </g:if>
            <g:else>
            		<g:if test="${similarTerms.size > 0}">
            			<li><span class="light"><g:message code="result.no.matches.similar.words"/></span>
							<g:each in="${similarTerms}" var="term" status="counter">
								<g:if test="${counter < 3}">
									<g:link action="search" params="${[q: term.term]}">${term.term}</g:link>
									<g:if test="${counter < Math.min(2, similarTerms.size()-1)}">
										<span class="d">&middot;</span>
									</g:if>
								</g:if>
							</g:each>
            			</li>
            		</g:if>
            		<g:else>
	            		<li><span class="light"><g:message code="result.no.matches"/></span></li>
            		</g:else>
            </g:else>
