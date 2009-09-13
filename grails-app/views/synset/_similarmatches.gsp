					<h2><g:message code="result.similarmatches.headline"/></h2>
					<ul>
						<g:each in="${similarTerms}" var="term" status="counter">
							<g:if test="${counter < 5}">
								<li><g:link action="search" params="${[q: term.term]}">${term.term}</g:link></li>
							</g:if>
						</g:each>
						<g:if test="${similarTerms.size() == 0}">
							<li><span class="light"><g:message code="result.no.matches"/></span></li>
						</g:if>
					</ul>
