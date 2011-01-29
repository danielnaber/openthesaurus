					<h2 style="margin-top:0px">Teilwort-Treffer und ähnliche Wörter</h2>

                    <p class="partialMatches">
                    <g:set var="moreSubstringTerms" value="${false}" />
                    <g:each in="${partialMatchResult}" var="term" status="counter">
                        <g:if test="${counter > 0 && counter < 8}">
                          <span class="d">&middot;</span>
                        </g:if>
                        <g:if test="${counter < 8}">
                            <g:link action="search" params="${[q: term.term]}">${term.highlightTerm}</g:link>
                        </g:if>
                        <g:else>
                            <g:set var="moreSubstringTerms" value="${true}" />
                        </g:else>
                    </g:each>
                    <g:if test="${partialMatchResult.size() == 0}">
                        <span class="noMatches">Kein Teilwort-Treffer</span>
                    </g:if>
                    <g:if test="${partialMatchResult.size() > 8}">
                        &nbsp;&nbsp;<g:link action="substring" params="${[q: params.q]}"><img src="../images/arrow-blue.png" alt="Mehr" />&nbsp;<g:message code="result.substring.more"/></g:link>
                    </g:if>
                    </p>

                    <p class="similarMatches" style="margin-top:10px">
                    <g:each in="${similarTerms}" var="term" status="counter">
                        <g:if test="${counter < 5}">
                            <g:if test="${counter > 0}">
                              <span class="d">&middot;</span>
                            </g:if>
                            <g:link action="search" params="${[q: term.term]}">${term.term}</g:link>
                        </g:if>
                    </g:each>
                    <g:if test="${similarTerms.size() == 0}">
                        <span class="noMatches">Keine ähnlichen Treffer</span>
                    </g:if>
                    </p>
