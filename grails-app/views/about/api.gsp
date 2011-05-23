<%@page import="com.vionto.vithesaurus.*" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title><g:message code="api.title" /></title>
        <meta name="description" content="Beschreibung, wie Daten von OpenThesaurus über eine HTTP-Schnittstelle abgefragt werden können."/>
    </head>
    <body>

        <hr />

		<h2>API-Zugriff</h2>
		
		<p>Viele Daten dieser Website können direkt über eine HTTP-Schnittstelle
		abgefragt werden. Bisher wird die Suche nach Wörtern, Teilwörtern und nach ähnlich geschriebenen Wörtern
		unterstützt. Noch nicht unterstützt wird die Wikipedia/Wiktionary-Suche.</p>
		
		<p><strong>Hinweis: das Ausgabe-Format kann sich ändern. Es wird jedoch nur erweitert,
        bestehende Teile werden nicht ohne Ankündigung geändert.</strong></p>
		
		<h2>Suchanfrage</h2>
		
		<p>Mit der folgenden HTTP-Anfrage via GET können alle Synonymgruppen,
		die das Wort <span class="bsp">test</span> beinhalten, abgefragt werden:</p>
		
		<pre class="api"><a href="${createLinkTo(dir:'synonyme')}/search?q=test&amp;format=text/xml">http://www.openthesaurus.de/synonyme/search?q=<strong>test</strong>&amp;format=text/xml</a></pre>

        <p>Kommt im Suchwort ein Sonderzeichen vor, muss es mit UTF-8 URL-kodiert werden (z.B. wird <tt>hören</tt> zu <tt>h%C3%B6ren</tt>).</p>
		
		<h2>Ergebnis</h2>
		
		<p>Das Ergebnis der Anfrage ist eine XML-Datei mit folgendem Format:</p>
		
<pre class="api">
&lt;matches>
  &lt;metaData>
    &lt;apiVersion content="0.1.3"/>
    &lt;warning content="WARNING -- this API is in beta -- the format may change without warning!"/>
    &lt;copyright content="Copyright (C) 2009 Daniel Naber (www.danielnaber.de)"/>
    &lt;license content="GNU LESSER GENERAL PUBLIC LICENSE Version 2.1"/>
    &lt;source content="http://www.openthesaurus.de"/>
    &lt;date content="Sat Mar 06 22:47:25 CET 2010"/>
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

        <h2>Optionen</h2>

        <ul class="apioptions">
          <li><span class="apioption">format=text/xml</span>: Aktiviert den API-Modus, so dass die Antwort als XML zurückgeliefert wird. Andere
            Formate werden derzeit nicht unterstützt.</li>
          <li><span class="apioption">similar=true</span>: Hiermit werden bei jeder Antwort auch bis zu fünf
          ähnlich geschriebene Wörter zurückgegeben. Dies ist nützlich, um dem User einen Vorschlag im Falle eines möglichen
          Tippfehlers machen zu können. Beispielanfrage:

          <pre class="api"><a href="${createLinkTo(dir:'synonyme')}/search?q=Umstant&amp;format=text/xml&amp;similar=true">http://www.openthesaurus.de/synonyme/search?q=<strong>Umstant</strong>&amp;format=text/xml&amp;similar=true</a></pre>

          Antwort (Ausschnitt):

<pre class="api">
&lt;similarterms>
  &lt;term term="Umstand" distance="1"/>
  &lt;term term="(zeitlicher) Abstand" distance="3"/>
  &lt;term term="Abstand" distance="3"/>
  &lt;term term="amüsant" distance="3"/>
  &lt;term term="Anstalt" distance="3"/>
&lt;/similarterms>
</pre>
          <tt>distance</tt> gibt den Levenshtein-Abstand zum Suchwort an (Wörter in Klammern werden dabei ignoriert).
            Die Wörter sind bereits nach diesem Abstand sortiert. Es werden nur Wörter vorgeschlagen, die auch
            in OpenThesaurus vorhanden sind.
          </li>
          <li><span class="apioption">substring=true</span>: Hiermit werden bei jeder Antwort auch bis zu zehn Wörter
          zurückgegeben, die den Suchbegriff nur als Teilwort beinhalten. Beispielanfrage:

            <pre class="api"><a href="${createLinkTo(dir:'synonyme')}/search?q=Hand&amp;format=text/xml&amp;substring=true">http://www.openthesaurus.de/synonyme/search?q=<strong>Hand</strong>&amp;format=text/xml&amp;substring=true</a></pre>

            Antwort (Ausschnitt):

<pre class="api">
&lt;substringterms>
  &lt;term term="(etwas) behandeln"/>
  &lt;term term="abhandeln"/>
&lt;/substringterms>
</pre>
          </li>

          <li><span class="apioption">substringFromResults</span>: Gibt an, ab welchem Eintrag die Teilwort-Treffer
          zurückgegeben werden sollen. Funktioniert nur zusammen mit <span class="apioption">substring=true</span>.
          Standardwert ist 0, also ab der ersten Position.</li>

          <li><span class="apioption">substringMaxResults</span>: Gibt an, wie viele Teilwort-Treffer insgesamt
          zurückgegeben werden sollen. Funktioniert nur zusammen mit <span class="apioption">substring=true</span>.
          Der Standardwert ist 10, Maximalwert ist 250.</li>
          
          <li><span class="apioption">mode=all</span>: Aktiviert alle zusätzlichen Abfragen. Bisher sind das <tt>similar=true</tt>
            und <tt>substring=true</tt>.</li>
        </ul>


        <h2>Bekannte Probleme</h2>

        <ul>
          <li>Umlaute werden bei der Suche wie ihre nicht-Umlaute behandelt, so findet <span class="bsp">tur</span>
            auch den Eintrag zu <span class="bsp">Tür</span> und umgekehrt.</li>
        </ul>

        <h2>Anfrage-Limitierung</h2>

        <p>Bei mehr als 60 Anfragen pro Minute von der gleichen IP-Adresse werden die Antworten verzögert.
        Wer mehr Anfragen stellen möchte, kann <g:link action="imprint">uns kontaktieren</g:link> und um eine
        Erhöhung des Limits bitten.</p>

		<h2>Download</h2>
		
		<p>Zusätzlich zur direkten Abfrage stehen weiterhin
		<g:link action="download">Downloads</g:link> der Datenbank zur Verfügung.</p>
		
    </body>
</html>
