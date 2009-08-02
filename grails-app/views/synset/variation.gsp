<%@page import="com.vionto.vithesaurus.*" %>  
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title>${title}</title>
    </head>
    <body>

        <div class="body">
            
            <h1>${headline}</h1>
            
            <div style="float:right">
	            <g:render template="/ads/variation_right"/>
            </div>
            
            <p>${intro}</p>
            
			<ul>
				<g:each in="${termList}" var="term">
					<li><g:link action="search" params="${[q: term.normalizedWord]}"
						>${term.encodeAsHTML()}</g:link>
						<%
						int i = 0
						%>
						<g:each in="${term.synset.sortedTerms()}" var="synsetTerm">
							<g:if test="${i < 3 && synsetTerm.word.indexOf(term.word) == -1}">
								<span class="d">&middot;</span> ${synsetTerm.encodeAsHTML()}
								<%
								i++
								%>
							</g:if>
						</g:each>
					</li>
				</g:each>
			</ul>
			            
        </div>
    </body>
</html>
