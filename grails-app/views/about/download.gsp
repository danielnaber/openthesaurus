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

		<div class="faqitem">
			
			<h1>Download der OpenThesaurus-Daten</h1>

			<p>Wegen der Umstellung von openthesaurus.de auf eine neue Software sind manche Daten
			derzeit nicht
			ganz aktuell. Demnächst werden wieder tägliche Daten zur Verfügung stehen.</p>			

			<p>
			<a href="../old/Deutscher-Thesaurus.oxt">Deutscher Thesaurus for OpenOffice.org 3.x, 2009-08-02</a><br/>
			<a href="../old/thes_de_DE_v2.zip">Deutscher Thesaurus for OpenOffice.org 2.x, 2009-08-02</a><br/>
			<a href="../old/thesaurus.txt.gz">Thesaurus im Text-Format, 2009-08-02</a><br/>
			<a href="../old/kword_thesaurus.txt.gz">Thesaurus für KWord, 2009-08-02</a>
			</p>
			
			<p>Für Entwickler:</p>
			<g:set var="sdf" value="${new SimpleDateFormat('yyyy-MM-dd HH:mm')}"/>
			<a href="../export/openthesaurus_dump.tar.bz2">MySQL-Dump, 
				exportiert ${sdf.format(new Date(dbDump.lastModified()))},
				${String.format("%.2f", dbDump.length()/1000/1000)}MB</a>
			</div>

		</div>

    </body>
</html>
