<%@page import="java.text.*" %>
<%@page import="com.vionto.vithesaurus.*" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title><g:message code="download.title" /></title>
    </head>
    <body>

        <div class="body">

			<h1>Download der OpenThesaurus-Daten</h1>

			<p>Wegen der Umstellung von openthesaurus.de auf eine neue Software sind manche Daten
			derzeit nicht
			ganz aktuell. Demnächst werden wieder aktuellere Daten zur Verfügung stehen.</p>			

			<g:set var="sdf" value="${new SimpleDateFormat('yyyy-MM-dd HH:mm')}"/>

			<ul>
			<li><a href="../export/${oooDump.getName()}">Deutscher Thesaurus for OpenOffice.org 3.x 
				exportiert ${sdf.format(new Date(oooDump.lastModified()))},
				${String.format("%.2f", oooDump.length()/1000/1000)}MB</a></li>
			
			<li><a href="../old/thes_de_DE_v2.zip">Deutscher Thesaurus for OpenOffice.org 2.x, 2009-08-02</a> (wird nicht mehr aktualisiert)</li>
			
			<li><a href="../export/${textDump.getName()}">Thesaurus im Text-Format, gezippt,
				exportiert ${sdf.format(new Date(textDump.lastModified()))},
				${String.format("%.2f", textDump.length()/1000/1000)}MB</a></li>
			
			<li><a href="../old/kword_thesaurus.txt.gz">Thesaurus für KWord, 2009-08-02</a> (wird nicht mehr aktualisiert)</li>
			
			<li>Für Entwickler:
				<a href="../export/${dbDump.getName()}">MySQL-Dump, 
					exportiert ${sdf.format(new Date(dbDump.lastModified()))},
					${String.format("%.2f", dbDump.length()/1000/1000)}MB</a>
					- siehe auch <a href="api">API-Zugriff</a>
					</li>
			</ul>

		</div>

    </body>
</html>
