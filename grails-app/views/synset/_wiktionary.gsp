					<h2><g:message code="result.wiktionary.headline"/></h2>
					<g:if test="${wiktionaryResult}">
						<%
						final String myMarker = "__ot__";
						clean =
						  { str -> str
						    .replaceAll(":*\\s*\\[(\\d*[a-z]?\\.?\\d*)\\]", myMarker + " \$1" + myMarker)
						    .replaceAll("\\[\\[([^\\]]*?)\\|([^\\]]*?)\\]\\]", "\$2")
                            .replaceAll("\\[\\[(.*?)\\]\\]", "\$1")

                            .replaceAll("\\{\\{(ugs|trans)[.:,](\\|:)?\\}\\}", myMarker + "\$1" + myMarker)
                            .replaceAll("\\{\\{refl\\.\\|:\\}\\}", myMarker + "{refl.}" + myMarker)

                            .replaceAll("\\{\\{(f|m|n)\\}\\}", myMarker + "{\$1}" + myMarker)

                            .replaceAll("&lt;sup&gt;", "<sup>")
                            .replaceAll("&lt;/sup&gt;", "</sup>")

                            .replaceAll("&lt;sub&gt;", "<sub>")
                            .replaceAll("&lt;/sub&gt;", "</sub>")

                            .replaceAll("&lt;ref&gt;.*?&lt;/ref&gt;", "")
                            .replaceAll("\\{\\{K\\|(.*?)\\}\\}", "[\$1]")
                            .replaceAll("\\{\\{QS Bedeutungen\\|(.*?)\\}\\}", "")
                            .replaceAll("&lt;nowiki&gt;.*?&lt;/nowiki&gt;", "")

							.replaceAll("\\{\\{([^}]*?)\\|[,;:]\\}\\}", "<span class='wiktionaryItem'>{\$1}</span>")
							.replaceAll("\\{\\{([^}]*?)\\}\\}", "<span class='wiktionaryItem'>{\$1}</span>")

                            .replaceAll("&amp;ndash;", "-")
                            .replaceAll("^:", "")
                            .replaceAll("&lt;/?small&gt;", "")
						    .replaceAll(myMarker + "(.*?)" + myMarker, "<span class='wiktionaryItem'>\$1.</span>")

							.replaceAll("\\[(.*?)\\]", "<span class='wiktionaryCategory'>[\$1]</span>")
						  };
						%>
						<g:if test="${wiktionaryResult.size() == 0}">
    						<span class="light"><g:message code="result.no.wiktionary.matches"/></span>
						</g:if>
						<g:else>
							<%
							String wiktionaryWord = wiktionaryResult.get(0);
							String meanings = wiktionaryResult.get(1).encodeAsHTML();
							meanings = clean(meanings);
							%>
								<p><b><g:message code="result.wiktionary.meanings"/></b><br/>
									<g:if test="${wiktionaryResult.get(1).trim().equals('')}">
										<span class="light"><g:message code="result.none"/></span>
										<g:set var="emptyMeanings" value="${true}"/>
									</g:if>
									<g:else>
										${meanings}
									</g:else>
                                </p>

								<p style="margin-top:10px"><b><g:message code="result.wiktionary.synonyms"/></b><br/>
									<g:if test="${wiktionaryResult.get(2).trim().equals('')}">
										<span class="light"><g:message code="result.none"/></span>
										<g:set var="emptySynonyms" value="${true}"/>
									</g:if>
									<g:else>
										<%
										String synonyms = wiktionaryResult.get(2).encodeAsHTML();
										synonyms = clean(synonyms);
										// TODO: make words links!
										%>
										${synonyms}
									</g:else>
                                </p>
							<g:if test="${wiktionaryResult.size() > 0 && ! (emptyMeanings && emptySynonyms)}">
								<div class="copyrightInfo">
									<a href="javascript:toggle('wiktionaryLicense')"><g:message code="result.wikipedia.license.link" /></a>
									<div id="wiktionaryLicense">
										<g:message code="result.wiktionary.license" args="${[wiktionaryWord.encodeAsURL(),wiktionaryWord,wiktionaryWord.encodeAsURL()]}"/>
									</div>
								</div>
							</g:if>
						</g:else>
					</g:if>
					<g:else>
					    <span class="noMatches"><g:message code="result.no.matches"/></span>
					</g:else>
