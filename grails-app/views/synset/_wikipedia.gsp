					<h2 style="margin-top:0px"><g:message code="result.wikipedia.headline"/></h2>
					<g:if test="${wikipediaResult}">
						<ul>
							<li>
							<% int i = 0; %>
							<g:each in="${wikipediaResult}" var="term">
								<g:if test="${i == 0}">	<%-- skipping title --%>
									<g:set var="wikipediaTitle" value="${term}"/>
								</g:if>
								<g:elseif test="${i > 0 && i < wikipediaResult.size() - 1}">
									<g:link action="search" params="${[q: term]}">${term.encodeAsHTML()}</g:link><span class="d">&nbsp;&middot;</span>
								</g:elseif>
								<g:else>
									<g:link action="search" params="${[q: term]}">${term.encodeAsHTML()}</g:link>
								</g:else>
								<% i++; %>
							</g:each>
							</li>
							<g:if test="${wikipediaResult.size() == 0}">
								<li><span class="light"><g:message code="result.no.wikipedia.matches"/></span></li>
							</g:if>
						</ul>
						<g:if test="${wikipediaResult.size() > 0}">
							<div class="copyrightInfo">
								<g:message code="result.wikipedia.license" 
									args="${[wikipediaTitle.replaceAll(' ', '_').encodeAsURL(),wikipediaTitle.encodeAsHTML(),wikipediaTitle.encodeAsURL()]}"/>
							</div>
						</g:if>
					</g:if>
					<g:else>
						<ul>
							<li><span class="light"><g:message code="result.no.matches"/></span></li>
						</ul>
					</g:else>
