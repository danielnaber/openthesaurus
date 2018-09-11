<%@page import="com.vionto.vithesaurus.tools.*" %>

                    <div class="main-content-section-heading">
                        <g:message code="result.matches.partial"/>
                    </div>

                    <g:set var="moreSubstringTerms" value="${false}" />

                    <div class="wordtags">
                    <g:each in="${partialMatchResult}" var="term" status="counter">
                        <g:if test="${counter > 0 && counter < 8}">
                          <span class="d">&nbsp;&middot;&nbsp;</span>
                        </g:if>
                        <g:if test="${counter < 8}">
                            <span class="word word-dot"><g:link action="search" params="${[q: StringTools.slashEscape(term.term)]}">${term.highlightTerm}</g:link></span>
                        </g:if>
                        <g:else>
                            <g:set var="moreSubstringTerms" value="${true}" />
                        </g:else>
                    </g:each>
                    </div>

                    <g:if test="${partialMatchResult.size() == 0}">
                        <span class="noMatches"><g:message code='result.matches.partial.nomatch' /></span>
                    </g:if>
                    <g:if test="${partialMatchResult.size() > 8}">
                        <g:link action="substring" params="${[q: params.q]}"><g:message code="result.substring.more"/></g:link>
                    </g:if>

                    <div class="wordtags">
                    <g:each in="${similarTerms}" var="term" status="counter">
                        <g:if test="${counter < 5}">
                            <g:if test="${counter > 0}">
                              <span class="d">&nbsp;&middot;&nbsp;</span>
                            </g:if>
                            <g:link action="search" params="${[q: StringTools.slashEscape(term.term)]}">${term.term.encodeAsHTML()}</g:link>
                        </g:if>
                    </g:each>
                    <g:if test="${similarTerms.size() == 0}">
                        <span class="noMatches"><g:message code='result.matches.similar.nomatch' /></span>
                    </g:if>
                    </div>
