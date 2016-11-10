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

        <g:if test="${grailsApplication.config.thesaurus.serverId == 'de'}">
    
            <h2>Download der Daten</h2>
    
            <a href="http://creativecommons.org/licenses/LGPL/2.1/deed.de"><img align="right" style="margin-left: 15px"
               src="${createLinkTo(dir:'images',file:'cc-LGPL-a.png')}" alt="GNU LGPL Logo"/></a>
            <p>Die Wörter aus OpenThesaurus lassen sich hier in verschiedenen Formaten
            herunterladen. Sie stehen unter der
            <a href="http://creativecommons.org/licenses/LGPL/2.1/deed.de">GNU Lesser
            General Public License</a> zur Verfügung.
            <!-- text from about/index: -->
            Das bedeutet vereinfacht gesagt, dass die Daten kostenlos genutzt, verarbeitet, geändert und weiterverbreitet
            werden können, solange die weiterverbreiteten Daten ebenfalls für den User klar erkennbar unter der
            LGPL stehen und openthesaurus.de als Quelle verlinkt wird.
            </p>
    
            <g:set var="sdf" value="${new SimpleDateFormat('yyyy-MM-dd HH:mm')}"/>
    
            <ul>
                <li>OpenThesaurus ist beim deutschsprachigen LibreOffice und OpenOffice bereits enthalten. Wer die aktuellste Version nutzen möchte,
                    kann sie hier herunterladen: 
                    <ul style="margin-top:0">
                      <li><a href="../export/${oooDump.getName()}">Deutscher Thesaurus für LibreOffice/OpenOffice,
                        ${sdf.format(new Date(oooDump.lastModified()))},
                        ${String.format("%.2f", oooDump.length()/1000/1000)}MB</a></li>
                      <g:if test="${oooDumpCh}">
                        <li><a href="../export/${oooDumpCh.getName()}">Schweizer Version</a> (wie deutsch, nur alle <span class="bsp">ß</span> durch <span class="bsp">ss</span> ersetzt)</li>
                      </g:if>
                    </ul>
                </li>
    
                <li><a href="../export/${textDump.getName()}">Thesaurus im Text-Format, gezippt,
                    ${sdf.format(new Date(textDump.lastModified()))},
                    ${String.format("%.2f", textDump.length()/1000/1000)}MB</a></li>
    
                <li>Für Entwickler:
                    <a href="../export/${dbDump.getName()}">MySQL-Dump,
                        ${sdf.format(new Date(dbDump.lastModified()))},
                        ${String.format("%.2f", dbDump.length()/1000/1000)}MB</a><br/>
                    In dem Zusammenhang nützlich:
                        <a href="http://www.danielnaber.de/morphologie/">Deutsches Vollformen-Wörterbuch zum Download</a> -
                    eine Liste deutscher Wörter mit allen flektierten Formen und ihren grammatischen Eigenschaften
                </li>
    
                <li>Siehe auch: <a href="api">API-Zugriff</a></li>
    
                <!--
                <li style="margin-top:15px"><a href="../old/thes_de_DE_v2.zip">Deutscher Thesaurus for OpenOffice.org 2.x, 2009-08-02</a> (wird nicht mehr aktualisiert)</li>
                <li><a href="../old/kword_thesaurus.txt.gz">Thesaurus für KWord, 2009-08-02</a> (wird nicht mehr aktualisiert)</li>
                -->
    
            </ul>
    
    
            <h2>Download der Software</h2>
    
            <p>Der Sourcecode der <a href="http://www.grails.org">Grails</a>-basierten Website kann bei
              <a href="https://github.com/danielnaber/openthesaurus">bei github</a>
              heruntergeladen werden:</p>
    
              <pre style="margin-bottom: 10px" class="api">git clone https://github.com/danielnaber/openthesaurus.git</pre>
    
              <p>Der Sourcecode steht unter der <a href="http://www.gnu.org/licenses/agpl.html">Affero General Public License (AGPL)</a>.
              Die Installation ist in einem <a href="https://github.com/danielnaber/openthesaurus/blob/master/README.md">README</a>
              und <a href="http://www.openthesaurus.de/jforum/posts/list/71.page">hier im Forum</a> beschrieben.</p>

        </g:if>
        <g:else>

            (Nothing here yet)

        </g:else>

    </body>
</html>
