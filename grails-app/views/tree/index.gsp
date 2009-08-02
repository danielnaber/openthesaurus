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
            	<td><p><g:message code="tree.intro" /></p></td>
            	<td><g:render template="/ads/tree_right"/></td>
            </tr>
            </table>
             

            <div class="list">

			<!-- TODO: make this list dynamic again -->
            <ul class="tree">
			<li>Irgendetwas		<ul class="tree">
			<li> Aktion, Handlung, Operation, Tat</li>
			<li> Befindlichkeit, Konstitution, Stand, Status, ...</li>
			<li> Begebenheit, Ereignis, Geschehnis, Vorfall, ...</li>
			<li> Bündelung, Clusterung, Gruppierung</li>
			<li> Entität, Instanz</li>
			<li> Abstraktion</li>
			<li> Darbietung, Event, Fest, Veranstaltung, ...</li>
			<li> Freizeitaktivität, Hobby, Steckenpferd
			</li>
			</ul>
			</li>
			</ul>

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

	</li>
	</ul>
		</li>
	</ul>
            
            
            </div>
            
            <g:render template="/ads/tree_bottom"/>

        </div>
    </body>
</html>
