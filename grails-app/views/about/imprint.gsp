<%@page import="com.vionto.vithesaurus.*" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title><g:message code="imprint.title" /></title>
    </head>
    <body>

            <hr />

            <g:if test="${grailsApplication.config.thesaurus.serverId == 'de'}">
                    
                <h2><g:message code="imprint.title" /></h2>
    
                <g:message code="imprint.content"/>
    
                <h2>Analysedienste &amp; Datenschutz</h2>
    
                <p>Unserer Website verwendet Piwik, dabei handelt es sich um einen sogenannten Webanalysedienst. Piwik verwendet sog. “Cookies”, das sind Textdateien,
                die auf Ihrem Computer gespeichert werden und die unsererseits eine Analyse der Benutzung der Webseite ermöglichen. Zu diesem Zweck werden
                die durch den Cookie erzeugten Nutzungsinformationen (einschließlich Ihrer gekürzten IP-Adresse) an unseren Server übertragen und
                zu Nutzungsanalysezwecken gespeichert, was der Webseitenoptimierung unsererseits dient. Ihre IP-Adresse wird bei diesem Vorgang umgehend anonymisiert,
                so dass Sie als Nutzer für uns anonym bleiben. <!--Die durch den Cookie erzeugten Informationen über Ihre Benutzung dieser Webseite
                werden nicht an Dritte weitergegeben.--> Sie können die Verwendung der Cookies durch eine entsprechende Einstellung Ihrer Browser
                Software verhindern, es kann jedoch sein, dass Sie in diesem Fall gegebenenfalls nicht sämtliche Funktionen dieser Website voll umfänglich nutzen können.</p>
    
                <p>Wenn Sie mit der Speicherung und Auswertung dieser Daten aus Ihrem Besuch nicht einverstanden sind, dann können Sie der Speicherung und
                Nutzung nachfolgend per Mausklick jederzeit widersprechen. In diesem Fall wird in Ihrem Browser ein sog. Opt-Out-Cookie abgelegt,
                was zur Folge hat, dass Piwik keinerlei Sitzungsdaten erhebt. <strong>Achtung:</strong> Wenn Sie Ihre Cookies löschen, so hat dies zur
                Folge, dass auch das Opt-Out-Cookie gelöscht wird und ggf. von Ihnen erneut aktiviert werden muss.</p>
    
                <h3>Widerspruch:</h3>
    
                <iframe frameborder="no" width="600px" height="200px" src="http://openthesaurus.stats.mysnip-hosting.de/index.php?module=CoreAdminHome&action=optOut&language=de"></iframe>

            </g:if>
            <g:else>
        
                (Nothing here yet)
        
            </g:else>

    </body>
</html>
