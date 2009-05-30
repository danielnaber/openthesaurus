<%@page import="com.vionto.vithesaurus.*" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title>Matches for '${params.q.encodeAsHTML()}'</title>
    </head>
    <body>

        <div class="body">

           <h1>Matches for '${params.q.encodeAsHTML()}'</h1>

            <g:if test="${flash.message}">
                <div class="message">${flash.message}</div>
            </g:if>

			<div style="width:60%;border:1px">
            <g:if test="${totalMatches > 0}">

                   <ul>
	                   <g:each in="${synsetList}" status="i" var="synset">
	                        <li>
	                        	<!-- TODO: highlight match -->
			                    <g:set var="counter" value="${0}"/>
	                            <g:each in="${synset?.otherTerms()?.sort()}" var="term">
		                        	<g:if test="${counter == synset?.otherTerms()?.size() - 1}">
			                        	<g:set var="displayTerm" value="${term.toString()}"/>
		                        	</g:if>
		                        	<g:else>
			                        	<g:set var="displayTerm" value="${term.toString()},"/>
		                        	</g:else>
		                        	
		                        	<g:if test="${params.q.toLowerCase() == term.toString().toLowerCase()}">
	                                	<span class="match">${displayTerm.encodeAsHTML()}</span>
		                        	</g:if>
		                        	<g:else>
				                        <g:link action="search" params="${['q': term.toString()]}">
		                                	${displayTerm.encodeAsHTML()}
				                        </g:link>
		                        	</g:else>
		                        	
			                        <g:set var="counter" value="${counter + 1}"/>
	                            </g:each>
	                   		<g:link action="edit" id="${synset.id}">
	                   			[edit]
	                   		</g:link>
	                        </li>
	                   </g:each>
                   </ul>

            </g:if>
			</div>

			<br />
			<br />
			
			<table width="100%">
			<tr>
				<td width="45%">
					<h2><g:message code="result.partialmatches.headline"/></h2>
					TODO: highlighting!
					<ul>
						<g:each in="${partialMatchResult}" var="term">
							<li><g:link action="search" params="${[q: term]}">${term.encodeAsHTML()}</g:link></li>
						</g:each>
					</ul>
				<td></td>
				<td width="45%">
					<h2><g:message code="result.wikipedia.headline"/></h2>
					<ul>
						<g:each in="${wikipediaResult}" var="term">
							<li><g:link action="search" params="${[q: term]}">${term.encodeAsHTML()}</g:link></li>
						</g:each>
					</ul>
					<g:message code="result.wikipedia.license" args="${[params.q.encodeAsURL(),params.q.encodeAsHTML(),params.q.encodeAsURL()]}"/>
				</td>
			</tr>
			</table>			

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

            <br/>
            <p>
                <g:if test="${params.q}">
                    <g:set var="cleanTerm" value="${params.q.trim().replaceAll('[*%~]', '').replaceAll('[*_~]', '')}" />
                    <g:link action="create" params="[term : cleanTerm]">
                        <img src="../images/skin/database_add.png" alt="Add icon" />
                        <b>Create a new concept with the term '${cleanTerm.encodeAsHTML()}'</b>
                    </g:link>
                </g:if>
                <g:else>
                    <g:link action="create"><b>Create a new concept</b></g:link>
                </g:else>
            </p>

            <p class="metaInfo"><br />Search time: ${runTime}ms</p>

        </div>
    </body>
</html>
