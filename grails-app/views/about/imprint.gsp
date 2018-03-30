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
    
                <h2>Datenschutzerklärung</h2>
                
                <p>Die Verarbeitung personenbezogener Daten auf dieser Website erfolgt im Einklang mit
                der europäischen Datenschutz-Grundverordnung (DSGVO) und dem Bundesdatenschutzgesetz (BDSG) (2018).</p>
                
                <p>Die Nutzung unserer Website erfolgt standardmäßig anonym. 
                Unser Webserver ist so konfiguriert, dass IP-Adressen so gekürzt werden, dass sie nicht mehr 
                zur Identifikation benutzt werden (z.&thinsp;B. wird 192.168.0.0 gespeichert statt 192.168.2.3).
                Die Fälle in denen wir trotzdem personenbezogene Daten von Ihnen speichern, sind im Folgenden
                beschrieben.</p>
                
                <p><b>Haben Sie uns eine Einwilligung zur Nutzung Ihrer Daten gegeben, z.&thinsp;B. durch Abonnieren
                des Newsletters, können Sie diese jederzeit wie im Folgenden beschrieben widerrufen.</b></p>

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
                
                <h2>Newsletter</h2>

                <p>Wenn Sie unseren Newsletter abonnieren, wird Ihre E-Mail-Adresse bis zu Ihrer Abmeldung
                bei unserem Dienstleister <a href="https://www.cleverreach.com">CleverReach</a> 
                (CleverReach GmbH & Co. KG, Muehlenstr. 43, 26180 Rastede) gespeichert.
                Um sich abzumelden und damit Ihre Daten zu löschen, melden Sie sich über den in jedem
                Newsletter vorhandenen Abmelde-Link ab, oder schreiben Sie uns an
                <g:render template="/email" model="${['message': 'diese E-Mail-Adresse']}"/>.
                
                <p>Hier finden Sie
                <a href="https://www.cleverreach.com/de/datenschutz/">die Datenschutzerklärung von Cleverreach</a>.
                
                <h2>Cookies</h2>

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
                    <li>Yieldlove GmbH, Neuer Pferdemarkt 1, 20359 Hamburg („Yieldlove“) vermarktet
                    Online-Werbeflächen auf unseren Angeboten openthesaurus.de und der mobilen
                    Website von openthesaurus und ermöglicht uns so die kostenlose Bereitstellung der Website.
                    Um die Werbeauslieferung auf den Webseiten zu
                    optimieren, werden durch Yieldlove Cookies eingesetzt.
                    Alle Informationen dazu, wie Yieldlove Daten verarbeitet und welche Daten
                    betroffen sind, erhalten Sie in der Privacy Policy von Yieldlove. Zudem
                    können Sie unter dem angegebenen Link dem Einsatz von Cookies durch
                    Yieldlove für die Zukunft widersprechen (Opt-out):
                    <a href="http://www.yieldlove.com/cookie-policy">http://www.yieldlove.com/cookie-policy</a></li>
                </ul>
                
                <br>
                
                <p>Bitte beachten Sie, dass Sie nach einer eventuellen Deaktivierung der Anzeige personalisierter Werbeanzeigen von Yieldlove und 
                anderen Werbepartnern weiterhin Werbeanzeigen erhalten können, die jedoch weniger passgenau auf Ihre Interessen/Ihr Surfverhalten abgestimmt sind.
                
                <h3>Kategorie: Web-Analytics</h3>
    
                <p>Unserer Website verwendet Piwik/Matomo, gehostet bei <a href="http://www.mysnip-solutions.de/impressum.html">mysnip</a>
                (MySnip Solutions - Thomas Seifert, Kreutzigerstr. 4a, 10247 Berlin). Dabei handelt es sich um einen sogenannten Webanalysedienst. Piwik verwendet sog. “Cookies”, das sind Textdateien,
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

                <h2>Auskunft</h2>

                <p>Sie haben das Recht, auf Antrag unentgeltlich Auskunft zu erhalten über die personenbezogenen Daten, die über Sie
                gespeichert wurden.</p>
                
                <h2>Beschwerde</h2>
                
                <p>Wenn Sie der Ansicht sind, dass die Verarbeitung Ihrer personenbezogenen Daten rechtswidrig erfolgt,
                haben Sie das Recht, sich bei einer Aufsichtsbehörde zu beschweren.</p>
                
                
            </g:if>
            <g:else>
        
                (Nothing here yet)
        
            </g:else>

    </body>
</html>
