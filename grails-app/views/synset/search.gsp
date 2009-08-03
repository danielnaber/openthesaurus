<%@page import="com.vionto.vithesaurus.*" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title><g:message code='result.matches.for.title' args="${[params.q.encodeAsHTML()]}"/></title>
    </head>
    <body>

        <div class="body">

			<div style="float:right">
				<g:render template="/ads/resultpage"/>
			</div>

            <h1><g:message code='result.matches.for' args="${[params.q.encodeAsHTML()]}"/></h1>

            <g:if test="${flash.message}">
                <div class="message">${flash.message}</div>
            </g:if>

			<div style="width:60%;border:1px">
            <ul>
            
            <g:if test="${totalMatches > 0}">

                   <g:each in="${synsetList}" status="i" var="synset">
                        <li>
		                    <g:set var="counter" value="${0}"/>
                            <g:each in="${synset?.sortedTerms()?.sort()}" var="term">
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
	                   			[edit]
    	               		</g:link>
                        </li>
                   </g:each>
                   
            </g:if>
            <g:else>
            		<li><span class="light"><g:message code="result.no.matches"/></span></li>
            </g:else>
            
            </ul>
			</div>

            <g:if test="${totalMatches > 0}">
             	<g:render template="/ads/resultpage_results"/>
            </g:if>	
			
			<br />
			
			<table class="invisibletable" width="100%">
			<tr>
				<td width="45%">
					
					<h2><g:message code="result.partialmatches.headline"/></h2>
					<ul>
						<g:each in="${partialMatchResult}" var="term">
							<li><g:link action="search" params="${[q: term.term]}">${term.highlightTerm}</g:link></li>
						</g:each>
						<g:if test="${partialMatchResult.size() == 0}">
							<li><span class="light"><g:message code="result.no.matches"/></span></li>
						</g:if>
					</ul>

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
					
				<td></td>
				<td width="45%">
					
					<g:if test="${wikipediaResult}">
						<h2><g:message code="result.wikipedia.headline"/></h2>
						<ul>
							<li>
							<% int i = 0; %>
							<g:each in="${wikipediaResult}" var="term">
								<g:if test="${i < wikipediaResult.size() - 1}">
									<g:link action="search" params="${[q: term]}">${term.encodeAsHTML()}</g:link><span class="d">&nbsp;&middot;</span>
								</g:if>
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
								<g:message code="result.wikipedia.license" args="${[params.q.encodeAsURL(),params.q.encodeAsHTML(),params.q.encodeAsURL()]}"/>
							</div>
						</g:if>
					</g:if>

					<g:if test="${wiktionaryResult}">
						<h2><g:message code="result.wiktionary.headline"/></h2>
						<ul>
							<%
							clean =
							  { str -> str
							    .replaceAll(":\\[(\\d+\\.?\\d*)\\]", "__\$1__")
							    .replaceAll("\\[\\[(.*?)\\]\\]", "\$1")
							    .replaceAll("__(\\d+\\.?\\d*)__", "<span class='wiktionary'>\$1.</span>")
							  };
							%>
							<g:if test="${wiktionaryResult.size() == 0}">
								<li><span class="light"><g:message code="result.no.wiktionary.matches"/></span></li>
							</g:if>
							<g:else>
								<%
								String meanings = wiktionaryResult.get(0).encodeAsHTML();
								meanings = clean(meanings);
								// TODO: make words links!
								%>
								<li><b><g:message code="result.wiktionary.meanings"/></b>
									<g:if test="${wiktionaryResult.get(1).trim().equals('')}">
										<span class="light"><g:message code="result.none"/></span>
										<g:set var="emptyMeanings" value="${true}"/>
									</g:if>
									<g:else>
										${meanings}
									</g:else>
								</li>
								<li><b><g:message code="result.wiktionary.synonyms"/></b>
									<g:if test="${wiktionaryResult.get(1).trim().equals('')}">
										<span class="light"><g:message code="result.none"/></span>
										<g:set var="emptySynonyms" value="${true}"/>
									</g:if>
									<g:else>
										<%
										String synonyms = wiktionaryResult.get(1).encodeAsHTML();
										synonyms = clean(synonyms);
										// TODO: make words links!
										%>
										${synonyms}</li>
									</g:else>
							</g:else>
						</ul>
						<g:if test="${wiktionaryResult.size() > 0 && ! (emptyMeanings && emptySynonyms)}">
							<div class="copyrightInfo">
								<g:message code="result.wiktionary.license" args="${[params.q.encodeAsURL(),params.q.encodeAsHTML(),params.q.encodeAsURL()]}"/>
							</div>
						</g:if>
					</g:if>
					
				</td>
			</tr>
			</table>			

			<%--
            <g:if test="${totalMatches == 0 && params.q && !(params.q.endsWith('%') || params.q.endsWith('_')) }">
                <br />
                <g:set var="noJokerTerm" value="${params.q.trim().replaceAll('%$', '').replaceAll('_$', '')}" />
                <g:link action="search" params="[q : noJokerTerm + '%',
                        'section.id': params['section.id'],
                        'category.id': params['category.id'],
                        'source.id': params['source.id']]">
                    <img src="../images/skin/information.png" alt="Add icon" />
                    <b>Search for '${params.q.encodeAsHTML()}%'</b>
                </g:link>
                <br />
                <g:link action="search" params="[q : noJokerTerm + '_',
                        'section.id': params['section.id'],
                        'category.id': params['category.id'],
                        'source.id': params['source.id']]">
                    <img src="../images/skin/information.png" alt="Add icon" />
                    <b>Search for '${params.q.encodeAsHTML()}_'</b>
                </g:link>
            </g:if>
            --%>

            <br/>
            <p>
                <g:if test="${params.q}">
                    <g:set var="cleanTerm" value="${params.q.trim().replaceAll('[*%~]', '').replaceAll('[*_~]', '')}" />
                    <g:link action="create" params="[term : cleanTerm]">
                        <img src="../images/skin/database_add.png" alt="Add icon" />
                        <g:message code="result.create.synset" args="${[cleanTerm.encodeAsHTML()]}" />
                    </g:link>
                </g:if>
                <g:else>
                    <g:link action="create"><g:message code="result.create.new.synset"/></g:link>
                </g:else>
            </p>

        </div>
    </body>
</html>
