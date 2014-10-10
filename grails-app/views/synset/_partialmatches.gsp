<%@page import="com.vionto.vithesaurus.tools.*" %>
					<h2 style="margin-top:0"><g:message code='result.matches.partial' /></h2>

                    <p class="similarMatches" style="margin-top:10px">
                    <g:each in="${similarTerms}" var="term" status="counter">
                        <g:if test="${counter < 5}">
                            <g:if test="${counter > 0}">
                              <span class="d">&middot;</span>
                            </g:if>
                            <g:link action="search" params="${[q: StringTools.slashEscape(term.term)]}">${term.term.encodeAsHTML()}</g:link>
                        </g:if>
                    </g:each>
                    <g:if test="${similarTerms.size() == 0}">
                        <span class="noMatches"><g:message code='result.matches.similar.nomatch' /></span>
                    </g:if>
                    </p>
