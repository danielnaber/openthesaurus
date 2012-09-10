<%@page import="java.text.*" %>
<%@page import="com.vionto.vithesaurus.*" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title><g:message code="download.title" /></title>
        <meta name="description" content="Download der freien OpenThesaurus-Daten in verschiedenen Formaten, u.a. Text und für OpenOffice.org/LibreOffice."/>
    </head>
    <body>

        <hr />
    
        <h2>Download der Daten</h2>

        <p>Die Wörter aus OpenThesaurus lassen sich hier in verschiedenen Formaten
        herunterladen. Sie stehen unter der
        <a href="http://creativecommons.org/licenses/LGPL/2.1/deed.de">GNU Lesser
        General Public License</a> zur Verfügung.
        <!-- text from about/index: -->
        Das bedeutet vereinfacht gesagt, dass die Daten kostenlos genutzt, verarbeitet, geändert und weiterverbreitet
        werden können, solange die weiterverbreiteten Daten ebenfalls für den User deutlich erkennbar unter der
        LGPL stehen und openthesaurus.de mit Link als die ursprüngliche Quelle angegeben wird.
        </p>

        <g:set var="sdf" value="${new SimpleDateFormat('yyyy-MM-dd HH:mm')}"/>

        <ul>
            <li><a href="../export/${oooDump.getName()}">Deutscher Thesaurus für OpenOffice.org 3.x / LibreOffice,
                ${sdf.format(new Date(oooDump.lastModified()))},
                ${String.format("%.2f", oooDump.length()/1000/1000)}MB</a>
                <ul style="margin-top:0px">
                  <li><a href="../export/${oooDumpCh.getName()}">Schweizer Version</a> (wie oben, nur alle <span class="bsp">ß</span> durch <span class="bsp">ss</span> ersetzt)</li>
                </ul>
            </li>

            <li><a href="../export/${textDump.getName()}">Thesaurus im Text-Format, gezippt,
                ${sdf.format(new Date(textDump.lastModified()))},
                ${String.format("%.2f", textDump.length()/1000/1000)}MB</a></li>

            <li>Für Entwickler:
                <a href="../export/${dbDump.getName()}">MySQL-Dump,
                    ${sdf.format(new Date(dbDump.lastModified()))},
                    ${String.format("%.2f", dbDump.length()/1000/1000)}MB</a></li>

            <li>Siehe auch: <a href="api">API-Zugriff</a></li>

            <li style="margin-top:15px"><a href="../old/thes_de_DE_v2.zip">Deutscher Thesaurus for OpenOffice.org 2.x, 2009-08-02</a> (wird nicht mehr aktualisiert)</li>
            <li><a href="../old/kword_thesaurus.txt.gz">Thesaurus für KWord, 2009-08-02</a> (wird nicht mehr aktualisiert)</li>

        </ul>

        <p style="margin-top: 15px">In dem Zusammenhang vielleicht auch nützlich:
            <a href="http://www.danielnaber.de/morphologie/">Deutsches Vollformen-Wörterbuch zum Download</a> -
            eine Liste deutscher Wörter mit allen flektierten Formen und ihren grammatischen Eigenschaften</p>


        <h2>Download der Software</h2>

        <p>Den <a href="http://www.grails.org">Grails</a>-Sourcecode der Website kann man unter dem Namen
          <a href="http://sourceforge.net/projects/vithesaurus/">vithesaurus</a>
          bei Sourceforge herunterladen. Er steht unter der <a href="http://www.gnu.org/licenses/agpl.html">Affero General Public License (AGPL)</a>.
          Die Installation ist in einem <a href="http://vithesaurus.svn.sourceforge.net/viewvc/vithesaurus/trunk/README?revision=HEAD&amp;view=markup">README</a>
          und <a href="http://www.openthesaurus.de/jforum/posts/list/71.page">hier im Forum</a> beschrieben.
        </p>

    </body>
</html>
