<%@page import="com.vionto.vithesaurus.*" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title><g:message code="tree.title" /></title>
    </head>
    <body>

        <div class="body">
            <h1><g:message code="tree.headline" /></h1>

            <g:if test="${flash.message}">
                <div class="message">${flash.message}</div>
            </g:if>
            
            <table style="border:0px">
            <tr>
            	<td><p><g:message code="tree.intro" /></p>

					<h2><g:message code="tree.nouns" /></h2>
					
					<ul class="tree">
						<li>
							<%=topNounSynset%>
						</li>
						<li>
							<ul class="tree">
								<%=nounTree%>
							</ul>
						</li>
					</ul>
					
					<h2><g:message code="tree.verbs" /></h2>

					<ul class="tree">
						<li>
							<%=topVerbSynset%>
						</li>
						<li>
							<ul class="tree">
								<%=verbTree%>
							</ul>
						</li>
					</ul>
            	
            	</td>
            	<td><g:render template="/ads/tree_right"/></td>
            </tr>
            </table>
             

            <div class="list">

<!-- 
		<ul class="tree">
		<li>durchführen, handeln, machen, realisieren, ...			
		<ul class="tree">
	<li>agieren, handeln, walten, wirken
	</li>
	<li> (sich) ändern, (sich) verändern, (sich) verwandeln, (sich) wandeln, ...
	</li>
	<li> aufweisen, besitzen, bieten, haben, ...
	</li>
	<li> (sich) austauschen, (sich) verständigen, kommunizieren
	</li>
	<li> sonstige Verben
	</li>
	<li> (sinnlich oder geistig) wahrnehmen
	</li>
	<li> sich körperlich betätigen
 -->
            
            
            </div>
            
            <g:render template="/ads/tree_bottom"/>

        </div>
    </body>
</html>
