<%@page import="com.vionto.vithesaurus.*" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title><g:message code="news.archive.title" /></title>
        <meta name="description" content="Das Archiv mit den wichtigsten Neuigkeiten bei OpenThesaurus seit dem Projektstart in 2003."/>
    </head>
    <body>

    <hr />

    <g:if test="${grailsApplication.config.thesaurus.serverId == 'de'}">

        <h2><g:message code="news.archive.headline" /></h2>
        
        <table border="0" cellpadding="5" cellspacing="0" class="newArchiveTable">
            
        <tr class="newsYearDelimiter">
            <td>2017</td>
            <td></td>
        </tr>
        <tr>
            <td valign="top" align="right" width="90"><span class="newsdate">2017-08-09</span></td>
            <td valign="top">
                Unsere
                <g:link controller="about" action="api">API</g:link> kann jetzt auch im JSON-Modus
                Ober- und Unterbegriffe ausliefern.
            </td>
        </tr>
        <tr>
            <td valign="top" align="right" width="90"><span class="newsdate">2017-03-05</span></td>
            <td valign="top">
                Auf
                <g:link controller="statistics" action="index">der Statistik-Seite</g:link> findet
                sich jetzt die Top Ten der aktivsten User, getrennt nach den letzten 365 Tagen
                und insgesamt.
            </td>
        </tr>

        <tr class="newsYearDelimiter">
            <td>2016</td>
            <td></td>
        </tr>
        <tr>
            <td valign="top" align="right" width="90"><span class="newsdate">2016-11-12</span></td>
            <td valign="top">
                Das Forum wurde geschlossen, Ideen oder Fehlerberichte können weiterhin
                <g:link action="imprint">per E-Mail</g:link> oder
                <a href="https://github.com/danielnaber/openthesaurus/issues">auf github</a>
                berichtet werden.
            </td>
        </tr>
        <tr>
            <td valign="top" align="right" width="90"><span class="newsdate">2016-02-01</span></td>
            <td valign="top">
                Nutzer können zwei Synonymgruppen jetzt zu einer zusammenführen (dieses Feature ist
                nur für erfahrene Nutzer mit mehr als 50 Änderungen freigeschaltet).
            </td>
        </tr>

        <tr class="newsYearDelimiter">
            <td>2015</td>
            <td></td>
        </tr>
        <tr>
            <td valign="top" align="right" width="90"><span class="newsdate">2015-05-20</span></td>
            <td valign="top">
                Stefan Fischer hat eine OpenThesaurus-App für Android entwickelt. Kostenlos erhältlich
                bei <a href="https://play.google.com/store/apps/details?id=sfischer13.openthesaurus">Google Play</a>.
            </td>
        </tr>
        <tr>
            <td valign="top" align="right" width="90"><span class="newsdate">2015-05-13</span></td>
            <td valign="top">Nutzern kann jetzt auf ihrer Profilseite eine private Nachricht geschickt werden.
                Außerdem hat jeder Nutzer jetzt einen Avatar (zu sehen u.&nbsp;a. auf der <g:link controller="statistics">Statistik-Seite</g:link>)
                und kann auf seinem Profil einen kurzen Text und einen Link zu seiner Homepage angeben.</td>
        </tr>

        <tr class="newsYearDelimiter">
            <td>2014</td>
            <td></td>
        </tr>
        <tr>
            <td valign="top" align="right" width="90"><span class="newsdate">2014-12-15</span></td>
            <td valign="top">Es gibt jetzt eine
                <g:link controller="search">erweiterte Suche</g:link> bei der die Suche nach
                Wort-Teilen mit anderen Worteigenschaften wie Kategorie und Tag kombiniert werden kann.
            </td>
        </tr>
        <tr>
            <td valign="top" align="right" width="90"><span class="newsdate">2014-12-10</span></td>
            <td valign="top">Wörter können jetzt mit beliebigen Tags versehen werden. Hier findet man
                <g:link controller="tag">die Liste der bisher benutzten Tags</g:link>.
            </td>
        </tr>
        <tr>
            <td valign="top" align="right" width="90"><span class="newsdate">2014-10-25</span></td>
            <td valign="top">OpenThesaurus ist auf einen neuen Server umgezogen. Dabei haben
                wir die Konfiguration so geändert, dass jetzt alle Verbindungen zwischen den
                Nutzern und openthesaurus.de verschlüsselt sind (wir nutzen also https statt http).
                Die Umleitung auf die verschlüsselte Verbindung
                erfolgt automatisch, nur bei der <a href="api">API</a> funktionieren zur besseren
                Kompatibilität auch noch unverschlüsselte http-Anfragen.
            </td>
        </tr>
        <tr>
            <td valign="top" align="right" width="90"><span class="newsdate">2014-03-14</span></td>
            <td valign="top">Unter <a href="http://openthesaurus.softcatala.org">openthesaurus.softcatala.org</a>
                gibt es jetzt eine katalanische Version von OpenThesaurus.
            </td>
        </tr>
        <tr>
            <td valign="top" align="right" width="90"><span class="newsdate">2014-01-11</span></td>
            <td valign="top">Auf der Ergebnisseite werden jetzt auch alle Antonyme angezeigt: Wörter
                mit Antonym haben ein kleines "G" (wie 'Gegenteil'). Bleibt man mit der Maus auf dem "G",
                werden die Antonyme angezeigt. Mit Klick wird eine neue Suche gestartet:
                <a href="../synonyme/klein">Beispielseite</a>
            </td>
        </tr>
        <tr>
            <td valign="top" align="right" width="90"><span class="newsdate">2014-01-02</span></td>
            <td valign="top">Auf der Ergebnisseite werden jetzt auch alle Unterbegriffe angezeigt. Sind
                es viele, kann man sie mit dem "Alle anzeigen"-Link einblenden:
                <a href="../synonyme/Währung">Beispiel 1</a>, <a href="../synonyme/Haus">Beispiel 2</a>.
                Außerdem sind alle Ober-, Unterbegriffe und Assoziationen Links, so dass man damit
                bequem eine weitere Suche auslösen kann.
            </td>
        </tr>
        
        <tr class="newsYearDelimiter">
            <td>2013</td>
            <td></td>
        </tr>
        <tr>
            <td valign="top" align="right" width="90"><span class="newsdate">2013-12-31</span></td>
            <td valign="top">Die <g:link controller="association" action="list">Liste der Assoziationen</g:link> umfasst
                jetzt schon mehr als 5000 Verknüpfungen zwischen Synonymgruppen.</td>
        </tr>
        <tr>
            <td valign="top" align="right" width="90"><span class="newsdate">2013-11-11</span></td>
            <td valign="top">Neues Feature für Mitwirkende: <g:link controller="suggest">Möglicherweise fehlende Wörter finden</g:link>
                 - damit lassen sich ganze Texte auf Wörter durchsuchen, die noch nicht in OpenThesaurus stehen</td>
        </tr>
        <tr>
            <td valign="top" align="right" width="90"><span class="newsdate">2013-09-08</span></td>
            <td valign="top">OpenThesaurus umfasst jetzt <g:link controller="statistics">über 100.000 Wörter</g:link>.</td>
        </tr>
        
        <tr class="newsYearDelimiter">
            <td>2012</td>
            <td></td>
        </tr>
        <tr>
            <td valign="top" align="right" width="90"><span class="newsdate">2012-09-24</span></td>
            <td valign="top">Der Sourcecode von OpenThesaurus steht jetzt
                <a href="https://github.com/danielnaber/openthesaurus">bei github</a> zur Verfügung.</td>
        </tr>
        <tr>
            <td valign="top" align="right" width="90"><span class="newsdate">2012-08-27</span></td>
            <td valign="top">Die <a href="api#optionen">XML-API</a> wurde um die Möglichkeit erweitert, Ober- und
                Unterbegriffe abfragen zu können.</td>
        </tr>
        <tr>
            <td valign="top" align="right" width="90"><span class="newsdate">2012-05-01</span></td>
            <td valign="top">Mit Firefox und Chrome werden jetzt auf allen Seiten die ersten Treffer schon während des Tippens
                angezeigt (bisher war das nur auf der Homepage so).</td>
        </tr>
        <tr>
            <td valign="top" align="right" width="90"><span class="newsdate">2012-03-31</span></td>
            <td valign="top">Auf der Homepage werden Treffer jetzt schon während des Tippens angezeigt.</td>
        </tr>
        <tr>
            <td valign="top" align="right" width="90"><span class="newsdate">2012-03-16</span></td>
            <td valign="top">Auf der Suchergebnis-Seite werden die Assoziationen jetzt direkt angezeigt. Bisher wurden
                über 1.100 Assoziationen erfasst.</td>
        </tr>
        
        <tr><td>&nbsp;</td></tr>
        <tr class="newsYearDelimiter">
            <td>2011</td>
            <td></td>
        </tr>
        <tr>
            <td valign="top" align="right" width="90"><span class="newsdate">2011-12-18</span></td>
            <td valign="top">Es können jetzt Antonyme (Gegenwörter) eingetragen werden. Die
                <g:link controller="term" action="antonyms">Liste aller bisher erfassten Antonyme</g:link>.</td>
        </tr>
        <tr>
            <td valign="top" align="right" width="90"><span class="newsdate">2011-12-07</span></td>
            <td valign="top">Ab sofort gibt es ein <a href="/jforum">Forum</a>.</td>
        </tr>
        <tr>
            <td valign="top" align="right" width="90"><span class="newsdate">2011-09-18</span></td>
            <td valign="top">Ab sofort steht die Beta-Version einer <a href="api#json">JSON-API</a> zur Verfügung.</td>
        </tr>
        <tr>
            <td valign="top" align="right" width="90"><span class="newsdate">2011-02-21</span></td>
            <td valign="top">Neue Seite: <g:link controller="wordList">Wortlisten</g:link></td>
        </tr>
        
        <tr><td>&nbsp;</td></tr>
        <tr class="newsYearDelimiter">
            <td>2010</td>
            <td></td>
        </tr>
        <tr>
            <td valign="top" align="right" width="90"><span class="newsdate">2010-11-11</span></td>
            <td valign="top">OpenThesaurus hat ein neues Design!</td>
        </tr>
        <tr>
            <td valign="top" align="right" width="90"><span class="newsdate">2010-08-14</span></td>
            <td valign="top">Die <a href="api">API</a> wurde um eine Suche nach Teilwörtern erweitert.</td>
        </tr>
        <tr>
            <td valign="top" align="right" width="90"><span class="newsdate">2010-03-09</span></td>
            <td valign="top">Mit <a href="https://play.google.com/store/apps/details?id=com.fc.ot">OpenThesaurus für Android</a> wurde
              die Beta-Version einer Android-App veröffentlicht.
              Kostenlos erhältlich im Market.</td>
        </tr>
        <tr>
            <td valign="top" align="right" width="90"><span class="newsdate">2010-03-07</span></td>
            <td valign="top">Die <a href="api">API</a> wurde um eine Suche nach ähnlich geschriebenen Wörtern erweitert.</td>
        </tr>
        
        <tr><td>&nbsp;</td></tr>
        <tr class="newsYearDelimiter">
            <td>2009</td>
            <td></td>
        </tr>
        <tr>
            <td valign="top" align="right" width="90"><span class="newsdate">2009-08-31</span></td>
            <td valign="top">OpenThesaurus-Daten können jetzt auch <a href="../about/api">über
                diese REST-API</a> angefragt werden</td>
        </tr>
        <tr>
            <td valign="top" align="right" width="90"><span class="newsdate">2009-08-06</span></td>
            <td valign="top">Relaunch - OpenThesaurus basiert jetzt auf dem Projekt
                <a href="http://sourceforge.net/projects/vithesaurus">vithesaurus</a>, was uns
                die zukünftige Pflege und Weiterentwicklung deutlich erleichtert.</td>
        </tr>
        <tr>
            <td valign="top" align="right" width="90"><span class="newsdate">2009-07-23</span></td>
            <td valign="top">OpenThesaurus <a href="http://twitter.com/openthesaurus">schreibt jetzt auch auf Twitter</a></td>
        </tr>
        
        <tr><td>&nbsp;</td></tr>
        <tr class="newsYearDelimiter">
            <td>2008</td>
            <td></td>
        </tr>
        <tr>
            <td valign="top" align="right" width="90"><span class="newsdate">2008-11-23</span></td>
            <td valign="top">OpenThesaurus enthält durch die starke Community-Beteiligung insbesondere
                in den letzten Wochen jetzt erstmals 50.000 Wörter. 
                Das wurde auch als Anlass genommen, um der Homepage www.openthesaurus.de ein neues Design zu geben.</td>
        </tr>
        <tr>
            <td valign="top" align="right" width="90"><span class="newsdate">2008-09-28</span></td>
            <td valign="top">Im bald erscheinenden OpenOffice.org 3.0 werden Wörterbücher
            und Thesauri als Extensions installiert. Den jeweils tagesaktuellen OpenThesaurus
            gibt es deshalb unter "Download" jetzt auch als Extension, also im .oxt-Format.
            Die Installation erfolgt ganz einfach über das Menü in OpenOffice.org unter
            <em>Extras -> Extension Manager</em>. Die alten Thesaurus-Dateiformate
            funktionieren in OpenOffice.org 3.0 übrigens nicht mehr.
            </td>
        </tr>
        
        <tr><td>&nbsp;</td></tr>
        <tr class="newsYearDelimiter">
            <td>2007</td>
            <td></td>
        </tr>
        <tr>
            <td valign="top" align="right" width="90"><span class="newsdate">2007-09-29</span></td>
            <td valign="top">Ab sofort steht ein <a href="../feed/">RSS-Feed</a> zur Verfügung,
                der alle Änderungen in den Thesaurus-Daten auflistet.
            </td>
        </tr>
        <tr>
            <td valign="top" align="right" width="90"><span class="newsdate">2007-07-12</span></td>
            <td valign="top">Ab jetzt sind auf der Ergebnis-Seite auch Links
                aus der Wikipedia integriert. Dabei handelt es sich nicht einfach um Synonyme,
                sondern um Wörter, die im Wikipedia-Artikel zum aktuellen Suchbegriff verlinkt
                sind. Damit eignet sich OpenThesaurus jetzt noch besser zum Auffinden von
                Assoziationen. Beispiele zum Ausprobieren:
                <a href="../synset/search?q=Demokratie">Demokratie</a>,
                <a href="../synset/search?q=Welt">Welt</a>, <a href="../synset/search?q=Wald">Wald</a>
            </td>
        </tr>
        
        <tr><td>&nbsp;</td></tr>
        <tr class="newsYearDelimiter">
            <td>2006</td>
            <td></td>
        </tr>
        <tr>
            <td valign="top" align="right" width="90"><span class="newsdate">2006-07-04</span></td>
            <td valign="top">Das neue <a href="http://de.openoffice.org">OpenOffice.org</a> 2.0.3 enthält
                jetzt den deutschen OpenThesaurus, so dass keine nachträgliche Installation des Thesaurus 
                mehr nötig ist.</td>
        </tr>
        <tr>
            <td valign="top" align="right" width="90"><span class="newsdate">2006-03-17</span></td>
            <td valign="top">OpenThesaurus steht ab sofort nicht mehr unter der
                <a href="http://www.gnu.org/copyleft/gpl.html">GPL</a> zu Verfügung, sondern
                unter der <a href="http://www.gnu.org/copyleft/lesser.html">LGPL</a>.</td>
        </tr>
        
        <tr><td>&nbsp;</td></tr>
        <tr class="newsYearDelimiter">
            <td>2005</td>
            <td></td>
        </tr>
        <tr>
            <td valign="top" align="right" width="90"><span class="newsdate">2005-04-18</span></td>
            <td valign="top">Der Thesaurus für OpenOffice.org 2.0 beinhaltet ab jetzt auch Oberbegriffe.
                Außerdem sei noch auf die Seite <a
                href="../about/index">Hintergrundinformationen</a> hingewiesen, auf der sich
                zwei Papers über OpenThesaurus befinden.</td>
        </tr>
        
        <tr><td>&nbsp;</td></tr>
        <tr class="newsYearDelimiter">
            <td>2004</td>
            <td></td>
        </tr>
        <tr>
            <td valign="top" align="right" width="90"><span class="newsdate">2004-04-04</span></td>
            <td valign="top">OpenThesaurus ist jetzt unter der Domain
                <span style="color:#666666;font-weight:bold">www.openthesaurus.de</span>
                zu erreichen.
            </td>
        </tr>
        <tr>
            <td valign="top" align="right" width="90"><span class="newsdate">2004-03-31</span></td>
            <td valign="top">Neues Feature: <a href="../synset/statistics">Benutzer-Top10</a>
                - listet die Top 10 der Benutzer, die in den letzten 7 bzw. 365 Tagen
                die meisten Beiträge geleistet haben.
            </td>
        </tr>
        <tr>
            <td valign="top" align="right" width="90"><span class="newsdate">2004-01-12</span></td>
            <td valign="top">Es gibt jetzt es eine Mailingliste
                        für Diskussionen und Announcements zu OpenThesaurus:
                        <a href="http://lists.berlios.de/mailman/listinfo/openthesaurus-discuss#sub">Hier eintragen</a>
                        <!-- (<a href="http://lists.berlios.de/pipermail/openthesaurus-discuss/">Archiv der Beiträge</a>) -->
            </td>
        </tr>
        
        <tr><td>&nbsp;</td></tr>
        <tr class="newsYearDelimiter">
            <td>2003</td>
            <td></td>
        </tr>
        <tr>
            <td valign="top" align="right" width="90"><span class="newsdate">2003-10-18</span></td>
            <td valign="top">
                OpenThesaurus wird jetzt
                auch mit <a href="http://www.suse.de/de/private/products/suse_linux/i386/">Suse Linux 9.0</a>
                mitgeliefert und automatisch 
                zusammen mit OpenOffice.org installiert.
            </td>
        </tr>
        <tr>
            <td valign="top" align="right" width="90"><span class="newsdate">2003-09-16</span></td>
            <td valign="top">
                Ab sofort kann man auch
                nach flektierten Wörtern suchen. Zum Beispiel wird bei der Suche
                nach <span class="bsp">gehst</span> oder <span class="bsp">ging</span>
                jetzt automatisch eine Suche nach <span class="bsp">gehen</span>
                vorgeschlagen.
            </td>
        </tr>
        <tr>
            <td valign="top" align="right" width="90"><span class="newsdate">März 2003</span></td>
            <td valign="top">
                OpenThesaurus geht online.
            </td>
        </tr>
        </table>
        
        <g:render template="/ads/newsarchive_bottom"/>

    </g:if>
    <g:else>

        (Nothing here yet)

    </g:else>

    </body>
</html>
