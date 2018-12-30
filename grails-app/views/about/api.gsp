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

        <g:if test="${grailsApplication.config.thesaurus.serverId == 'de'}">

            <h2>Webservice/API-Zugriff</h2>

            <ul>
                <li><a href="#allgemeines">Allgemeines</a></li>
                <li><a href="#json">Suchanfrage für JSON</a></li>
                <li><a href="#xml">Suchanfrage für XML</a></li>
                <li><a href="#optionen">Optionen</a></li>
                <li><a href="#probleme">Bekannte Probleme</a></li>
                <li><a href="#limits">Anfrage-Limitierung</a></li>
            </ul>

            <h2><a name="allgemeines">Allgemeines</a></h2>

            <p>Viele Daten dieser Website können direkt über eine HTTP-Schnittstelle
            abgefragt werden. Bisher wird die Suche nach Wörtern, Teilwörtern und nach ähnlich geschriebenen Wörtern
            unterstützt. Nicht unterstützt wird die Wikipedia/Wiktionary-Suche.</p>

            <p><strong>Hinweis: Die Nutzung der API ist kostenlos, aber es gelten folgende Bedingungen:</strong></p>
                <ol style="margin-left:30px;">
                    <li>Wir erwarten einen Link auf
                        www.openthesaurus.de (ohne <tt>nofollow</tt>-Attribut). Sollten die Daten nur im Hintergrund benutzt
                        werden (z.B. zur Erweiterung einer Suchanfrage o.ä.) reicht auch ein Hinweis im Impressum. Ansonsten
                        sollte der Link für die Nutzer gut sichtbar auf der Seite angezeigt werden, auf der auch die Daten
                        zum Einsatz kommen.</li>
                    <li>Jede Anfrage muss im <tt>User-Agent</tt>-Header eine Kontaktmöglichkeit (z.&nbsp;B. Homepage oder E-Mail)
                        enthalten, damit wir bei Problemen wissen, mit wem wir Kontakt aufnehmen können.</li>
                    <li>Anfrage-Limitierung: Bei mehr als 60 Anfragen pro Minute von der gleichen IP-Adresse folgt eine Fehlermeldung.
                        <!--Wer mehr Anfragen stellen möchte, kann <g:link action="imprint">uns kontaktieren</g:link> und um eine
                        Erhöhung des Limits bitten. -->Zusätzlich zur direkten Abfrage stehen weiterhin
                        <g:link action="download">Downloads</g:link> der Datenbank zur Verfügung. Statt Massenabfragen
                        über die API sollte dieser Download genutzt werden.
                    </li>
                    <li>Wer plant, die API dauerhaft zu benutzen, sollte sich bitte vorher bei
                        <i>feedback <span>at</span> openthesaurus.de</i> melden. Nur so können wir rechtzeitig alle Nutzer kontaktieren,
                        um zum Beispiel über mögliche Änderungen am Ausgabeformat zu informieren.</li>
                </ol>

            <h2><a name="json">Suchanfrage für JSON</a></h2>

            <p>Mit der folgenden HTTP-Anfrage via GET können alle Synonymgruppen,
            die das Wort <span class="bsp">test</span> beinhalten, abgefragt werden:</p>

            <pre class="api"><a href="/synonyme/search?q=test&amp;format=application/json">${grailsApplication.config.thesaurus.serverURL}/synonyme/<br/>search?q=<strong>test</strong>&amp;format=application/json</a></pre>

            <p>Kommt im Suchwort ein Sonderzeichen vor, muss es mit UTF-8 URL-kodiert werden (z.B. wird <tt>hören</tt> zu <tt>h%C3%B6ren</tt>).</p>

            
            <h2><a name="xml">Suchanfrage für XML</a></h2>

            <p>Statt <span class="apioption">application/json</span> kann <span class="apioption">text/xml</span>
                angegeben werden, um das Ergebnis im XML-Format zu erhalten.</p>

            <pre class="api"><a href="/synonyme/search?q=test&amp;format=text/xml">${grailsApplication.config.thesaurus.serverURL}/synonyme/<br/>search?q=<strong>test</strong>&amp;format=text/xml</a></pre>

            <!--
            <h2><a name="jsonp">Suchanfrage für JSONP</a></h2>

            <p>Mit der Übergabe einer Callback-Methode kann der JSON-Code als Parameter einer Funktion übergeben werden.
            <g:link action="jsonpExample">Eine Beispiel-Seite</g:link>.</p>

            <pre class="api"><a href="${createLinkTo(dir:'synonyme')}/search?q=test&amp;format=application/json&amp;callback=myCallback">${grailsApplication.config.thesaurus.serverURL}/synonyme/<br/>search?q=<strong>test</strong>&amp;format=application/json&amp;callback=myCallback</a></pre>
            -->

            <h2><a name="optionen">Optionen</a></h2>

            <ul class="apioptions">
                <li><span class="apioption">similar=true</span>: Hiermit werden bei jeder Antwort auch bis zu fünf
                ähnlich geschriebene Wörter zurückgegeben. Dies ist nützlich, um dem User einen Vorschlag im Falle eines möglichen
                Tippfehlers machen zu können. Beispielanfrage:
                    <pre class="api"><a href="/synonyme/search?q=Umstant&amp;format=application/json&amp;similar=true">${grailsApplication.config.thesaurus.serverURL}/synonyme/<br/>search?q=<strong>Umstant</strong>&amp;format=application/json&amp;similar=true</a></pre>
                    In der Antwort gibt <tt>distance</tt> den Levenshtein-Abstand zum Suchwort an (Wörter in Klammern werden dabei ignoriert).
                Die Wörter sind bereits nach diesem Abstand sortiert. Es werden nur Wörter vorgeschlagen, die auch
                in OpenThesaurus vorhanden sind.
                </li>

                <li><span class="apioption">substring=true</span>: Hiermit werden bei jeder Antwort auch bis zu zehn Wörter
                zurückgegeben, die den Suchbegriff nur als Teilwort beinhalten. Beispielanfrage:
                    <pre class="api"><a href="/synonyme/search?q=Hand&amp;format=application/json&amp;substring=true">${grailsApplication.config.thesaurus.serverURL}/synonyme/<br/>search?q=<strong>Hand</strong>&amp;format=application/json&amp;substring=true</a></pre>
                </li>

                <li><span class="apioption">substringFromResults</span>: Gibt an, ab welchem Eintrag die Teilwort-Treffer
                zurückgegeben werden sollen. Funktioniert nur zusammen mit <span class="apioption">substring=true</span>.
                Standardwert ist 0, also ab der ersten Position.</li>

                <li><span class="apioption">substringMaxResults</span>: Gibt an, wie viele Teilwort-Treffer insgesamt
                zurückgegeben werden sollen. Funktioniert nur zusammen mit <span class="apioption">substring=true</span>.
                Der Standardwert ist 10, Maximalwert ist 250.</li>

                <li><span class="apioption">startswith=true</span>: Wie <tt>substring=true</tt>, findet aber nur Wörter, die
                mit dem angebenen Suchbegriff anfangen. Beschränkung der Treffer ähnlich wie bei <tt>substring</tt>,
                aber mit <tt>startsWithFromResults</tt> und <tt>startsWithMaxResults</tt>.</li>

                <li><span class="apioption">supersynsets=true</span>: Gibt an, dass zu jeder Synonymgruppe ihre
                (optionalen) Oberbegriffe mitgeliefert werden.</li>

                <li><span class="apioption">subsynsets=true</span>: Gibt an, dass zu jeder Synonymgruppe ihre
                (optionalen) Unterbegriffe mitgeliefert werden.</li>

                <!--
                <li><span class="apioption">mode=all</span>: Aktiviert alle zusätzlichen Abfragen. Bisher sind das <tt>similar=true</tt>,
                    <tt>substring=true</tt>, <tt>supersynsets=true</tt> und <tt>subsynsets=true</tt>. Dieser Modus
                sollte nur zum Testen benutzt werden, um einen Überblick über die Möglichkeiten zu bekommen.</li>
                -->
            </ul>


            <h2><a name="probleme">Bekannte Probleme</a></h2>

            <p>Umlaute werden bei der Suche wie ihre nicht-Umlaute behandelt, so findet <span class="bsp">tur</span>
                auch den Eintrag zu <span class="bsp">Tür</span> und umgekehrt.</p>

        </g:if>
        <g:else>

            (Nothing here yet)

        </g:else>

    </body>
</html>
