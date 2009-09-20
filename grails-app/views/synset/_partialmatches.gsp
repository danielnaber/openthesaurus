					<h2 style="margin:0px"><g:message code="result.partialmatches.headline"/></h2>
					<ul>
						<g:set var="moreSubstringTerms" value="${false}" />
						<g:each in="${partialMatchResult}" var="term" status="counter">
							<g:if test="${counter < 10}">
								<li><g:link action="search" params="${[q: term.term]}">${term.highlightTerm}</g:link></li>
							</g:if>
							<g:else>
								<g:set var="moreSubstringTerms" value="${true}" />
							</g:else>
						</g:each>
						<g:if test="${partialMatchResult.size() == 0}">
							<li><span class="light"><g:message code="result.no.matches"/></span></li>
						</g:if>
						<g:if test="${partialMatchResult.size() > 10}">
							<li><g:link action="substring" params="${[q: params.q]}"><g:message code="result.substring.more"/></g:link></li>
						</g:if>
					</ul>
