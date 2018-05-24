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
                
                <h2>Web-Analytics</h2>
    
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

                <h2>Anpassungen</h2>

                <p>Gelegentlich müssen wir Passagen dieser Datenschutzbestimmungen anpassen. Zum Beispiel, wenn wir unsere Website ändern
                oder wenn sich die Gesetze für Cookies oder Datenschutz ändern. Wir oder unsere Partner können den Inhalt der
                Aussagen und der Cookies, die ohne vorherige Warnung angegeben werden, jederzeit ändern. Bitte kehren Sie zu
                dieser Seite zurück, um die neueste Version zu prüfen.</p>
                
                
                <h2>Werbung</h2>

                Wir spielen Werbung aus mit Unterstützung der Yieldlove GmbH, Kehrwieder 9, 20457 Hamburg. Die folgenden
                Informationen beziehen sich darauf.
                
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
                Cookies jederzeit in Ihrem Browser löschen (siehe Abschnitt Technikhinweise). Bitte beachten Sie jedoch,
                dass dieses Online-Angebot ohne Cookies möglicherweise nicht oder nur noch eingeschränkt funktioniert.

                <p>Bitte beachten Sie weiterhin, dass Widersprüche gegen die Erstellung von Nutzungsprofilen teilweise über
                einen sogenannten "Opt-Out-Cookie" funktionieren. Sollten Sie alle Cookies löschen, findet ein Widerspruch
                daher evtl. keine Berücksichtigung mehr und muss von Ihnen erneut erhoben werden.


                <p>Was für Cookies verwendet yieldlove?

                <p><b>Analyse-Cookies</b><br>
                yieldlove verwendet Analyse-Cookies, um das Nutzungsverhalten (z. B. geklickte Werbebanner, besuchte Unterseiten, gestellte
                 Suchanfragen) ihrer Nutzer aufzeichnen und in statistischer Form auswerten zu können.

                <p><b>Werbe-Cookies</b><br>
                yieldlove verwendet auch Cookies zu werblichen Zwecken. Die mit Hilfe dieser Cookies erstellten Profile zum Nutzungsverhalten
                 (z. B. geklickte Werbebanner, besuchte Unterseiten, gestellte Suchanfragen) werden von yieldlove verwendet, um Ihnen
                  Werbung bzw. Angebote anzuzeigen, die auf Ihre Interessen zugeschnitten sind ("interessenbasierte Werbung").

                <p><b>Werbe-Cookies Dritter</b><br>
                yieldlove erlaubt auch anderen Unternehmen, Daten unserer Nutzer mithilfe von Werbe-Cookies zu erheben. Dies
                ermöglicht yieldlove und Dritten, den Nutzern unseres Online-Angebots interessenbasierte Werbung anzuzeigen,
                die auf einer Analyse ihres Nutzungsverhaltens (z. B. geklickte Werbebanner, besuchte Unterseiten, gestellte 
                Suchanfragen) insgesamt und nicht beschränkt auf unser Online-Angebot, basiert.

                <p>Yieldlove liefert im Auftrag seiner Kunden Werbebanner aus. Alle yieldlive-Banner verwenden Cookies. yieldlove platziert
                diese Banner mit Hilfe von Drittanbietern auf Websites Dritter, wie zum Beispiel einer Nachrichtenseite oder openthesaurus.de.

                <p>Zu Diagnosezwecken, Fehlersuche und Aufdeckung von betrügerischem Verhalten sammelt yieldlove in einigen Anzeigeneinheiten 
                Benutzerinformationen mittels Cookies, die eine Lebensdauer von 6 Monaten haben. Die erfassten Benutzerinformationen 
                umfassen Benutzeragent, Gerät, HTTP-Referrer und die IP. Diese Daten werden nicht länger als 7 Tage aufbewahrt.

                <p>Yieldlove unternimmt angemessene Schritte, um alle Informationen, die yieldlove verarbeitet, vor Missbrauch, Verlust, 
                unberechtigtem Zugriff, Änderung oder Benachrichtigung zu schützen. yieldlove ergreift physische, elektronische und 
                verfahrenstechnische Sicherheitsmaßnahmen, um die von yieldlove verarbeiteten Daten zu schützen. Dadurch beschränkt
                yieldlove den Zugriff auf diese Informationen auf autorisierte Mitarbeiter.

                <p>Für die Cookies, die yieldloves Drittanbieter zu Werbezwecken platzieren, verweist yieldlove auf die Disclaimer, die sie 
                zu dem Thema auf ihren eigenen Websites zur Verfügung gestellt haben. Beachten Sie, dass yieldlove sich nur auf diese 
                Haftungsausschlüsse beziehen kann, da sie sich regelmäßig ändern und Yieldlove keinen Einfluss darauf hat.
                
                
                <h3>DRITTANBIETER UND OPT-OUT</h3>

                <p>Eine zentrale Widerspruchsmöglichkeit für verschiedene Drittanbieter insbesondere US-amerikanischer Anbieter
                ist auch unter folgendem Link erreichbar: <a href="https://optout.networkadvertising.org">optout.networkadvertising.org</a>
                Sie können aber auch einen separaten Opt-out für jedes einzelne Unternehmen vornehmen mit dem yieldlove zusammenarbeiten.

                <p>Für die Datenerhebung zur Auslieferung von nutzungsbasierter Online-Werbung zuständig sind folgende
                Unternehmen im Auftrag der Yieldlove GmbH:
                
                
                <b>4w Marketplace</b>

                <p>4w Marketplace (www.4wmarketplace.com) setzt Technologien ein, um Ihnen für Sie relevante Werbeanzeigen zu
                präsentieren. Anbieter von 4w Marketplace ist 4w 4w Marketplace mit Sitz in Fisciano (Salerno) – 84084 in 
                Via Giovanni Paolo II n.100. Wenn Sie nicht wollen, dass weiterhin anonymisierte Daten von 4w Marketplace 
                gesammelt werden, klicken Sie bitte unten auf den Opt-out Link. Dieses OptOut-Cookie löscht die bisher 
                gespeicherten Informationen und verhindert ein weiteres Erfassen von Informationen. 
                
                Datenschutzbestimmungen: <a href="http://www.4wmarketplace.com/privacy/">http://www.4wmarketplace.com/privacy/</a><br>
                Opt-out: <a href="http://www.youronlinechoices.com/it/le-tue-scelte">http://www.youronlinechoices.com/it/le-tue-scelte</a><br>
                <a href="https://www.neustar.biz/privacy/opt-out">https://www.neustar.biz/privacy/opt-out</a>
                
                <p><b>Amazon</b>
                <p>Amazon (https://www.aps.amazon.com) setzt Technologien ein, um Ihnen für Sie relevante Werbeanzeigen zu präsentieren. Anbieter von Amazon publisher services ist Amazon publisher services mit Sitz in Washington – 410 Terry Ave. North, Seattle, WA 98109-5210. Wenn Sie nicht wollen, dass weiterhin anonymisierte Daten von Amazon publisher services gesammelt werden, klicken Sie bitte unten auf den Opt-out Link. Dieses OptOut-Cookie löscht die bisher gespeicherten Informationen und verhindert ein weiteres Erfassen von Informationen.
                <br>Datenschutzbestimmungen: <a href="https://www.amazon.com/gp/help/customer/display.html/ref=hp_left_sib?ie=UTF8&nodeId=468496">https://www.amazon.com/gp/help/customer/display.html/ref=hp_left_sib?ie=UTF8&nodeId=468496</a>
                <br>Opt-out: <a href="https://www.amazon.com/adprefs/ref=hp_468496_advertisingpref2">https://www.amazon.com/adprefs/ref=hp_468496_advertisingpref2</a>
                
                <p><b>Adform</b>
                <p>Adform (https://www.adform.com) setzt Technologien ein, um Ihnen für Sie relevante Werbeanzeigen zu präsentieren. Anbieter von Adform ist Adform mit Sitz in Wildersgade 10B, 1, 1408 Copenhagen, Dänemark. Wenn Sie nicht wollen, dass weiterhin anonymisierte Daten Adform gesammelt werden, klicken Sie bitte unten auf den Opt-out Link. Dieses OptOut-Cookie löscht die bisher gespeicherten Informationen und verhindert ein weiteres Erfassen von Informationen.
                <br>Datenschutzbestimmungen: <a href="https://site.adform.com/privacy-policy-opt-out/">https://site.adform.com/privacy-policy-opt-out/</a>
                <br>Opt-out: <a href="https://site.adform.com/privacy-policy-opt-out/">https://site.adform.com/privacy-policy-opt-out/</a>

                <p><b>AppNexus</b>
                <p>AppNexus (https://www.appnexus.com) setzt Technologien ein, um Ihnen für Sie relevante Werbeanzeigen zu präsentieren. Anbieter von AppNexus ist die AppNexus Group mit Sitz in New York – 28 W. 23rd  Street, New York, New York, 10010. Wenn Sie nicht wollen, dass weiterhin anonymisierte Daten von Appnexus gesammelt werden, klicken Sie bitte unten auf den Opt-out Link. Dieses OptOut-Cookie löscht die bisher gespeicherten Informationen und verhindert ein weiteres Erfassen von Informationen.
                <br>Datenschutzbestimmungen: <a href="https://www.appnexus.com/en/company/privacy-policy">https://www.appnexus.com/en/company/privacy-policy</a>
                <br>Opt-out: <a href="https://www.appnexus.com/en/company/platform-privacy-policy#choices">https://www.appnexus.com/en/company/platform-privacy-policy#choices</a>

                <p><b>Conversant</b>
                <p>Conversant (https://www.conversantmedia.com) setzt Technologien ein, um Ihnen für Sie relevante Werbeanzeigen zu präsentieren. Anbieter von Conversant ist Conversant inc. mit Sitz in Chicago (IL) – 101 North Wacker, 23rd  Floor Chicago, IL 60606. Wenn Sie nicht wollen, dass weiterhin anonymisierte Daten von Conversant gesammelt werden, klicken Sie bitte unten auf den Opt-out Link. Dieses OptOut-Cookie löscht die bisher gespeicherten Informationen und verhindert ein weiteres Erfassen von Informationen.
                <br>Datenschutzbestimmungen: <a href="http://www.conversantmedia.com/legal/privacy">http://www.conversantmedia.com/legal/privacy</a>
                <br>Opt-out: <a href="http://optout.conversantmedia.com/">http://optout.conversantmedia.com/</a>

                <p><b>Criteo</b>
                <p>Criteo (https://www.criteo.com) setzt Technologien ein, um Ihnen für Sie relevante Werbeanzeigen zu präsentieren. Anbieter von Criteo ist Criteo mit Sitz in Paris – 32 Rue Blanche – 75009 Paris - France. Wenn Sie nicht wollen, dass weiterhin anonymisierte Daten von Criteo gesammelt werden, klicken Sie bitte unten auf den Opt-out Link. Dieses OptOut-Cookie löscht die bisher gespeicherten Informationen und verhindert ein weiteres Erfassen von Informationen.
                <br>Datenschutzbestimmungen: <a href="http://www.criteo.com/privacy/">http://www.criteo.com/privacy/</a>
                <br>Opt-out: <a href="https://www.criteo.com/privacy/">https://www.criteo.com/privacy/</a>

                <p><b>District M</b>
                <p>District M (https://districtm.net) setzt Technologien ein, um Ihnen für Sie relevante Werbeanzeigen zu präsentieren. Anbieter von District M ist District M mit Sitz in Montreal – 5455 Gaspe Ave #730, Montreal, QC H2T 3B3, Canada. Wenn Sie nicht wollen, dass weiterhin anonymisierte Daten von District M gesammelt werden, klicken Sie bitte unten auf den Opt-out Link. Dieses OptOut-Cookie löscht die bisher gespeicherten Informationen und verhindert ein weiteres Erfassen von Informationen.
                <br>Datenschutzbestimmungen: <a href="https://districtm.net/en/page/platforms-data-and-privacy-policy/">https://districtm.net/en/page/platforms-data-and-privacy-policy/</a>
                <br>Opt-out: <a href="https://cdn.districtm.ca/optout.html">https://cdn.districtm.ca/optout.html</a>

                <p><b>Doublecklick</b>
                <p>Doubleclick (www.doubleclickbygoogle.com) setzt Technologien ein, um Ihnen für Sie relevante Werbeanzeigen zu präsentieren. Anbieter von Doubleclick ist Doubleclick ist Google Ireland Limited, Gordon House, Barrow St Dublin 4 Ireland. Wenn Sie nicht wollen, dass weiterhin anonymisierte Daten von Doubleclick gesammelt werden, klicken Sie bitte unten auf den Opt-out Link. Dieses OptOut-Cookie löscht die bisher gespeicherten Informationen und verhindert ein weiteres Erfassen von Informationen.
                <br>Datenschutzbestimmungen: <a href="http://www.google.com/intl/en/policies/privacy/">http://www.google.com/intl/en/policies/privacy/</a>
                <br>Opt-out: <a href="https://adssettings.google.com/authenticated?hl=en">https://adssettings.google.com/authenticated?hl=en</a>

                <p><b>Facebook</b>
                <p>Facebook (www.facebook.com) setzt Technologien ein, um Ihnen für Sie relevante Werbeanzeigen zu präsentieren. Anbieter von Facebook ist Facebook Inc., located in 1601 S. California Ave, Palo Alto, CA 94304, USA. Wenn Sie nicht wollen, dass weiterhin anonymisierte Daten von Facebook gesammelt werden, klicken Sie bitte unten auf den Opt-out Link. Dieses OptOut-Cookie löscht die bisher gespeicherten Informationen und verhindert ein weiteres Erfassen von Informationen.
                <br>Datenschutzbestimmungen: <a href="http://www.facebook.com/full_data_use_policy">http://www.facebook.com/full_data_use_policy</a>
                <br>Opt-out: <a href="http://www.facebook.com/ads/preferences">http://www.facebook.com/ads/preferences</a>

                <p><b>Indexexchange</b>
                <p>Indexexchange (www.indexexchange.com) setzt Technologien ein, um Ihnen für Sie relevante Werbeanzeigen zu präsentieren. Anbieter von Indexexchange ist Indexexchange mit Sitz in New York – 20 W 22nd  St. Suite 1101, New York, NY 10010. Wenn Sie nicht wollen, dass weiterhin anonymisierte Daten von Indexexchange gesammelt werden, klicken Sie bitte unten auf den Opt-out Link. Dieses OptOut-Cookie löscht die bisher gespeicherten Informationen und verhindert ein weiteres Erfassen von Informationen.
                <br>Datenschutzbestimmungen: <a href="http://www.indexexchange.com/privacy/">http://www.indexexchange.com/privacy/</a>
                <br>Opt-out: <a href="http://optout.networkadvertising.org/?c=1#!/">http://optout.networkadvertising.org/?c=1#!/</a>


                <p><b>Media.net</b>
                <p>Media.net (http://www.media.net/privacy-policy) setzt Technologien ein, um Ihnen für Sie relevante Werbeanzeigen zu präsentieren. Anbieter von Media.net ist Media.net Advertising Ltd. mit Sitz in Dubai – 107/108, DIC Building 5, Dubai Internet City, Dubai, 215028, United Arab Emirates. Wenn Sie nicht wollen, dass weiterhin anonymisierte Daten von Media.net gesammelt werden, klicken Sie bitte unten auf den Opt-out Link. Dieses OptOut-Cookie löscht die bisher gespeicherten Informationen und verhindert ein weiteres Erfassen von Informationen.
                <br>Datenschutzbestimmungen: <a href="http://www.media.net/privacy-policy">http://www.media.net/privacy-policy</a>
                <br>Opt-out: <a href="http://www.networkadvertising.org/choices/">http://www.networkadvertising.org/choices/</a>

                <p><b>Oath</b>
                <p>Oath (https://www.oath.com/) setzt Technologien ein, um Ihnen für Sie relevante Werbeanzeigen zu präsentieren. Anbieter von Oath ist Oath (EMEA) Limited mit Sitz in Dublin - 5-7 Point Square, North Wall Quay. Wenn Sie nicht wollen, dass weiterhin anonymisierte Daten von Oath gesammelt werden, klicken Sie bitte unten auf den Opt-out Link. Dieses OptOut-Cookie löscht die bisher gespeicherten Informationen und verhindert ein weiteres Erfassen von Informationen.
                <br>Datenschutzbestimmungen: <a href="http://privacy.aol.com/">http://privacy.aol.com/</a>
                <br>Opt-out: <a href="https://aim.yahoo.com/aim/ie/en/optout/">https://aim.yahoo.com/aim/ie/en/optout/</a>

                <p><b>OpenX</b>
                <p>OpenX (https://www.OpenX.com) setzt Technologien ein, um Ihnen für Sie relevante Werbeanzeigen zu präsentieren. Anbieter von OpenX ist OpenX mit Sitz in Pasadena – 888 E Walnut St, 2nd Floor, Pasadena CA, 91101, USA. Wenn Sie nicht wollen, dass weiterhin anonymisierte Daten von OpenX gesammelt werden, klicken Sie bitte unten auf den Opt-out Link. Dieses OptOut-Cookie löscht die bisher gespeicherten Informationen und verhindert ein weiteres Erfassen von Informationen.
                <br>Datenschutzbestimmungen: <a href="https://www.openx.com/de_de/privacy-policy/">https://www.openx.com/de_de/privacy-policy/</a>
                <br>Opt-out: <a href="https://www.openx.com/legal/interest-based-advertising/">https://www.openx.com/legal/interest-based-advertising/</a>

                <p><b>Pubmatic</b>
                <p>Pubmatic (https://www.pubmatic.com) setzt Technologien ein, um Ihnen für Sie relevante Werbeanzeigen zu präsentieren. Anbieter von Pubmatic ist Pubmatic, Inc. mit Sitz in Redwood City – 305 Main Street, First Floor, Redwood City, California 94063, USA. Wenn Sie nicht wollen, dass weiterhin anonymisierte Daten von Pubmatic gesammelt werden, klicken Sie bitte unten auf den Opt-out Link. Dieses OptOut-Cookie löscht die bisher gespeicherten Informationen und verhindert ein weiteres Erfassen von Informationen.
                <br>Datenschutzbestimmungen: <a href="https://www.openx.com/de_de/privacy-policy/">https://www.openx.com/de_de/privacy-policy/</a>
                <br>Opt-out: <a href="https://pubmatic.com/legal/opt-out/">https://pubmatic.com/legal/opt-out/</a>

                <p><b>Pulsepoint</b>
                <p>Pulsepoint (https://www.pulsepoint.com) setzt Technologien ein, um Ihnen für Sie relevante Werbeanzeigen zu präsentieren. Anbieter von Pulsepoint ist Pulsepoint, Inc. mit Sitz in New York – 360 Madison Avenue, 14th Floor, New York, NY 10017. Wenn Sie nicht wollen, dass weiterhin anonymisierte Daten von Template gesammelt werden, klicken Sie bitte unten auf den Opt-out Link. Dieses OptOut-Cookie löscht die bisher gespeicherten Informationen und verhindert ein weiteres Erfassen von Informationen.
                <br>Datenschutzbestimmungen: <a href="https://www.pulsepoint.com/privacy-policy">https://www.pulsepoint.com/privacy-policy</a>
                <br>Opt-out: <a href="http://optout.networkadvertising.org/?c=1#!/">http://optout.networkadvertising.org/?c=1#!/</a>

                <p><b>Reachnet</b>
                <p>Reachnet (https://www.reachnet.de) setzt Technologien ein, um Ihnen für Sie relevante Werbeanzeigen zu präsentieren. Anbieter von Reachnet ist Reachnet DE Ltd. mit Sitz in Hamburg – Grindelallee 41, D-20146 Hamburg. Wenn Sie nicht wollen, dass weiterhin anonymisierte Daten von Reachnet gesammelt werden, klicken Sie bitte unten auf den Opt-out Link. Dieses OptOut-Cookie löscht die bisher gespeicherten Informationen und verhindert ein weiteres Erfassen von Informationen.
                <br>Datenschutzbestimmungen: <a href="http://www.reachnet.de/unternehmen/agb.html">http://www.reachnet.de/unternehmen/agb.html</a>
                <br>Opt-out: <a href="https://adfarm1.adition.com/opt?m=optout&n=73">https://adfarm1.adition.com/opt?m=optout&n=73</a>

                <p><b>Rubicon Project</b>
                <p>Rubicon Project (https://www.rubiconproject.com) setzt Technologien ein, um Ihnen für Sie relevante Werbeanzeigen zu präsentieren. Anbieter von Rubicon Project ist Rubicon Project, inc. mit Sitz in Playa Vista – 12181 Bluff Creek Drive, 4th Floor, Playa Vista, CA 90094, USA. Wenn Sie nicht wollen, dass weiterhin anonymisierte Daten von Rubicon Project gesammelt werden, klicken Sie bitte unten auf den Opt-out Link. Dieses OptOut-Cookie löscht die bisher gespeicherten Informationen und verhindert ein weiteres Erfassen von Informationen.
                <br>Datenschutzbestimmungen: <a href="http://www.rubiconproject.com/privacy-policy/">http://www.rubiconproject.com/privacy-policy/</a>
                <br>Opt-out: <a href="https://rubiconproject.com/privacy/consumer-online-profile-and-opt-out/">https://rubiconproject.com/privacy/consumer-online-profile-and-opt-out/</a>

                <p><b>Primis</b>
                <p>Primis (https://www.primis.tech) setzt Technologien ein, um Ihnen für Sie relevante Werbeanzeigen zu präsentieren. Anbieter von Primis ist Primis LTD mit Sitz in 622 Third avenue, McCann New York House
                10017 New York City, USA. Wenn Sie nicht wollen, dass weiterhin anonymisierte Daten von Primis gesammelt werden, klicken Sie bitte unten auf den Opt-out Link. Dieses OptOut-Cookie löscht die bisher gespeicherten Informationen und verhindert ein weiteres Erfassen von Informationen.
                <br>Datenschutzbestimmungen: <a href="https://www.primis.tech/wp-content/uploads/2018/02/primisPrivacyPolicy2018.pdf">https://www.primis.tech/wp-content/uploads/2018/02/primisPrivacyPolicy2018.pdf</a>
                <br>Opt-out: <a href="https://web.archive.org/web/20180116234711/http:/live.sekindo.com/utils/cookieOptOut.php">https://web.archive.org/web/20180116234711/http:/live.sekindo.com/utils/cookieOptOut.php</a>

                <p><b>Smaato</b>
                <p>Smaato (https://www.smaato.com) setzt Technologien ein, um Ihnen für Sie relevante Werbeanzeigen zu präsentieren. Anbieter von Smaato ist Smaato Ad Services mit Sitz in Hamburg – Valentinskamp 70, Emporio, 20355 Hamburg, Germany. Wenn Sie nicht wollen, dass weiterhin anonymisierte Daten von Smaato gesammelt werden, klicken Sie bitte unten auf den Opt-out Link. Dieses OptOut-Cookie löscht die bisher gespeicherten Informationen und verhindert ein weiteres Erfassen von Informationen.
                <br>Datenschutzbestimmungen: <a href="https://www.smaato.com/privacy/">https://www.smaato.com/privacy/</a>
                <br>Opt-out: <a href="http://www.youronlinechoices.eu">http://www.youronlinechoices.eu</a>

                <p><b>SmartAdserver</b>
                <p>SmartAdserver (https://www.smartadserver.com) setzt Technologien ein, um Ihnen für Sie relevante Werbeanzeigen zu präsentieren. Anbieter von SmartAdserver ist SmartAdserver mit Sitz in Paris – 66 Rue de la Chaussée d´Antin, 75009 Paris, France. Wenn Sie nicht wollen, dass weiterhin anonymisierte Daten von SmartAdserver gesammelt werden, klicken Sie bitte unten auf den Opt-out Link. Dieses OptOut-Cookie löscht die bisher gespeicherten Informationen und verhindert ein weiteres Erfassen von Informationen.
                <br>Datenschutzbestimmungen: <a href="http://smartadserver.com/company/privacy-policy/">http://smartadserver.com/company/privacy-policy/</a>
                <br>Opt-out: <a href="http://www.smartadserver.com/diffx/optout/IABOptout.aspx">http://www.smartadserver.com/diffx/optout/IABOptout.aspx</a>

                <p><b>Sovrn</b>
                <p>Sovrn (https://www.sovrn.com) setzt Technologien ein, um Ihnen für Sie relevante Werbeanzeigen zu präsentieren. Anbieter von Sovrn ist Sovrn Holdings, Inc. mit Sitz in Boulder – 5541 Central Avenue, Boulder, CO 80301. Wenn Sie nicht wollen, dass weiterhin anonymisierte Daten von Sovrn gesammelt werden, klicken Sie bitte unten auf den Opt-out Link. Dieses OptOut-Cookie löscht die bisher gespeicherten Informationen und verhindert ein weiteres Erfassen von Informationen.
                <br>Datenschutzbestimmungen: <a href="https://www.sovrn.com/privacy-policy-eu/">https://www.sovrn.com/privacy-policy-eu/</a>
                <br>Opt-out: <a href="https://info.evidon.com/pub_info/15620?v=1&nt=0&nw=false">https://info.evidon.com/pub_info/15620?v=1&nt=0&nw=false</a>

                <p><b>Ströer SSP</b>
                <p>Ströer SSP (https://www.adscale.de) setzt Technologien ein, um Ihnen für Sie relevante Werbeanzeigen zu präsentieren. Anbieter von Ströer SSP ist die Ströer media Deutschland GmbH mit Sitz in Köln – 50999 Köln, Ströer-Allee 1. Wenn Sie nicht wollen, dass weiterhin anonymisierte Daten von Adscale gesammelt werden, klicken Sie bitte unten auf den Opt-out Link. Dieses OptOut-Cookie löscht die bisher gespeicherten Informationen und verhindert ein weiteres Erfassen von Informationen.
                <br>Datenschutzbestimmungen: <a href="http://www.adscale.de/datenschutz">http://www.adscale.de/datenschutz</a>
                <br>Opt-out: <a href="http://ih.adscale.de/adscale-ih/oo">http://ih.adscale.de/adscale-ih/oo</a>

                <p><b>Twiago</b>
                <p>Twiago (https://www.twiago.com) setzt Technologien ein, um Ihnen für Sie relevante Werbeanzeigen zu präsentieren. Anbieter von Twiago ist Twiago mit Sitz in Köln – Gustav-Heinemann-Ufer 72b, 50968 Köln. Wenn Sie nicht wollen, dass weiterhin anonymisierte Daten von Twiago gesammelt werden, klicken Sie bitte unten auf den Opt-out Link. Dieses OptOut-Cookie löscht die bisher gespeicherten Informationen und verhindert ein weiteres Erfassen von Informationen.
                <br>Datenschutzbestimmungen: <a href="http://www.twiago.com/datenschutz/">http://www.twiago.com/datenschutz/</a>
                <br>Opt-out: <a href="http://control.twiago.com/privacy.php?lang=0">http://control.twiago.com/privacy.php?lang=0</a>

                <p><b>Mopub</b>
                <p>Mopub (https://www.mopub.com) setzt Technologien ein, um Ihnen für Sie relevante Werbeanzeigen zu präsentieren. Anbieter von Mopub ist Twitter, Inc. mit Sitz in San Francisco – 1355 Market Street, Suite 900, San Francisco, Ca 94103. Wenn Sie nicht wollen, dass weiterhin anonymisierte Daten von Moppub gesammelt werden, klicken Sie bitte unten auf den Opt-out Link. Dieses OptOut-Cookie löscht die bisher gespeicherten Informationen und verhindert ein weiteres Erfassen von Informationen.
                <br>Datenschutzbestimmungen: <a href="https://www.mopub.com/legal/privacy/">https://www.mopub.com/legal/privacy/</a>
                <br>Opt-out: <a href="https://www.mopub.com/legal/privacy/">https://www.mopub.com/legal/privacy/</a>

                <p><b>Inmobi</b>
                <p>Inmobi (https://www.inmobi.com) setzt Technologien ein, um Ihnen für Sie relevante Werbeanzeigen zu präsentieren. Anbieter von Inmobi ist Inmobi Pte Ltd mit Sitz in Bangalore – Embassy Tech Square, Kadubeesanahalli Village Outer Ring Roard, Varthur Hobli, Bangalore 560103. Wenn Sie nicht wollen, dass weiterhin anonymisierte Daten von Inmobi gesammelt werden, klicken Sie bitte unten auf den Opt-out Link. Dieses OptOut-Cookie löscht die bisher gespeicherten Informationen und verhindert ein weiteres Erfassen von Informationen.
                <br>Datenschutzbestimmungen: <a href="https://www.inmobi.com/privacy-policy">https://www.inmobi.com/privacy-policy</a>
                <br>Opt-out: <a href="https://www.inmobi.com/page/opt-out/">https://www.inmobi.com/page/opt-out/</a>
                
                <h3>SONSTIGE / UNVORHERSEHBARE COOKIES</h3>

                <p>Aufgrund der Funktionsweise von Internet und Websites ist es möglich, dass yieldlove nicht immer auf die Cookies achtet, die 
                durch yieldloves Banner von Drittanbietern platziert werden. Dies ist insbesondere dann der Fall, wenn yieldloves Banner 
                eingebettete Elemente wie Texte, Dokumente, Bilder oder Filmclips enthalten, die von einer anderen Partei gespeichert, 
                aber auf oder in yieldloves Banner angezeigt werden.

                <p>Sollten Sie auf dieser Website Cookies finden, die in diese Kategorie fallen, die wir oben nicht erwähnt haben, 
                teilen Sie uns oder yieldlove dies bitte umgehend mit oder kontaktieren Sie direkt diesen Drittanbieter und fragen Sie, welche Cookies 
                platziert wurden, was der Grund dafür war, wie lange der Cookie bestehen bleibt und auf welche Weise Ihre Privatsphäre 
                geschützt wird.
                
                
                <h3>IHRE RECHTE IN BEZUG AUF IHRE DATEN</h3>

                <p>Yieldlove betrachtet die Daten der Werbebanner nicht als personenbezogene Daten gemäß geltendem Recht. Ebenso 
                sammeln oder verarbeiten wir keine sensiblen persönlichen Daten wie Daten über Rasse oder ethnische Herkunft,
                politische Meinungen, religiöse oder philosophische Überzeugungen, Gewerkschaftsmitgliedschaft, Gesundheit oder 
                Sexualleben. Darüber hinaus sammeln wir wissentlich auch keine Daten von Kindern unter 12 Jahren.

                <p>Wenn Sie die von yieldlove zur Verfügung gestellten Werbebannerdaten korrigieren, aktualisieren oder löschen 
                möchten oder wenn Sie die personenbezogenen Daten, die Sie yieldlove über das Kontaktformular auf yieldloves Homepage 
                zur Verfügung gestellt haben, korrigieren, aktualisieren oder löschen möchten, können Sie yieldlove kontaktieren per
                E-Mail an privacy@yieldlove.com.

                <p>Yieldlove nimmt an den Selbstregulierungs-Programmen der European Digital Advertising Alliance (EDAA) teil und hält sich
                an die EDAA-Prinzipien für Online Behavioral Advertising. Die EDAA fungiert hauptsächlich als zentrale Lizenzierungsstelle 
                für das OBA-Symbol und bietet den Verbrauchern technische Möglichkeiten, Transparenz und Kontrolle über OBA über die 
                Online-Plattform für Verbraucherwahl von youronlinechoices.eu auszuüben. Die EDAA wird von Organisationen auf EU-Ebene
                geregelt, die die Wertschöpfungskette der OBA in Europa bilden und die europäische Konsistenz in der Vorgehensweise sicherstellen.
                Klicken Sie hier, um mehr über die EDAA zu erfahren.
                
                <p>Wenn Sie Fragen und / oder Kommentare haben oder eine Beschwerde im Bereich Werbung einreichen möchten,
                kontaktieren Sie uns oder yieldlove per E-Mail unter privacy@yieldlove.com.
                
            </g:if>
            <g:else>
        
                (Nothing here yet)
        
            </g:else>

    </body>
</html>
