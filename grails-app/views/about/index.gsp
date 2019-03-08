<%@page import="com.vionto.vithesaurus.*" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title><g:message code="about.title" /></title>
        <meta name="description" content="OpenThesaurus ist eine interaktive Website zur Entwicklung eines deutschsprachigen Wörterbuchs für Synonyme."/>
    </head>
    <body>

        <hr/>

        <g:if test="${grailsApplication.config.thesaurus.serverId == 'de'}">

            <h2>Über OpenThesaurus</h2>

            <p>OpenThesaurus ist ein deutschsprachiges Wörterbuch für Synonyme und Assoziationen.
            Man kann damit Wörter mit gleicher oder ähnlicher Bedeutung nachschlagen. Zum Beispiel liefert
            die <a href="../synset/search?q=falsch">Suche nach <span class="bsp">falsch</span></a> unter anderem <span class="bsp">inkorrekt, unrichtig,
            verkehrt</span> als Synonyme.</p>

            <p>Jeder kann bei OpenThesaurus mitmachen und Fehler korrigieren
            oder neue Synonyme einfügen. Die Suchfunktion zeigt alle Bedeutungen,
            in denen ein Wort vorkommt (z.B. <span class="bsp">roh</span> -&gt; <span class="bsp">roh, ungekocht</span>
            und einen anderen Eintrag für <span class="bsp">roh, rau, grob, unsanft</span>). Bei
            den einzelnen Bedeutungen  lassen sich dann unpassende Wörter löschen
            und neue hinzufügen. Details dazu finden sich in der <a href="faq">FAQ</a>.</p>


            <a name="searchEngine"></a>
            <h2>Als Suchmaschine hinzufügen</h2>

            <h3>Firefox</h3>

            <ul>
                <li><a href="https://addons.mozilla.org/de/firefox/search/?q=openthesaurus&type=search">Hier nach "OpenThesaurus" suchen</a> und auf der Ergebnisseite "Zu Firefox hinzufügen" klicken</li>
                <li>Im Firefox unter Einstellungen → Suche → Ein-Klick-Suchmaschinen das "Schlüsselwort" für
                OpenThesaurus zum Beispiel auf <tt>ot</tt> setzen, fertig! Mit "ot fahrrad" kann jetzt bei OpenThesaurus nach "fahrrad" gesucht werden.</li>
            </ul>

            <h3>Chrome</h3>

            <ul>
                <li>Die Chrome-Einstellungen öffnen (im Menü mit den drei Punkten, rechts oben im Fenster)</li>
                <li>Runterscrollen bis zu "Suchmaschine", dort auf "Suchmaschinen verwalten" klicken</li>
                <li>Unter "Andere Suchmaschinen" sollte OpenThesaurus bereits erkannt worden sein.
                    Rechts befinden sich drei Punkte, dort "Bearbeiten" wählen.</li>
                <li>Bei "Suchkürzel" jetzt zum Beispiel <tt>ot</tt> eintragen, fertig!
                    Mit "ot fahrrad" kann jetzt bei OpenThesaurus nach "fahrrad" gesucht werden.</li>
            </ul>


            <h2>Lizenz</h2>

            <img src="${createLinkTo(dir:'images',file:'cc-LGPL-a.png')}" alt="GNU LGPL" style="margin-left:10px;float:right;height:50px"/>
            <img align="right" src="${createLinkTo(dir:'images',file:'cc-by-sa.png')}" alt="Creative Commons BY-SA Logo" style="margin-left: 15px;height:50px"/>

            <p>Die <strong>Daten</strong> von OpenThesaurus stehen via <a href="api">API</a> und <a href="download">Download</a>
              wahlweise unter einer dieser beiden Lizenzen zur Verfügung:
              <ul>
                <li><a rel="license" href="https://creativecommons.org/licenses/by-sa/4.0/legalcode.de"> Creative Commons Attribution-ShareAlike 4.0</a></li>
                <li><a rel="license" href="https://creativecommons.org/licenses/LGPL/2.1/deed.de">GNU Lesser General Public License (LGPL)</a></li>
              </ul>
              <p style="margin-top: 8px">Das bedeutet einfach gesagt, dass die Daten kostenlos genutzt, verarbeitet, geändert und weiterverbreitet werden
              können, solange die weiterverbreiteten Daten ebenfalls für den User deutlich erkennbar unter der LGPL stehen
              und openthesaurus.de mit einem vollwertigen Link (kein <tt>rel="nofollow"</tt>) als Quelle angegeben wird.</p>

            <p>Der <strong>Sourcecode der Website</strong> befindet sich <a href="https://github.com/danielnaber/openthesaurus">bei github</a>,
              er steht unter der <a href="https://www.gnu.org/licenses/agpl.html">GNU AGPL</a>.
              Auf diesem Server (www.openthesaurus.de) läuft Version ${grailsApplication.metadata.getApplicationVersion()}.
              Die Installation ist in einem <a href="https://github.com/danielnaber/openthesaurus/blob/master/README.md">README</a>
              und <a href="https://www.openthesaurus.de/jforum/posts/list/71.page">im Forum</a> beschrieben.
            </p>


            <h2>Analysedienste &amp; Datenschutz</h2>

            <p><g:link action="imprint">Siehe Impressum</g:link></p>


            <h2>Änderungen und News zu OpenThesaurus</h2>

            <ul>
                <li><a href="newsletter">OpenThesaurus Newsletter</a></li>
                <li><a href="newsarchive">News-Archiv</a></li>
                <li><a href="../feed">RSS-Feed aller Aktualisierungen an den Daten</a></li>
            </ul>


    <!--
            <h2>OpenThesaurus auf Android</h2>

            <ul>
                <li><a href="https://play.google.com/store/apps/details?id=sfischer13.openthesaurus">OpenThesaurus Synonymsuche</a>.
                Lizenz: Apache License 2.0, <a href="https://github.com/sfischer13/robot-openthesaurus">Sourcecode</a></li>
            </ul>

            <p style="margin-top: 10px">Die folgenden Apps wurden schon länger nicht mehr aktualisiert, sollten aber
            weiterhin funktionieren:</p>

            <ul>
                <li><a href="https://play.google.com/store/apps/details?id=de.ad.openthesaurus">OpenThesaurus.de</a>.
                  Lizenz: GPLv3, <a href="https://github.com/a11n/openthesaurus-de">Sourcecode</a></li>
                <li><a href="https://play.google.com/store/apps/details?id=de.offlinethesaurus">Offline Thesaurus (Synonyme)</a>.
                  Lizenz: GPLv3, <a href="https://github.com/vfichtner/offline-openthesaurus-de">Sourcecode</a></li>
            </ul>-->


            <h2>OpenThesaurus in anderen Sprachen</h2>

            <ul>
                <!--<li><a href="http://www.openthesaurus.gr/">Griechisch</a></li>-->
                <li><a href="https://openthesaurus.softcatala.org">Katalanisch</a></li>
                <!--<li><a href="http://openthesaurus.caixamagica.pt/">Portugiesisch</a></li>-->
                <li><a href="http://www.tezaver.si/">Slowenisch</a></li>
            </ul>


            <h2>Papers über OpenThesaurus</h2>

            <p>In diesen Papers wird noch eine alte PHP-basierte Version beschrieben.</p>

            <ul>
                <li><a href="http://www.danielnaber.de/publications/gldv-openthesaurus.pdf">OpenThesaurus: ein
                offenes deutsches Wortnetz (PDF, 536&nbsp;KB)</a></li>
                <li><a href="../download/openthesaurus.pdf">OpenThesaurus: Building a Thesaurus with a Web Community (PDF, 266&nbsp;KB)</a></li>
            </ul>

            <g:render template="/ads/about_bottom"/>

        </g:if>
        <g:else>

            (Nothing here yet)

        </g:else>

    </body>
</html>
