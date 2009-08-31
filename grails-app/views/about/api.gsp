<%@page import="com.vionto.vithesaurus.*" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title><g:message code="api.title" /></title>
    </head>
    <body>

        <div class="body">

		<h1>API-Zugriff</h1>
		
		<p>Viele Daten dieser Website können direkt über eine HTTP-Schnittstelle
		abgefragt werden. Bisher wird nur die direkte Suche nach Synonymen
		unterstützt. Noch nicht unterstützt werden Ähnlichkeitssuche, Suche
		nach Teilworten und Wikipedia/Wiktionary-Suche.</p>
		
		<p><strong>Achtung, das Ausgabe-Format kann sich unter Umständen noch ändern!</strong></p>
		
		<h2>Suchanfrage</h2>
		
		<p>Mit der folgenden HTTP-Anfrage via GET können alle Synonymgruppen,
		die das Wort <span class="bsp">query</span> beinhalten, abgefragt werden.</p>
		
		<pre>http://www.openthesaurus.de/synset/search?q=<strong>query</strong>&amp;format=text/xml</pre>
		
		<h2>Ergebnis</h2>
		
		<p>Das Ergebnis der Anfrage ist eine XML-Datei mit folgendem Format:</p>
		
<pre>
&lt;matches>
  &lt;metaData>
    &lt;apiVersion content="0.1.1"/>
    &lt;warning content="WARNING -- this API is in beta -- the format may change without warning!"/>
    &lt;copyright content="Copyright (C) 2009 Daniel Naber (www.danielnaber.de)"/>
    &lt;license content="GNU LESSER GENERAL PUBLIC LICENSE Version 2.1"/>
    &lt;source content="http://www.openthesaurus.de"/>
    &lt;date content="Mon Aug 31 22:55:18 CEST 2009"/>
  &lt;/metaData>
  &lt;synset id="1234">
    &lt;categories>
      &lt;category name="Name der Kategorie"/>
    &lt;/categories>
    &lt;term term="Bedeutung 1, Wort 1"/>
    &lt;term term="Bedeutung 1, Wort 2"/>
  &lt;/synset>
  &lt;synset id="2345">
    &lt;categories/>
    &lt;term term="Bedeutung 2, Wort 1"/>
  &lt;/synset>
&lt;/matches>
</pre>

		<h2>Download</h2>
		
		<p>Zusätzlich zur direkten Abfrage stehen weiterhin
		<g:link action="download">Downloads</g:link> der gesamten Datenbank zur Verfügung.</p>
		
		</div>

    </body>
</html>
