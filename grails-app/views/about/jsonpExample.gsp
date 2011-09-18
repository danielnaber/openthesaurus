<%@page import="com.vionto.vithesaurus.*" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title>JSON/JSONP Beispiel - OpenThesaurus</title>
        <g:javascript library="prototype" />
    </head>
    <body>

        <hr />
        
        <h2>JSON/JSONP Beispiel</h2>

        <p>Diese Seite fragt OpenThesaurus über die JSON-<g:link action="api">API</g:link> an und zeigt das Ergebnis unten an.
        Siehe Quelltext dieser Seite für den Source-Code.</p>

        <g:render template="jsonWarning"/>

        <g:set var="query" value="hütte"/>
        
        <p>Ergebnis der API-Anfrage nach "${query}":</p>
        
        <div id="resultArea" style="background:#dddddd;padding:5px"></div>

        <script type="text/javascript">
        function myCallback(result) {
            var synonyms = "";
            for (var synsetCount = 0; synsetCount < result.synsets.length; synsetCount++) {
                for (var termCount = 0; termCount < result.synsets[synsetCount].terms.length; termCount++) {
                    var termObj = result.synsets[synsetCount].terms[termCount];
                    synonyms += termObj.term
                    if (termObj.level) {
                        synonyms += " (" + termObj.level + ")";
                    }
                    synonyms += ", "
                }
                synonyms += "<br/><br/>";
            }
            $('resultArea').update(synonyms);
        }
        </script>
        
        <script type="text/javascript" src="${grailsApplication.config.thesaurus.serverURL}${createLinkTo(dir:'synonyme')}/search?q=${query}&amp;format=application/json&callback=myCallback">
        </script>

    </body>
</html>
