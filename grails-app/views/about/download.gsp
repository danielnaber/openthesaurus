<%@page import="java.text.*" %>
<%@page import="com.vionto.vithesaurus.*" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title><g:message code="download.title" /></title>
        <meta name="description" content="Download der freien OpenThesaurus-Daten in verschiedenen Formaten, u.a. Text und für OpenOffice.org."/>
    </head>
    <body>

        <hr />
    
        <h2>Download der OpenThesaurus-Daten</h2>

        <p>Die Wörter aus OpenThesaurus lassen sich hier in verschiedenen Formaten
        herunterladen:</p>

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

        <li>Siehe auch <a href="api">API-Zugriff</a></li>

        <li style="margin-top:20px"><a href="../old/thes_de_DE_v2.zip">Deutscher Thesaurus for OpenOffice.org 2.x, 2009-08-02</a> (wird nicht mehr aktualisiert)</li>
        <li><a href="../old/kword_thesaurus.txt.gz">Thesaurus für KWord, 2009-08-02</a> (wird nicht mehr aktualisiert)</li>

        <li style="margin-top:20px">OpenThesaurus als Software für Mac und Android <a href="./">auf dieser Seite</a></li>

        </ul>

        <p style="margin-top:20px">Die Daten stehen zur Verfügung unter der
        <a href="http://creativecommons.org/licenses/LGPL/2.1/deed.de">GNU Lesser
        General Public License</a>.
        </p>

    </body>
</html>
