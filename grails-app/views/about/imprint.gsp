<%@page import="com.vionto.vithesaurus.*" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title><g:message code="imprint.title" /></title>
        <meta name="robots" content="noindex">
    </head>
    <body>

            <hr />

            <g:if test="${grailsApplication.config.thesaurus.serverId == 'de'}">
                    
                <h2><g:message code="imprint.title" /></h2>
    
                <g:message code="imprint.content"/>
    
                <h2>Datenschutzerklärung</h2>
                
                <p>Die Verarbeitung personenbezogener Daten auf dieser Website erfolgt im Einklang mit
                der europäischen Datenschutz-Grundverordnung (DSGVO) und dem Bundesdatenschutzgesetz (BDSG) (2018).</p>

                <h2>Verwaltung von Genehmigungen</h2>

                <h3>Einwilligungsmanagement</h3>

                <h2>Allgemeines</h2>

                <p>Die Nutzung unserer Website erfolgt standardmäßig anonym.
                Unser Webserver ist so konfiguriert, dass IP-Adressen so gekürzt werden, dass sie nicht mehr 
                zur Identifikation benutzt werden (z.&thinsp;B. wird 192.168.0.0 gespeichert statt 192.168.2.3).
                Um uns gegen Missbrauch unseres Dienstes zu schützen, können im Ausnahmefall IP-Adressen
                vollständig gespeichert werden, jedoch nicht für mehr als 7 Tage.
                Die Fälle in denen wir trotzdem personenbezogene Daten von Ihnen speichern, sind im Folgenden
                beschrieben.</p>
                
                <p><b>Haben Sie uns eine Einwilligung zur Nutzung Ihrer Daten gegeben,
                können Sie diese jederzeit wie im Folgenden beschrieben widerrufen.</b></p>

                <h2>Anmeldung</h2>

                <p>Um Daten (Wörter, Synonyme etc.) auf openthesaurus.de ändern zu können, müssen Sie sich
                registrieren. So können wir Vandalismus verhindern und eine bessere Qualität der Daten
                sicherstellen.</p>
                
                <p>Bei einer Registrierung auf unserer Seite wird Ihr Nutzername und Ihre E-Mail-Adresse in unserer
                Datenbank gespeichert. Wollen Sie Ihren Account entfernen oder Daten ändern, schreiben Sie uns unter
                <g:render template="/email" model="${['message': 'dieser E-Mail-Adresse']}"/>, sofern Sie dies
                <g:link controller="user" action="edit">in Ihrem Profil</g:link> nicht selber können.
                
                <p>Nehmen Sie Änderungen an den Daten von OpenThesaurus vor, so wird dies öffentlich sichtbar mit
                Ihrem Nutzernamen (aber nicht Ihrer E-Mail) dokumentiert. Damit verbessern wir die Nachvollziehbarkeit
                von Änderungen und steigern langfristig die Datenqualität.</p>
                
                <h2>Web-Analytics</h2>
    
                <p>Unsere Website verwendet Matomo. Dabei handelt es sich um einen sogenannten Webanalysedienst. Matomo verwendet sog. “Cookies”, das sind Textdateien,
                die auf Ihrem Computer gespeichert werden und die unsererseits eine Analyse der Benutzung der Webseite ermöglichen. Zu diesem Zweck werden
                die durch den Cookie erzeugten Nutzungsinformationen (einschließlich Ihrer gekürzten IP-Adresse) an unseren Server übertragen und
                zu Nutzungsanalysezwecken gespeichert, was der Webseitenoptimierung unsererseits dient. Ihre IP-Adresse wird bei diesem Vorgang umgehend anonymisiert,
                so dass Sie als Nutzer für uns anonym bleiben. <!--Die durch den Cookie erzeugten Informationen über Ihre Benutzung dieser Webseite
                werden nicht an Dritte weitergegeben.--> Sie können die Verwendung der Cookies durch eine entsprechende Einstellung Ihrer Browser
                Software verhindern, es kann jedoch sein, dass Sie in diesem Fall gegebenenfalls nicht sämtliche Funktionen dieser Website voll umfänglich nutzen können.</p>
    
                <p>Wenn Sie mit der Speicherung und Auswertung dieser Daten aus Ihrem Besuch nicht einverstanden sind, dann können Sie der Speicherung und
                Nutzung nachfolgend per Mausklick jederzeit widersprechen. In diesem Fall wird in Ihrem Browser ein sog. Opt-Out-Cookie abgelegt,
                was zur Folge hat, dass Matomo keinerlei Sitzungsdaten erhebt. <strong>Achtung:</strong> Wenn Sie Ihre Cookies löschen, so hat dies zur
                Folge, dass auch das Opt-Out-Cookie gelöscht wird und ggf. von Ihnen erneut aktiviert werden muss.</p>
    
                <h3>Widerspruch:</h3>
    
                <iframe frameborder="no" width="600px" height="200px" src="https://analytics.languagetoolplus.com/matomo/index.php?module=CoreAdminHome&action=optOut&language=de"></iframe>

                <h2>Auskunft</h2>

                <p>Sie haben das Recht, auf Antrag unentgeltlich Auskunft zu erhalten über die personenbezogenen Daten, die über Sie
                gespeichert wurden.</p>
                
                <h2>Beschwerde</h2>
                
                <p>Wenn Sie der Ansicht sind, dass die Verarbeitung Ihrer personenbezogenen Daten rechtswidrig erfolgt,
                haben Sie das Recht, sich bei einer Aufsichtsbehörde zu beschweren.</p>

                <h2>Anpassungen</h2>

                <p>Gelegentlich müssen wir Passagen dieser Datenschutzbestimmungen anpassen. Zum Beispiel, wenn wir unsere Website ändern
                oder wenn sich die Gesetze für Cookies oder Datenschutz ändern. Wir oder unsere Partner können den Inhalt der
                Aussagen und der Cookies, die ohne vorherige Warnung angegeben werden, jederzeit ändern. Bitte kehren Sie zu
                dieser Seite zurück, um die neueste Version zu prüfen.</p>
                
                
                <h3>COOKIES</h3>

                <p>Was sind Cookies?

                <p>Cookies sind kleine Textdateien, die beim Besuch einer Internetseite verschickt und im Browser des Nutzers gespeichert werden.
                Wird die entsprechende Internetseite erneut aufgerufen, sendet der Browser des Nutzers den Inhalt der Cookies zurück 
                und ermöglicht so eine Wiedererkennung des Nutzers. Bestimmte Cookies werden nach Beendigung der Browser-Sitzung 
                automatisch gelöscht (sogenannte Session Cookies), andere werden für eine vorgegebene Zeit bzw. dauerhaft im
                Browser des Nutzers gespeichert und löschen sich danach selbständig (sogenannte temporäre oder permanente Cookies).

                <p>Welche Daten werden in den Cookies gespeichert?

                <p>In Cookies werden grundsätzlich keine personenbezogenen Daten gespeichert, sondern nur eine Online-Kennung.

                <p>Wie können Sie die Verwendung von Cookies verhindern bzw. Cookies löschen?

                <p>Sie können die Speicherung von Cookies über Ihre Browser-Einstellungen deaktivieren und bereits gespeicherte
                Cookies jederzeit in Ihrem Browser löschen. Bitte beachten Sie jedoch,
                dass dieses Online-Angebot ohne Cookies möglicherweise nicht oder nur noch eingeschränkt funktioniert.

                <p>Bitte beachten Sie weiterhin, dass Widersprüche gegen die Erstellung von Nutzungsprofilen teilweise über
                einen sogenannten "Opt-Out-Cookie" funktionieren. Sollten Sie alle Cookies löschen, findet ein Widerspruch
                daher evtl. keine Berücksichtigung mehr und muss von Ihnen erneut erhoben werden.


            </g:if>
            <g:else>
        
                (Nothing here yet)
        
            </g:else>

    </body>
</html>
