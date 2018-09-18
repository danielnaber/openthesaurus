
					<div class="main-content-section-heading">
						<g:message code="result.wiktionary.headline"/>
					</div>

					<div class="wiktionary-results">
						<g:if test="${wiktionaryResult}">
							<%
								final String myMarker = "__ot__";
								clean =
									{ str -> str
										.replaceAll(":*\\s*\\[(\\d*[a-z]?\\.?\\d*)\\]", myMarker + "\$1" + myMarker)
										.replaceAll("\\[\\[([^\\]]*?)\\|([^\\]]*?)\\]\\]", "\$2")
										.replaceAll("\\[\\[(.*?)\\]\\]", "\$1")

										.replaceAll("\\{\\{(ugs|trans)[.:,](\\|:)?\\}\\}", myMarker + "\$1" + myMarker)
										.replaceAll("\\{\\{refl\\.\\|:\\}\\}", myMarker + "{refl.}" + myMarker)

										.replaceAll("\\{\\{(f|m|n)\\}\\}", myMarker + "{\$1}" + myMarker)

										.replaceAll("&lt;sup&gt;", "<sup>")
										.replaceAll("&lt;/sup&gt;", "</sup>")

										.replaceAll("&lt;sub&gt;", "<sub>")
										.replaceAll("&lt;/sub&gt;", "</sub>")

										.replaceAll("^:", "")
										.replaceAll("&lt;/?small&gt;", "")
									
										.replaceAll("\\{\\{[A-Z]\\|(.*?)\\}\\}", '($1)')
										.replaceAll("&lt;ref.*?&gt;", '')
										.replaceAll("&lt;/ref&gt;", '')

										// markup
										.trim()
										.replaceAll(myMarker + "(.*?)" + myMarker, '<span class="words-list-item__number">\$1.</span>')
										.replaceAll('(</span>)(.+?)(<span|\$)', '\$1<span class="words-list-item__word">\$2</span>\$3')
										.replaceAll('(<span class="words-list-item__number">.+?</span>).*?(<span class="words-list-item__word">.+?</span>)', '<li class="words-list__item words-list-item">\$1\$2</li>')
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

								<div class="wiktionary-results__block">
									<div class="main-content-section-block-heading">
										<g:message code="result.wiktionary.meanings"/>
									</div>
								
									<g:if test="${wiktionaryResult.get(1).trim().equals('')}">
										<span class="light"><g:message code="result.none"/></span>
										<g:set var="emptyMeanings" value="${true}"/>
									</g:if>
									<g:else>
										<ol class="words-list words-list--meanings">
											${meanings}
										</ol>
									</g:else>
								</div>

								<div class="wiktionary-results__block">
									<div class="main-content-section-block-heading">
										<g:message code="result.wiktionary.synonyms"/>
									</div>

									<g:if test="${wiktionaryResult.get(2).trim().equals('')}">
										<g:message code="result.none"/>
										<g:set var="emptySynonyms" value="${true}"/>
									</g:if>
									<g:else>
										<%
										String synonyms = wiktionaryResult.get(2).encodeAsHTML();
										synonyms = clean(synonyms);
										synonyms = synonyms.replaceAll("&lt;ref.*?&gt;.*?&lt;/ref&gt;", "");
										synonyms = synonyms.replaceAll("&lt;ref.*?/&gt;", "");
										// TODO: make words links!
										%>
										<ol class="words-list words-list--synonyms">
											${synonyms}
										</ol>
									</g:else>
								</div>

								<g:if test="${wiktionaryResult.size() > 0 && ! (emptyMeanings && emptySynonyms)}">
									<div class="main-content-section-note">
										<div class="main-content-section-note-item">
											<g:message code="result.wiktionary.license" args="${[wiktionaryWord.encodeAsURL(),wiktionaryWord,wiktionaryWord.encodeAsURL()]}"/>
										</div>
									</div>
								</g:if>
							</g:else>
						</g:if>
						<g:else>
								<span class="noMatches"><g:message code="result.no.matches"/></span>
						</g:else>
					</div>
