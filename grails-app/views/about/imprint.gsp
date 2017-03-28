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

                <p>Die meisten Browser sind automatisch so eingestellt, dass Cookies akzeptiert werden. Auf Wunsch können
                Sie Ihren Browser jedoch durch Änderung Ihrer Browser-Einstellungen so konfigurieren, dass Cookies eingeschränkt
                oder völlig blockiert werden. Umfassende Informationen dazu, wie man dies auf einer Vielzahl von Browsern
                bewerkstelligen kann, erhalten Sie auf den folgenden Internetseiten: <a href="http://www.youronlinechoices.com/de/">youronlinechoices</a>,
                <a href="https://www.networkadvertising.org/choices/">Network Advertising Initiative</a>
                und/oder <a href="http://www.aboutads.info/choices/">Digital Advertising Alliance</a>. Sie finden dort auch Angaben dazu, wie Sie Cookies von
                Ihrem Computer löschen können sowie allgemeine Informationen über Cookies.

                <p>Für Informationen dazu, wie Sie diese Einstellungen auf dem Browser Ihres Handys
                vornehmen können, ziehen Sie bitte die Bedienungsanleitung Ihres Mobiltelefons heran.

                <p>Nachstehend finden Sie eine Liste von Anbietern, die befugt sind, Cookies auf unserer Website zu setzen sowie Informationen 
                darüber, wie Sie sich entsprechend abmelden können.

                <h3>Kategorie: Werbung</h3>

                <ul>
                    <li>Criteo (<a href="http://www.criteo.com/de/privacy/full-privacy-text/">Datenschutz</a>): Zweck der Criteo Cookies ist
                    das Targeting/Retargeting der Nutzer unserer Website, um 
                    bei ihrer zukünftigen Navigation personalisierte Werbeanzeigen anzuzeigen.</li>
                </ul>
                
                <br>
                <p>Die Nutzer können ihre Wahl auch über die folgenden Plattformen treffen:
                <a href="http://youronlinechoices.eu/de/">IAB Opt-Out Plattform</a>,
                <a href="https://www.networkadvertising.org/choices/">Network Advertising Initiative Opt-Out Plattform</a>,
                <a href="http://www.aboutads.info/choices/">Digital Advertising Alliance Plattform</a>, die Optionen anbieten,
                um eine Entscheidung für alle Unternehmen, die auf dieser Plattform registriert sind, zu treffen. 
                
                <p>Bitte beachten Sie, dass Sie nach einer eventuellen Deaktivierung der Anzeige personalisierter Werbeanzeigen von Criteo und 
                anderen Werbepartnern weiterhin Werbeanzeigen erhalten werden, die jedoch weniger passgenau auf Ihre Interessen/Ihr SurfVerhalten abgestimmt sind.
                
                <h3>Kategorie: Web-Analytics</h3>
    
                <p>Unserer Website verwendet Piwik, gehostet bei <a href="http://www.mysnip-solutions.de/impressum.html">mysnip</a>, dabei handelt es sich um einen sogenannten Webanalysedienst. Piwik verwendet sog. “Cookies”, das sind Textdateien,
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
    
                <iframe frameborder="no" width="600px" height="200px" src="//openthesaurus.stats.mysnip-hosting.de/index.php?module=CoreAdminHome&action=optOut&language=de"></iframe>

            </g:if>
            <g:else>
        
                (Nothing here yet)
        
            </g:else>

    </body>
</html>
