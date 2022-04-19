<%@page import="com.vionto.vithesaurus.*" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title><g:message code="imprint.title" /></title>
        <meta name="robots" content="noindex">
        <style type="text/css">
            .T1, .T2, .T3, .T4, .T5, .T6, .T7, .T8, .T9, .T10, .T11, .T12, .T13, .T14, .T15, .T16, .T17, .T18, .T19, .T20, .T21, .T22, .T23, .T24, .T25,
             .T26, .T27, .T28, .T29, .T30, .T31, .T32, .T33, .T34 {
                font-size: 14px;
            }
        </style>
        <!-- yieldlove -->
        <script>
            window.yieldlove_cmp = window.yieldlove_cmp || {};
            window.yieldlove_cmp.config = {
                targetingParams: {
                    isPrivacyPolicyPage: true
                }
            }
        </script>
        <script type="text/javascript" src="https://cdn-a.yieldlove.com/yieldlove-bidder.js?openthesaurus.de_artikelseite"></script>
        <!-- /yieldlove -->
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

                <p>Wir nehmen am IAB Europe Transparency & Consent Framework teil und erfüllen dessen Spezifikationen und Richtlinien. Dafür setzen wir die Consent-Management-Plattform (CMP) der Sourcepoint Technologie Inc., 228 Park Ave S #87903, New York 10003-1502, USA als Auftragsverarbeiter ein. Im Rahmen des IAB Europe Transparency & Consent Frameworks hat Sourcepoint die Identifikationsnummer 6. Die CMP von Sourcepoint ermöglicht es Ihnen uns eine datenschutzkonforme Einwilligung in die Verarbeitung Ihrer Daten zu erteilen sowie diese jederzeit zu widerrufen. Auch können Sie der Datenverarbeitung widersprechen, die auf unserem berechtigten Interesse beruht.
                <p>Eine Übersicht Ihrer Einstellungsmöglichkeiten, den Zwecken und eingebundenen Dritten finden sie hier: <a href="#" style="cursor: pointer;" onclick="window.yieldlove_cmp.loadPrivacyManager()">Privacy Manager</a>
                <p>Weitere Informationen zum Datenschutz und der CMP finden Sie auf der Webseite von Sourcepoint: <a href="https://www.sourcepoint.com/privacy-policy">https://www.sourcepoint.com/privacy-policy</a>

                <h2>Allgemeines</h2>

                <p>Die Nutzung unserer Website erfolgt standardmäßig anonym.
                Unser Webserver ist so konfiguriert, dass IP-Adressen so gekürzt werden, dass sie nicht mehr 
                zur Identifikation benutzt werden (z.&thinsp;B. wird 192.168.0.0 gespeichert statt 192.168.2.3).
                Um uns gegen Missbrauch unseres Dienstes zu schützen, können im Ausnahmefall IP-Adressen
                vollständig gespeichert werden, jedoch nicht für mehr als 7 Tage.
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
    
                <p>Unsere Website verwendet Piwik/Matomo. Dabei handelt es sich um einen sogenannten Webanalysedienst. Piwik verwendet sog. “Cookies”, das sind Textdateien,
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
                
                
                <h2>Werbung über Publishing Partner</h2>

                <p>openthesaurus.de enthält nutzungsbasierte Online-Werbung von Drittanbietern. Diese wird über folgende Werbevermarkter
                    ausgespielt:
                    <ul>
                        <li>Yieldlove GmbH, Neuer Pferdemarkt 1, 20359 Hamburg („Yieldlove“)</li>
                    </ul>
                            
                <p>Um die Werbeauslieferung zu optimieren, werden von unseren Werbevermarktern und deren Partnern Cookies eingesetzt.</p>

                <p>Informationen dazu, wie Yieldlove Daten verarbeitet und welche Daten betroffen sind, erhalten Sie auch in der Privacy 
                Policy von Yieldlove: <a href="http://www.yieldlove.com/privacy">www.yieldlove.com/privacy</a>.

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


                <p>Was für Cookies verwenden unsere Werbevermarkter?

                <!-- yieldlove -->

                <h1 class="P26"><span
                        class="T1">WERBE-COOKIES DRITTER</span></h1>
                <p class="Standard"><span class="T1">Yieldlove ermöglicht es</span><span class="T1"> anderen Unternehmen, Daten seiner Nutzer mithilfe von Werbe-Cookies zu erheben. Dies ermöglicht es Dritten, den Nutzern seines Online-Angebots interessenbasierte Werbung anzuzeigen, die auf einer Analyse ihres Nutzungsverhaltens (z. B. geklickte Werbebanner, besuchte Unterseiten, gestellte Suchanfragen) insgesamt und nicht beschränkt auf sein Online-Angebot, basiert.</span>
                </p>
                <p class="P2"></p>
                <p class="P2"></p>
                <p class="Standard"><span class="T1">Yieldlove liefert im Auftrag seiner Kunden Werbebanner aus. Alle Yieldlove Banner verwenden Cookies. Yieldlove platziert diese Banner mit Hilfe von Drittanbietern auf Websites Dritter, wie zum Beispiel einer Nachrichtenseite.</span>
                </p>
                <p class="P2"></p>
                <p class="Standard"><span class="T1">Für die Cookies, die Yieldloves Drittanbieter zu Werbezwecken platzieren, verweist Yieldlove auf den Disclaimer, den sie zu dem Thema auf ihren eigenen Websites zur Verfügung gestellt haben. Beachten Sie, dass Yieldlove sich nur auf diese Haftungsausschlüsse beziehen kann, da sie sich regelmäßig ändern und Yieldlove keinen Einfluss darauf hat.</span>
                </p>
                <p class="P2"></p>
                <p class="P2"></p>
                <p class="P2"></p>
                <p class="Standard"><span class="T1">DRITTANBIETER UND OPT-OUT</span></p>
                <p class="P2"></p>
                <p class="Standard"><span class="T1">Eine zentrale Widerspruchsmöglichkeit für verschiedene Drittanbieter insbesondere US-amerikanischer Anbieter ist auch unter folgendem Link erreichbar: optout.networkadvertising.org</span>
                </p>
                <p class="Standard"><span class="T1">Sie können aber auch einen separaten Opt-out für jedes einzelne Unternehmen vornehmen mit dem Yieldlove zusammenarbeitet. </span>
                </p>
                <p class="P2"></p>
                <p class="Standard"><span class="T1">Für die Datenerhebung zur Auslieferung von nutzungsbasierter Online-Werbung zuständig sind folgende Unternehmen im Auftrag der Yieldlove GmbH:</span>
                </p>
                <p class="P2"></p>
                <p class="P5"></p>
                <p class="Standard"><span class="T12">4w Marketplace</span></p>
                <p class="P5"></p>
                <p class="Standard"><span class="T1">4w Marketplace (www.4wmarketplace.com) setzt Technologien ein, um Ihnen für Sie relevante Werbeanzeigen zu präsentieren. Anbieter von 4w Marketplace ist 4w 4w Marketplace mit Sitz in Fisciano (Salerno) – 84084 in Via Giovanni Paolo II n.100. Wenn Sie nicht wollen, dass weiterhin anonymisierte Daten von 4w Marketplace gesammelt werden, klicken Sie bitte unten auf den Opt-out Link. Dieses OptOut-</span><span
                        class="T1">Cookie löscht die bisher gespeicherten Informationen und verhindert ein weiteres Erfassen von Informationen. </span>
                </p>
                <p class="P2"></p>
                <h1 class="P1"><a
                        id="a__Datenschutzbestimmungen__http___www_4wmarketplace_com_privacy_"><span/></a><span
                        class="T14">Datenschutzbestimmungen: </span><a href="http://www.4wmarketplace.com/privacy/"
                                                                       class="ListLabel_20_1"><span class="T3">http://www.4wmarketplace.com/privacy/</span></a>
                </h1>
                <p class="P5"></p>
                <h1 class="P1"><a id="a__Opt-out__http___www_youronlinechoices_com_it_le-tue-scelte"><span/></a><span
                        class="T1">Opt-out: </span><a href="http://www.youronlinechoices.com/it/le-tue-scelte"
                                                      class="ListLabel_20_2"><span class="T21">http://www.youronlinechoices.com/it/le-tue-scelte</span></a>
                </h1>
                <p class="Standard"><a href="https://www.neustar.biz/privacy/opt-out" class="ListLabel_20_2"><span
                        class="T21">https://www.neustar.biz/privacy/opt-out</span></a></p>
                <p class="P5"></p>
                <p class="P5"></p>
                <p class="Standard"><span class="T12">Active Agent </span></p>
                <p class="P5"></p>
                <p class="Standard"><span class="T14">Active Agent (</span><a href="http://www.active-agent.com/de/"
                                                                              class="ListLabel_20_3"><span
                        class="Internet_20_link"><span class="T3">http://www.active-agent.com/de/</span></span></a><span
                        class="T14">) </span><span class="T1">setzt Technologien ein, um</span><span
                        class="T14"> </span><span class="T1">Ihnen für Sie relevante Werbeanzeigen zu präsentieren. Anbieter von Active Agent ist die Active Agent AG, Ellen-Gottlieb-Straße 16, 79106 Freiburg i.Br., Deutschland. Active Agent ist eine Plattform für einfaches und transparentes Handling von Werbekampagnen im Real Time &amp; Data Driven Advertising Umfeld.</span>
                </p>
                <p class="P2"></p>
                <p class="Standard"><span class="T1">Datenschutzbestimmungen: </span><a
                        href="http://www.active-agent.com/de/unternehmen/datenschutzerklaerung/" class="ListLabel_20_4"><span
                        class="Internet_20_link"><span class="T1">http://www.active-agent.com/de/unternehmen/datenschutzerklaerung/</span></span></a>
                </p>
                <p class="P2"></p>
                <p class="Standard"><span class="T1">Opt-out: <a href="http://www.active-agent.com/de/unternehmen/opt-out/">http://www.active-agent.com/de/unternehmen/opt-out/</a></span>
                </p>
                <p class="P5"></p>
                <p class="P5"></p>
                <h1 class="P1"><a id="a__Amazon"><span/></a><span class="T12">Amazon</span></h1>
                <p class="P5"></p>
                <p class="Standard"><span class="T1">Amazon (https://aps.amazon.com/aps/index.html) setzt Technologien ein, um Ihnen für Sie relevante Werbeanzeigen zu präsentieren. Anbieter von Amazon publisher services ist Amazon publisher services mit Sitz in Washington – 410 Terry Ave. North, Seattle, WA 98109-5210. Wenn Sie nicht wollen, dass weiterhin anonymisierte Daten von Amazon publisher services gesammelt werden, klicken Sie bitte unten auf den Opt-out Link. Dieses OptOut-Cookie löscht die bisher gespeicherten Informationen und verhindert ein weiteres Erfassen von Informationen.</span>
                </p>
                <p class="P2"></p>
                <p class="Standard"><span class="T14">Datenschutzbestimmungen:</span><span class="T18"> </span><a
                        href="https://www.amazon.com/gp/help/customer/display.html/ref=hp_left_sib?ie=UTF8&amp;nodeId=468496"
                        class="ListLabel_20_5"><span class="Internet_20_link"><span class="T10">https://www.amazon.com/gp/help/customer/display.html/ref=hp_left_sib?ie=UTF8&amp;nodeId=468496</span></span></a>
                </p>
                <p class="P2"></p>
                <h1 class="P1"><a id="a__Opt-out__https___www_amazon_com_adprefs_ref=hp_468496_advertisingpref2"><span/></a><span
                        class="T14">Opt-out: </span><a
                        href="https://www.amazon.com/adprefs/ref=hp_468496_advertisingpref2"
                        class="ListLabel_20_1"><span class="T3">https://www.amazon.com/adprefs/ref=hp_468496_advertisingpref2</span></a>
                </h1>
                <p class="P2"></p>
                <p class="P2"></p>
                <h1 class="P1"><a id="a__Adform"><span/></a><span class="T2">Adform</span></h1>
                <p class="P2"/>
                <p class="Standard"><span class="T1">Adform (https://www.adform.com) setzt Technologien ein, um Ihnen für Sie relevante Werbeanzeigen zu präsentieren. Anbieter von Adform ist Adform mit Sitz in Wildersgade 10B, 1, 1408 Copenhagen, Dänemark. Wenn Sie nicht wollen, dass weiterhin anonymisierte Daten Adform gesammelt werden, klicken Sie bitte unten auf den Opt-out Link. Dieses OptOut-Cookie löscht die bisher gespeicherten Informationen und verhindert ein weiteres Erfassen von Informationen.</span>
                </p>
                <p class="P5"></p>
                <h1 class="P1"><a
                        id="a__Datenschutzbestimmungen__https___site_adform_com_privacy-policy-opt-out_"><span/></a><span
                        class="T14">Datenschutzbestimmungen:</span><span class="T18"> </span><a
                        href="https://site.adform.com/privacy-policy-opt-out/" class="ListLabel_20_5"><span
                        class="Internet_20_link"><span
                        class="T10">https://site.adform.com/privacy-policy-opt-out/</span></span></a></h1>
                <p class="P2"></p>
                <h1 class="P1"><a id="a__Opt-out__https___site_adform_com_privacy-policy-opt-out_"><span/></a><span
                        class="T14">Opt-out: </span><a href="https://site.adform.com/privacy-policy-opt-out/"
                                                       class="ListLabel_20_4"><span class="Internet_20_link"><span
                        class="T1">https://site.adform.com/privacy-policy-opt-out/</span></span></a></h1>
                <p class="P2"></p>
                <p class="P2"></p>
                <h1 class="P1"><a id="a__AppNexus"><span/></a><span class="T12">AppNexus</span></h1>
                <p class="P2"></p>
                <p class="Standard"><span class="T1">AppNexus (https://www.appnexus.com) setzt Technologien ein, um Ihnen für Sie relevante Werbeanzeigen zu präsentieren. Anbieter von AppNexus ist die AppNexus Group mit Sitz in New York – 28 W. 23rd  Street, New York, New York, 10010. Wenn Sie nicht wollen, dass weiterhin anonymisierte Daten von Appnexus gesammelt werden, klicken Sie bitte unten auf den Opt-out Link. Dieses OptOut-Cookie löscht die bisher gespeicherten Informationen und verhindert ein weiteres Erfassen von Informationen.</span>
                </p>
                <p class="P2"></p>
                <p class="Standard"><span class="T14">Datenschutzbestimmungen:</span><span class="T22"> </span><a
                        href="https://www.appnexus.com/en/company/privacy-policy" class="ListLabel_20_6"><span
                        class="Internet_20_link"><span
                        class="T4">https://www.appnexus.com/en/company/privacy-policy</span></span></a></p>
                <p class="P17"></p>
                <p class="Standard"><span class="T15">Opt-out: <a href="https://www.appnexus.com/en/company/platform-privacy-policy#choices">https://www.appnexus.com/en/company/platform-privacy-policy#choices</a></span>
                </p>
                <p class="P2"></p>
                <p class="P2"></p>
                <h1 class="P1"><a id="a__Conversant"><span/></a><span class="T12">Conversant</span></h1>
                <p class="P2"></p>
                <p class="Standard"><span class="T1">Conversant (https://www.conversantmedia.com) setzt Technologien ein, um Ihnen für Sie relevante Werbeanzeigen zu präsentieren. Anbieter von Conversant ist Conversant inc. mit Sitz in Chicago (IL) – 101 North Wacker, 23rd  Floor Chicago, IL 60606. Wenn Sie nicht wollen, dass weiterhin anonymisierte Daten von Conversant gesammelt werden, klicken Sie bitte unten auf den Opt-out Link. Dieses OptOut-Cookie löscht die bisher gespeicherten Informationen und verhindert ein weiteres Erfassen von Informationen.</span>
                </p>
                <p class="P2"></p>
                <h1 class="P1"><a id="a__Datenschutzbestimmungen__http___www_conversantmedia_com_legal_privacy"><span/></a><span
                        class="T14">Datenschutzbestimmungen: </span><a
                        href="http://www.conversantmedia.com/legal/privacy" class="ListLabel_20_7"><span class="T14">http://www.conversantmedia.com/legal/privacy</span></a>
                </h1>
                <p class="P2"/>
                <h1 class="P1"><a id="a__Opt-out__http___optout_conversantmedia_com_"><span/></a><span class="T14">Opt-out: </span><a
                        href="http://optout.conversantmedia.com/" class="ListLabel_20_3"><span class="Internet_20_link"><span
                        class="T3">http://optout.conversantmedia.com/</span></span></a></h1>
                <p class="P5"></p>
                <p class="P2"></p>
                <h1 class="P1"><a id="a__Criteo"><span/></a><span class="T12">Criteo</span></h1>
                <p class="P2"></p>
                <p class="Standard"><span class="T1">Criteo (https://www.criteo.com) setzt Technologien ein, um Ihnen für Sie relevante Werbeanzeigen zu präsentieren. Anbieter von Criteo ist Criteo mit Sitz in Paris – 32 Rue Blanche – 75009 Paris - France. Wenn Sie nicht wollen, dass weiterhin anonymisierte Daten von Criteo gesammelt werden, klicken Sie bitte unten auf den Opt-out Link. Dieses OptOut-Cookie löscht die bisher gespeicherten Informationen und verhindert ein weiteres Erfassen von Informationen.</span>
                </p>
                <p class="P5"></p>
                <h1 class="P1"><a id="a__Datenschutzbestimmungen__http___www_criteo_com_privacy_"><span/></a><span
                        class="T1">Datenschutzbestimmungen:</span><span class="T22"> </span><a
                        href="http://www.criteo.com/privacy/" class="ListLabel_20_8"><span
                        class="Internet_20_link"><span class="T5">http://www.criteo.com/privacy/</span></span></a></h1>
                <h1 class="P1"><a id="a__Opt-out__https___www_criteo_com_privacy_"><span/></a><span class="T15">Opt-out: <a href="https://www.criteo.com/privacy/">https://www.criteo.com/privacy/</a></span>
                </h1>
                <p class="P2"></p>
                <p class="P2"></p>
                <h1 class="P1"><a id="a__District_M"><span/></a><span class="T12">District M</span></h1>
                <p class="P2"></p>
                <p class="Standard"><span class="T1">District M (https://districtm.net) setzt Technologien ein, um Ihnen für Sie relevante Werbeanzeigen zu präsentieren. Anbieter von District M ist District M mit Sitz in Montreal – 5455 Gaspe Ave #730, Montreal, QC H2T 3B3, Canada. Wenn Sie nicht wollen, dass weiterhin anonymisierte Daten von District M gesammelt werden, klicken Sie bitte unten auf den Opt-out Link. Dieses Opt-Out-Cookie löscht die bisher gespeicherten Informationen und verhindert ein weiteres Erfassen von Informationen.</span>
                </p>
                <p class="P2"></p>
                <p class="Standard"><span class="T15">Datenschutzbestimmungen: </span><a
                        href="https://districtm.net/en/page/platforms-data-and-privacy-policy/"
                        class="ListLabel_20_9"><span class="T22">https://districtm.net/en/page/platforms-data-and-privacy-policy/</span></a>
                </p>
                <p class="P17"></p>
                <h1 class="P1"><a id="a__Opt-out__https___cdn_districtm_ca_optout_html"><span/></a><span class="T15">Opt-out:</span><span
                        class="T1"> </span><a href="https://cdn.districtm.ca/optout.html" class="ListLabel_20_10"><span
                        class="T15">https://cdn.districtm.ca/optout.html</span></a></h1>
                <p class="P14"></p>
                <p class="P14"></p>
                <h1 class="P1"><a id="a__Doublecklick"><span/></a><span class="T12">Doublecklick</span></h1>
                <p class="P14"></p>
                <p class="Standard"><span class="T1">Doubleclick (https://marketingplatform.google.com/about/enterprise/) setzt Technologien ein, um Ihnen für Sie relevante Werbeanzeigen zu präsentieren. Anbieter von Doubleclick ist Doubleclick ist Google Ireland Limited, Gordon House, Barrow St Dublin 4 Ireland. Wenn Sie nicht wollen, dass weiterhin anonymisierte Daten von Doubleclick gesammelt werden, klicken Sie bitte unten auf den Opt-out </span><span
                        class="T1">Link. Dieses OptOut-Cookie löscht die bisher gespeicherten Informationen und verhindert ein weiteres Erfassen von Informationen.</span>
                </p>
                <p class="P14"></p>
                <h1 class="P1"><a
                        id="a__Datenschutzbestimmungen___http___www_google_com_intl_en_policies_privacy_"><span/></a><span
                        class="T15">Datenschutzbestimmungen</span><span class="T22"> : </span><a
                        href="http://www.google.com/intl/en/policies/privacy/" class="ListLabel_20_6"><span
                        class="Internet_20_link"><span class="T4">http://www.google.com/intl/en/policies/privacy/</span></span></a>
                </h1>
                <p class="P17"></p>
                <h1 class="P1"><a id="a__Opt-out__https___adssettings_google_com_authenticated?hl=en"><span/></a><span
                        class="T15">Opt-out:</span><span class="T1"> </span><a
                        href="https://adssettings.google.com/authenticated?hl=en" class="ListLabel_20_10"><span
                        class="T15">https://adssettings.google.com/authenticated?hl=en</span></a></h1>
                <p class="P14"></p>
                <p class="P14"></p>
                <h1 class="P1"><a id="a__Facebook"><span/></a><span class="T12">Facebook</span></h1>
                <p class="P14"></p>
                <p class="Standard"><span class="T1">Facebook (www.facebook.com) setzt Technologien ein, um Ihnen für Sie relevante Werbeanzeigen zu präsentieren. Anbieter von Facebook ist Facebook Inc., located in 1601 S. California Ave, Palo Alto, CA 94304, USA. Wenn Sie nicht wollen, dass weiterhin anonymisierte Daten von Facebook gesammelt werden, klicken Sie bitte unten auf den Opt-out Link. Dieses OptOut-Cookie löscht die bisher gespeicherten Informationen und verhindert ein weiteres Erfassen von Informationen.</span>
                </p>
                <p class="P14"></p>
                <h1 class="P1"><a
                        id="a__Datenschutzbestimmungen___https___www_facebook_com_about_privacy_update"><span/></a><span
                        class="T15">Datenschutzbestimmungen</span><span class="T22"> : </span><span
                        class="Internet_20_link"><span
                        class="T3"><a href="https://www.facebook.com/about/privacy/update">https://www.facebook.com/about/privacy/update</a></span></span></h1>
                <p class="P17"></p>
                <h1 class="P1"><a id="a__Opt-out__www_facebook_com_ads_preferences"><span/></a><span class="T15">Opt-out:</span><span
                        class="T1"> </span><a href="http://www.facebook.com/ads/preferences"
                                              class="ListLabel_20_3"><span class="Internet_20_link"><span class="T3">www.facebook.com/ads/preferences</span></span></a>
                </h1>
                <p class="P14"></p>
                <p class="P14"></p>
                <h1 class="P1"><a id="a__Freewheel"><span/></a><span class="T12">Freewheel</span></h1>
                <p class="P14"></p>
                <p class="Standard"><span class="T1">Freewheel (http://freewheel.tv) setzt Technologien ein, um Ihnen für Sie relevante Werbeanzeigen zu präsentieren. Anbieter von Freewheel ist FreeWheel Media, Inc., mit Sitz in 301 Howard Street19th Floor San Francisco, California 94105, USA. Wenn Sie nicht wollen, dass weiterhin anonymisierte Daten von Freewheel gesammelt werden, schreiben Sie bitte eine E-Mail an die unten stehende E-Mail Adresse. </span>
                </p>
                <p class="P14"></p>
                <h1 class="P1"><a
                        id="a__Datenschutzbestimmungen__http___freewheel_tv_privacy-policy_?noredirect"><span/></a><span
                        class="T1">Datenschutzbestimmungen:</span><span class="T22"> </span><span
                        class="Internet_20_link"><span class="T3"><a href="http://freewheel.tv/privacy-policy/?noredirect">http://freewheel.tv/privacy-policy/?noredirect</a></span></span>
                </h1>
                <p class="P17"></p>
                <h1 class="P1"><a id="a__Opt-out__legalnotices@freewheel_tv_"><span/></a><span
                        class="T15">Opt-out:</span><span class="T1"> </span><span class="Internet_20_link"><span
                        class="T3">legalnotices@freewheel.tv.</span></span></h1>
                <p class="P14"></p>
                <p class="P14"></p>
                <p class="P14"></p>
                <h1 class="P1"><a id="a__Gumgum"><span/></a><span class="T12">Gumgum</span></h1>
                <p class="P14"></p>
                <p class="Standard"><span class="T1">Gumgum (https://gumgum.com) setzt Technologien ein, um Ihnen für Sie relevante Werbeanzeigen zu präsentieren. Anbieter von Gumgum ist Gumgum, Inc.Wenn Sie </span><span
                        class="T1">nicht wollen, dass weiterhin anonymisierte Daten von Gumgum gesammelt werden, schreiben Sie bitte eine E-Mail an die unten stehende E-Mail Adresse. </span>
                </p>
                <p class="P14"></p>
                <h1 class="P1"><a id="a__Datenschutzbestimmungen__https___gumgum_com_cookies-policy"><span/></a><span
                        class="T15">Datenschutzbestimmungen</span><span class="T22">: </span><span
                        class="Internet_20_link"><span class="T3"><a href="https://gumgum.com/cookies-policy">https://gumgum.com/cookies-policy</a></span></span></h1>
                <p class="P17"></p>
                <h1 class="P1"><a id="a__Opt-out__https___gumgum_com_opt-out"><span/></a><span
                        class="T15">Opt-out:</span><span class="T1"> </span><span class="Internet_20_link"><span
                        class="T3"><a href="https://gumgum.com/opt-out">https://gumgum.com/opt-out</a></span></span></h1>
                <p class="P14"></p>
                <p class="P14"></p>
                <p class="P14"></p>
                <p class="P14"></p>
                <h1 class="P1"><a id="a__Improve_Digital"><span/></a><span class="T12">Improve Digital</span></h1>
                <p class="P14"></p>
                <p class="Standard"><span class="T1">Improve Digital (www.indexexchange.com) setzt Technologien ein, um Ihnen für Sie relevante Werbeanzeigen zu präsentieren. Anbieter von Improve Digital ist die Improve Digital GmbH mit Sitz in Nußbaumstraße 10, 80336 München. Wenn Sie nicht wollen, dass weiterhin anonymisierte Daten von Improve Digital gesammelt werden, klicken Sie bitte unten auf den Opt-out Link. Dieses OptOut-Cookie löscht die bisher gespeicherten Informationen und verhindert ein weiteres Erfassen von Informationen.</span>
                </p>
                <p class="P14"></p>
                <h1 class="P1"><a
                        id="a__Datenschutzbestimmungen__https___www_improvedigital_com_platform-privacy-policy_"><span/></a><span
                        class="T15">Datenschutzbestimmungen</span><span class="T22">: <a href="https://www.improvedigital.com/platform-privacy-policy/">https://www.improvedigital.com/platform-privacy-policy/</a></span>
                </h1>
                <p class="P17"></p>
                <h1 class="P1"><a id="a__Opt-out__https___www_improvedigital_com_opt-out-page_"><span/></a><span
                        class="T15">Opt-out:</span><span class="T1"> </span><span class="T15"><a href="https://www.improvedigital.com/opt-out-page/">https://www.improvedigital.com/opt-out-page/</a></span>
                </h1>
                <p class="P14"></p>
                <p class="P14"></p>
                <p class="P14"></p>
                <p class="P16"></p>
                <h1 class="P1"><a id="a__Indexexchange"><span/></a><span class="T12">Indexexchange</span></h1>
                <p class="P14"></p>
                <p class="Standard"><span class="T1">Indexexchange (www.indexexchange.com) setzt Technologien ein, um Ihnen für Sie relevante Werbeanzeigen zu präsentieren. Anbieter von Indexexchange ist Indexexchange mit Sitz in New York – 20 W 22nd  St. Suite 1101, New York, NY 10010. Wenn Sie nicht wollen, dass weiterhin anonymisierte Daten von Indexexchange gesammelt werden, klicken Sie bitte unten auf den Opt-out Link. Dieses OptOut-Cookie löscht die bisher gespeicherten Informationen und verhindert ein weiteres Erfassen von Informationen.</span>
                </p>
                <p class="P14"></p>
                <h1 class="P1"><a
                        id="a__Datenschutzbestimmungen__http___www_indexexchange_com_privacy_"><span/></a><span
                        class="T15">Datenschutzbestimmungen</span><span class="T22">: </span><a
                        href="http://www.indexexchange.com/privacy/" class="ListLabel_20_9"><span class="T22">http://www.indexexchange.com/privacy/</span></a>
                </h1>
                <p class="P17"></p>
                <h1 class="P1"><a id="a__Opt-out__http___optout_networkadvertising_org_?c=1#!_"><span/></a><span
                        class="T15">Opt-out:</span><span class="T1"> </span><span class="T15"><a href="http://optout.networkadvertising.org/?c=1#!/">http://optout.networkadvertising.org/?c=1#!/</a></span>
                </h1>
                <p class="P17"/>
                <p class="P17"></p>
                <h1 class="P1"><a id="a__LKQD"><span/></a><span class="T12">LKQD</span></h1>
                <p class="P14"></p>
                <p class="Standard"><span class="T1">LKQD (https://www.lkqd.com) setzt Technologien ein, um Ihnen für Sie relevante Werbeanzeigen zu präsentieren. Anbieter von LKQD ist Nexstar Digital Digital LLC mit Sitz in 27422 Portola Parkway, Suite 100, Foothill Ranch, CA 92610, USA. Wenn Sie nicht wollen, dass weiterhin anonymisierte Daten von LKQD gesammelt werden, klicken Sie bitte unten auf den Opt-out Link. Dieses OptOut-Cookie löscht die bisher gespeicherten Informationen und verhindert ein weiteres Erfassen von Informationen.</span>
                </p>
                <p class="P14"></p>
                <h1 class="P1"><a id="a__Datenschutzbestimmungen__http___www_lkqd_com_privacy-policy_"><span/></a><span
                        class="T15">Datenschutzbestimmungen</span><span class="T22">: <a href="http://www.lkqd.com/privacy-policy/">http://www.lkqd.com/privacy-policy/</a></span>
                </h1>
                <p class="P17"></p>
                <p class="Standard"><span class="T15">Opt-out:</span><span class="T1"> </span><span class="T26"><a href="http://www.networkadvertising.org/choices/">http://www.networkadvertising.org/choices/</a></span>
                </p>
                <p class="P17"></p>
                <h1 class="P1"><a id="a__Loopme"><span/></a><span class="T12">Loopme</span></h1>
                <p class="P14"></p>
                <p class="Standard"><span class="T1">Loopme (https://loopme.com) setzt Technologien ein, um Ihnen für Sie relevante Werbeanzeigen zu präsentieren. Anbieter von Loopme ist LoopMe Ltd. mit Sitz in Ground Floor, 32-38 Saffron Hill, London EC1N 8FH, Großbrittanien. Wenn Sie nicht wollen, dass weiterhin anonymisierte Daten von Loopme gesammelt werden, klicken Sie bitte unten auf den Opt-out Link. Dieses OptOut-Cookie löscht die bisher gespeicherten Informationen und verhindert ein weiteres Erfassen von Informationen.</span>
                </p>
                <p class="P14"></p>
                <h1 class="P1"><a id="a__Datenschutzbestimmungen__https___loopme_com_privacy_"><span/></a><span
                        class="T15">Datenschutzbestimmungen</span><span class="T22">: <a href="https://loopme.com/privacy/">https://loopme.com/privacy/</a></span>
                </h1>
                <p class="P17"></p>
                <p class="Standard"><span class="T15">Opt-out:</span><span class="T1"> </span><span class="T26"><a href="https://gdpr.loopme.com/opt-out.html">https://gdpr.loopme.com/opt-out.html</a></span>
                </p>
                <p class="P17"></p>
                <p class="P17"></p>
                <h1 class="P1"><a id="a__Media_net"><span/></a><span class="T12">Media.net</span></h1>
                <p class="P14"></p>
                <p class="Standard"><span class="T1">Media.net (http://www.media.net/privacy-policy) setzt Technologien ein, um Ihnen für Sie relevante Werbeanzeigen zu präsentieren. Anbieter von Media.net ist Media.net Advertising Ltd. mit Sitz in Dubai – 107/108, DIC Building 5, Dubai Internet City, Dubai, 215028, United Arab Emirates. Wenn Sie nicht wollen, dass weiterhin anonymisierte Daten von Media.net gesammelt werden, klicken Sie bitte unten auf den Opt-out Link. Dieses OptOut-Cookie löscht die bisher gespeicherten Informationen und verhindert ein weiteres Erfassen von Informationen.</span>
                </p>
                <p class="P2"></p>
                <p class="P2"></p>
                <h1 class="P1"><a id="a__Datenschutzbestimmungen__http___www_media_net_privacy-policy"><span/></a><span
                        class="T15">Datenschutzbestimmungen</span><span class="T22">: </span><a
                        href="http://www.media.net/privacy-policy" class="ListLabel_20_11"><span class="T25">http://www.media.net/privacy-policy</span></a>
                </h1>
                <p class="P17"></p>
                <h1 class="P1"><a id="a__Opt-out__http___www_networkadvertising_org_choices_"><span/></a><span
                        class="T15">Opt-out:</span><span class="T1"> </span><a
                        href="http://www.networkadvertising.org/choices/" class="ListLabel_20_9"><span class="T22">http://www.networkadvertising.org/choices/</span></a>
                </h1>
                <h1 class="P1"><a id="a__MediaMath"><span/></a><span class="T13">MediaMath</span></h1>
                <p class="Standard"><span class="T1">Mediamath (</span><a href="http://www.mediamath.com"
                                                                          class="ListLabel_20_12"><span class="T1">http://www.mediamath.com</span></a><span
                        class="T1">) setzt Technologien ein, um Ihnen für Sie relevante Werbeanzeigen zu präsentieren.  Anbieter von MediaMath ist die MediaMath Inc., 4 World Trade Center, 150 Greenwich Street, 45th Floor, New York, NY 10007, United States. MediaMath setzt Technologien ein, um Ihnen für Sie relevante Werbeanzeigen auszuliefern.</span>
                </p>
                <p class="P2"></p>
                <p class="Standard"><span class="T15">Datenschutzbestimmungen:</span><span class="T27"> </span><a
                        href="http://www.mediamath.com/de/datenschutzrichtlinie/" class="ListLabel_20_13"><span
                        class="T23">http://www.mediamath.com/de/datenschutzrichtlinie/</span></a></p>
                <p class="P24"></p>
                <p class="Standard"><span class="T15">Opt-Out:</span><span class="T28"> </span><a
                        href="http://www.mediamath.com/de/ad-choices-opt-out/" class="ListLabel_20_13"><span
                        class="T23">http://www.mediamath.com/de/ad-choices-opt-out/</span></a></p>
                <p class="P24"></p>
                <h1 class="P1"><a id="a__Nano_Interactive"><span/></a><span class="T13">Nano Interactive</span></h1>
                <p class="P17"></p>
                <p class="Standard"><span class="T1">Nano Interactive (https://www.nanointeractive.com) setzt Technologien ein, um Ihnen für Sie relevante Werbeanzeigen zu präsentieren.  Anbieter von Nano Interactive ist die Nano Interactive GmbH Moosstr. 7, 82319 Starnberg. Nano Interactive setzt Technologien ein, um Ihnen für Sie relevante Werbeanzeigen auszuliefern.</span>
                </p>
                <p class="P2"></p>
                <p class="Standard"><span class="T15">Datenschutzbestimmungen:</span><span class="T27"> </span><span
                        class="T23"><a href="https://www.nanointeractive.com/privacy-policy/">https://www.nanointeractive.com/privacy-policy/</a></span><span class="T27"> </span></p>
                <p class="P24"></p>
                <p class="Standard"><span class="T15">Opt-Out:</span><span class="T28"> </span><span class="T23"><a href="https://audiencemanager.de/public/opt-out">https://audiencemanager.de/public/opt-out</a></span>
                </p>
                <p class="P17"></p>
                <p class="P17"></p>
                <h1 class="P1"><a id="a__Oath"><span/></a><span class="T12">Oath</span></h1>
                <p class="P2"></p>
                <p class="Standard"><span class="T1">Oath (https://www.oath.com/) setzt Technologien ein, um Ihnen für Sie relevante Werbeanzeigen zu präsentieren. Anbieter von Oath ist Oath (EMEA) Limited mit Sitz in Dublin - 5-7 Point Square, North Wall Quay. Wenn Sie nicht wollen, dass weiterhin anonymisierte Daten von Oath gesammelt werden, klicken Sie bitte unten auf den Opt-out Link. Dieses OptOut-Cookie löscht die bisher gespeicherten Informationen und verhindert ein weiteres Erfassen von Informationen.</span>
                </p>
                <p class="P5"></p>
                <h1 class="P1"><a id="a__Datenschutzbestimmungen__http___privacy_aol_com_"><span/></a><span class="T15">Datenschutzbestimmungen:</span><span
                        class="T1"> </span><a href="http://privacy.aol.com/" class="ListLabel_20_8"><span
                        class="Internet_20_link"><span class="T5">http://privacy.aol.com/</span></span></a></h1>
                <p class="P17"/>
                <h1 class="P1"><a id="a__Opt-out__https___aim_yahoo_com_aim_ie_en_optout_"><span/></a><span class="T15">Opt-out: </span><span
                        class="Internet_20_link"><span class="T32"><a href="https://aim.yahoo.com/aim/ie/en/optout">https://aim.yahoo.com/aim/ie/en/optout/</a></span></span>
                </h1>
                <p class="P17"></p>
                <p class="P17"></p>
                <h1 class="P1"><a id="a__OpenX"><span/></a><span class="T12">OpenX</span></h1>
                <p class="P23"></p>
                <p class="Standard"><span class="T1">OpenX (https://www.OpenX.com) setzt Technologien ein, um Ihnen für Sie relevante Werbeanzeigen zu präsentieren. Anbieter von OpenX ist OpenX mit Sitz in Pasadena – 888 E Walnut St, 2nd Floor, Pasadena CA, 91101, USA. Wenn Sie nicht wollen, dass weiterhin anonymisierte Daten von OpenX gesammelt werden, klicken Sie bitte unten auf den Opt-out Link. Dieses OptOut-Cookie löscht die bisher gespeicherten Informationen und verhindert ein weiteres Erfassen von Informationen.</span>
                </p>
                <p class="P14"></p>
                <h1 class="P1"><a
                        id="a__Datenschutzbestimmungen__https___www_openx_com_legal_privacy-policy_"><span/></a><span
                        class="T15">Datenschutzbestimmungen</span><span class="T22">:</span> <span class="T22"><a href="https://www.openx.com/legal/privacy-policy/">https://www.openx.com/legal/privacy-policy/</a></span>
                </h1>
                <p class="P17"></p>
                <h1 class="P1"><a
                        id="a__Opt-out__https___www_openx_com_legal_interest-based-advertising_"><span/></a><span
                        class="T15">Opt-out:</span><span class="T1"> </span><span class="T15"><a href="https://www.openx.com/legal/interest-based-advertising/">https://www.openx.com/legal/interest-based-advertising/</a></span>
                </h1>
                <p class="P11"></p>
                <p class="P11"></p>
                <h1 class="P1"><a id="a__Otto"><span/></a><span class="T13">Otto </span></h1>
                <p class="Standard"><span class="T27">Otto (</span><a href="https://www.otto.de/"
                                                                      class="ListLabel_20_12"><span class="T1">https://www.otto.de/</span></a><span
                        class="T1">)</span> <span class="T1">setzt Technologien ein, um Ihnen für Sie relevante Werbeanzeigen zu präsentieren. </span><span
                        class="T29">Anbieter von Otto ist die Otto (GmbH &amp; Co KG), Werner-Otto-Straße 1-7, 22179 Hamburg, Deutschland. Otto Group Media setzt Technologien ein, um die Einblendung von Werbemitteln für den User auszusteuern und zu optimieren.</span>
                </p>
                <p class="P11"></p>
                <h1 class="P1"><a id="a__Datenschutzbestimmungen__https___ottogroup_media_kontakt_datenschutz_"><span/></a><span
                        class="T15">Datenschutzbestimmungen</span><span class="T22">:</span> <span class="T22"><a href="https://ottogroup.media/kontakt/datenschutz/">https://ottogroup.media/kontakt/datenschutz/</a></span>
                </h1>
                <p class="P11"></p>
                <p class="Standard"><span class="T16">Opt-out: </span><span class="T22"><a href="https://ottogroup.media/kontakt/datenschutz/">https://ottogroup.media/kontakt/datenschutz/</a></span>
                </p>
                <p class="P12"></p>
                <p class="P12"></p>
                <h1 class="P1"><a id="a__Pubmatic"><span/></a><span class="T17">Pubmatic</span></h1>
                <p class="P11"></p>
                <p class="Standard"><span class="T1">Pubmatic (https://www.pubmatic.com) setzt Technologien ein, um Ihnen für Sie relevante Werbeanzeigen zu präsentieren. Anbieter von Pubmatic ist Pubmatic, Inc. mit Sitz in Redwood City – 305 Main Street, First Floor, Redwood City, California 94063, USA. Wenn Sie nicht wollen, dass weiterhin anonymisierte Daten von Pubmatic gesammelt werden, klicken Sie bitte unten auf den Opt-out Link. Dieses OptOut-Cookie löscht die bisher gespeicherten Informationen und verhindert ein weiteres Erfassen von Informationen.</span>
                </p>
                <p class="P11"></p>
                <h1 class="P1"><a
                        id="a__Datenschutzbestimmungen__https___pubmatic_com_legal_privacy-policy_"><span/></a><span
                        class="T15">Datenschutzbestimmungen</span><span class="T22">: </span><span
                        class="Internet_20_link"><span
                        class="T6"><a href="https://pubmatic.com/legal/privacy-policy/">https://pubmatic.com/legal/privacy-policy/</a></span></span></h1>
                <p class="P22"></p>
                <h1 class="P1"><a id="a__Opt-out__https___pubmatic_com_legal_opt-out_"><span/></a><span class="T15">Opt-out:</span><span
                        class="T1"> </span><a href="https://pubmatic.com/legal/opt-out/" class="ListLabel_20_14"><span
                        class="Internet_20_link"><span class="T7">https://pubmatic.com/legal/opt-out/</span></span></a>
                </h1>
                <p class="P11"></p>
                <p class="P11"></p>
                <h1 class="P1"><a id="a__Pulsepoint"><span/></a><span class="T17">Pulsepoint</span></h1>
                <p class="P11"></p>
                <p class="Standard"><span class="T1">Pulsepoint (https://www.pulsepoint.com) setzt Technologien ein, um Ihnen für Sie relevante Werbeanzeigen zu präsentieren. Anbieter von Pulsepoint ist Pulsepoint, Inc. mit Sitz in New York – 360 Madison Avenue, 14th Floor, New York, NY 10017. Wenn Sie nicht wollen, dass weiterhin anonymisierte Daten von Template gesammelt werden, klicken Sie bitte unten auf den Opt-out Link. Dieses OptOut-Cookie löscht die bisher gespeicherten Informationen und verhindert ein weiteres Erfassen von Informationen.</span>
                </p>
                <p class="P11"></p>
                <h1 class="P1"><a id="a__Datenschutzbestimmungen__https___www_pulsepoint_com_privacy-policy"><span/></a><span
                        class="T15">Datenschutzbestimmungen</span><span class="T22">: </span><a
                        href="https://www.pulsepoint.com/privacy-policy" class="ListLabel_20_15"><span class="T24">https://www.pulsepoint.com/privacy-policy</span></a>
                </h1>
                <p class="P22"></p>
                <h1 class="P1"><a id="a__Opt-out__http___optout_networkadvertising_org_?c=1#!_"><span/></a><span
                        class="T15">Opt-out:</span><span class="T1"> </span><a
                        href="http://optout.networkadvertising.org/?c=1#!/" class="ListLabel_20_14"><span
                        class="Internet_20_link"><span
                        class="T7">http://optout.networkadvertising.org/?c=1#!/</span></span></a></h1>
                <p class="P22"></p>
                <p class="P22"></p>
                <h1 class="P1"><a id="a__Reachnet"><span/></a><span class="T17">Reachnet</span></h1>
                <p class="P11"></p>
                <p class="Standard"><span class="T1">Reachnet (https://www.reachnet.de) setzt Technologien ein, um Ihnen für Sie relevante Werbeanzeigen zu präsentieren. Anbieter von Reachnet ist Reachnet DE Ltd. mit Sitz in Hamburg – Grindelallee 41, D-20146 Hamburg. Wenn Sie nicht wollen, dass weiterhin anonymisierte Daten von Reachnet gesammelt werden, klicken Sie bitte unten auf den Opt-out Link. Dieses OptOut-Cookie löscht die bisher gespeicherten Informationen und verhindert ein weiteres Erfassen von Informationen.</span>
                </p>
                <p class="P11"></p>
                <p class="Standard"><span class="T15">Datenschutzbestimmungen</span><span class="T22">: </span><span
                        class="Internet_20_link"><span
                        class="T6"><a href="https://www.reachnet.de/unternehmen/datenschutz.html">https://www.reachnet.de/unternehmen/datenschutz.html</a></span></span></p>
                <p class="P22"></p>
                <h1 class="P1"><a id="a__Opt-out__https___imagesrv_adition_com_1x1_gif"><span/></a><span class="T15">Opt-out:</span><span
                        class="T1"> </span><span class="Internet_20_link"><span class="T7"><a href="https://imagesrv.adition.com/1x1.gif">https://imagesrv.adition.com/1x1.gif</a></span></span>
                </h1>
                <p class="P22"></p>
                <p class="P11"></p>
                <h1 class="P1"><a id="a__Rubicon_Project"><span/></a><span class="T17">Rubicon Project</span></h1>
                <p class="P11"></p>
                <p class="Standard"><span class="T1">Rubicon Project (https://www.rubiconproject.com) setzt Technologien ein, um Ihnen für Sie relevante Werbeanzeigen zu präsentieren. Anbieter von Rubicon Project ist Rubicon Project, inc. mit Sitz in Playa Vista – 12181 Bluff Creek Drive, 4th Floor, Playa Vista, CA 90094, USA. Wenn Sie nicht wollen, dass weiterhin anonymisierte </span><span
                        class="T1">Daten von Rubicon Project gesammelt werden, klicken Sie bitte unten auf den Opt-out Link. Dieses OptOut-Cookie löscht die bisher gespeicherten Informationen und verhindert ein weiteres Erfassen von Informationen.</span>
                </p>
                <p class="P11"></p>
                <h1 class="P1"><a id="a__Datenschutzbestimmungen__http___www_rubiconproject_com_privacy-policy_"><span/></a><span
                        class="T15">Datenschutzbestimmungen</span><span class="T22">: </span><a
                        href="http://www.rubiconproject.com/privacy-policy/" class="ListLabel_20_6"><span
                        class="Internet_20_link"><span
                        class="T4">http://www.rubiconproject.com/privacy-policy/</span></span></a></h1>
                <p class="P17"></p>
                <p class="Standard"><span class="T15">Opt-out:</span><span class="T1"> </span><a
                        href="https://rubiconproject.com/privacy/consumer-online-profile-and-opt-out/"
                        class="ListLabel_20_8"><span class="Internet_20_link"><span class="T5">https://rubiconproject.com/privacy/consumer-online-profile-and-opt-out/</span></span></a>
                </p>
                <p class="P14"></p>
                <p class="P16"></p>
                <h1 class="P1"><a id="a__Primis"><span/></a><span class="T17">Primis</span></h1>
                <p class="P14"></p>
                <p class="Standard"><span class="T1">Primis (https://www.primis.tech) setzt Technologien ein, um Ihnen für Sie relevante Werbeanzeigen zu präsentieren. Anbieter von Primis ist Primis LTD mit Sitz in 622 Third avenue, McCann New York House</span>
                </p>
                <p class="Standard"><span class="T1">10017 New York City, USA. Wenn Sie nicht wollen, dass weiterhin anonymisierte Daten von Primis gesammelt werden, klicken Sie bitte unten auf den Opt-out Link. Dieses OptOut-Cookie löscht die bisher gespeicherten Informationen und verhindert ein weiteres Erfassen von Informationen.</span>
                </p>
                <p class="P2"></p>
                <p class="Standard"><span class="T15">Datenschutzbestimmungen</span><span class="T22">: </span><a
                        href="https://www.primis.tech/wp-content/uploads/2018/02/primisPrivacyPolicy2018.pdf"
                        class="ListLabel_20_6"><span class="Internet_20_link"><span class="T4">https://www.primis.tech/wp-content/uploads/2018/02/primisPrivacyPolicy2018.pdf</span></span></a>
                </p>
                <p class="P17"></p>
                <p class="Standard"><span class="T15">Opt-out: </span><a
                        href="https://web.archive.org/web/20180116234711/http:/live.sekindo.com/utils/cookieOptOut.php"
                        class="ListLabel_20_8"><span class="Internet_20_link"><span class="T5">https://web.archive.org/web/20180116234711/http:/live.sekindo.com/utils/cookieOptOut.php</span></span></a>
                </p>
                <p class="P2"></p>
                <p class="P2"></p>
                <h1 class="P1"><a id="a__Smaato"><span/></a><span class="T12">Smaato</span></h1>
                <p class="P2"></p>
                <p class="Standard"><span class="T1">Smaato (https://www.smaato.com) setzt Technologien ein, um Ihnen für Sie relevante Werbeanzeigen zu präsentieren. Anbieter von Smaato ist Smaato Ad Services mit Sitz in Hamburg – Valentinskamp 70, Emporio, 20355 Hamburg, Germany. Wenn Sie nicht wollen, dass weiterhin anonymisierte Daten von Smaato gesammelt werden, klicken Sie bitte unten auf den Opt-out Link. Dieses OptOut-Cookie löscht die bisher gespeicherten Informationen und verhindert ein weiteres Erfassen von Informationen.</span>
                </p>
                <p class="P2"></p>
                <h1 class="P1"><a id="a__Datenschutzbestimmungen__https___www_smaato_com_privacy_"><span/></a><span
                        class="T15">Datenschutzbestimmungen</span><span class="T22">: </span><a
                        href="https://www.smaato.com/privacy/" class="ListLabel_20_9"><span class="T22">https://www.smaato.com/privacy/</span></a>
                </h1>
                <p class="P17"></p>
                <h1 class="P1"><a id="a__Opt-out__http___www_youronlinechoices_eu"><span/></a><span
                        class="T15">Opt-out: </span><a href="https://www.youronlinechoices.eu/" class="ListLabel_20_16"><span
                        class="T33">http://www.youronlinechoices.eu</span></a></h1>
                <p class="P14"/>
                <p class="P14"></p>
                <h1 class="P1"><a id="a__SmartAdserver"><span/></a><span class="T12">SmartAdserver</span></h1>
                <p class="P2"></p>
                <p class="Standard"><span class="T14">SmartAdserver (https://www.smartadserver.com) setzt Technologien ein, um Ihnen für Sie relevante Werbeanzeigen zu präsentieren. Anbieter von SmartAdserver ist SmartAdserver mit Sitz in Paris – 66 Rue de la Chaussée d´Antin, 75009 Paris, France. Wenn Sie nicht wollen, dass weiterhin anonymisierte Daten von SmartAdserver gesammelt werden, klicken Sie bitte unten auf den Opt-out Link. Dieses OptOut-Cookie löscht die bisher gespeicherten Informationen und verhindert ein weiteres Erfassen von Informationen.</span>
                </p>
                <p class="P5"></p>
                <h1 class="P1"><a
                        id="a__Datenschutzbestimmungen__http___smartadserver_com_company_privacy-policy_"><span/></a><span
                        class="T15">Datenschutzbestimmungen</span><span class="T22">: </span><a
                        href="http://smartadserver.com/company/privacy-policy/" class="ListLabel_20_6"><span
                        class="Internet_20_link"><span
                        class="T4">http://smartadserver.com/company/privacy-policy/</span></span></a></h1>
                <p class="P19"></p>
                <h1 class="P1"><a
                        id="a__Opt-out__http___www_smartadserver_com_diffx_optout_IABOptout_aspx"><span/></a><span
                        class="T15">Opt-out: </span><span class="T22"><a href="http://www.smartadserver.com/diffx/optout/IABOptout.aspx">http://www.smartadserver.com/diffx/optout/IABOptout.aspx</a></span>
                </h1>
                <p class="P5"></p>
                <p class="P5"></p>
                <p class="P5"></p>
                <h1 class="P1"><a id="a__Smartclip"><span/></a><span class="T12">Smartclip</span></h1>
                <p class="P2"></p>
                <p class="Standard"><span class="T1">Smartclip (http://www.smartclip.com/) setzt Technologien ein, um Ihnen für Sie relevante Werbeanzeigen zu präsentieren. Anbieter von Smartclip ist die Smartclip Holding AG mit Sitz Kleiner Burstah 12, 20457 Hamburg, Deutschland. Wenn Sie nicht wollen, dass weiterhin anonymisierte Daten von Smartclip gesammelt werden, klicken Sie bitte unten auf den Opt-out Link. Dieses OptOut-Cookie löscht die bisher gespeicherten Informationen und verhindert ein weiteres Erfassen von Informationen.</span>
                </p>
                <p class="P2"></p>
                <h1 class="P1"><a id="a__Datenschutzbestimmungen__http___privacy-portal_smartclip_net_"><span/></a><span
                        class="T15">Datenschutzbestimmungen</span><span class="T22">: <a href="http://privacy-portal.smartclip.net/">http://privacy-portal.smartclip.net/</a></span>
                </h1>
                <p class="P17"></p>
                <a class="P1"><a id="a__Opt-out__https___privacy-portal_smartclip_net_de_opt-out"><span/></a><span
                        class="T15">Opt-out: </span><span
                        class="T33"><a href="https://privacy-portal.smartclip.net/de/opt-out">https://privacy-portal.smartclip.net/de/opt-out</span></a></h1>
                <p class="P5"></p>
                <p class="P5"></p>
                <h1 class="P1"><a id="a__Sovrn"><span/></a><span class="T12">Sovrn</span></h1>
                <p class="P5"></p>
                <p class="Standard"><span class="T1">Sovrn (https://www.sovrn.com) setzt Technologien ein, um Ihnen für Sie relevante Werbeanzeigen zu präsentieren. Anbieter von Sovrn ist Sovrn Holdings, Inc. mit Sitz in Boulder – 5541 Central Avenue, Boulder, CO 80301. Wenn Sie nicht wollen, dass weiterhin anonymisierte Daten von Sovrn gesammelt werden, klicken Sie bitte unten </span><span
                        class="T1">auf den Opt-out Link. Dieses OptOut-Cookie löscht die bisher gespeicherten Informationen und verhindert ein weiteres Erfassen von Informationen.</span>
                </p>
                <p class="P5"></p>
                <h1 class="P1"><a
                        id="a__Datenschutzbestimmungen__https___www_sovrn_com_privacy-policy-eu_"><span/></a><span
                        class="T15">Datenschutzbestimmungen</span><span class="T22">: </span><a
                        href="https://www.sovrn.com/privacy-policy-eu/" class="ListLabel_20_9"><span class="T22">https://www.sovrn.com/privacy-policy-eu/</span></a>
                </h1>
                <p class="P19"></p>
                <h1 class="P1"><a
                        id="a__Opt-out__https___info_evidon_com_pub_info_15620?v=1_nt=0_nw=false"><span/></a><span
                        class="T15">Opt-out: </span><span class="T22"><a href="https://info.evidon.com/pub_info/15620?v=1&nt=0&nw=false">https://info.evidon.com/pub_info/15620?v=1&amp;nt=0&amp;nw=false</a></span>
                </h1>
                <p class="P5"></p>
                <p class="P7"></p>
                <p class="Standard"><span class="T12">Spotxchange</span></p>
                <p class="P5"></p>
                <p class="Standard"><span class="T1">Spotxchange (https://</span> <span class="T1">www.spotx.tv) setzt Technologien ein, um Ihnen für Sie relevante Werbeanzeigen zu präsentieren. Anbieter von Spotxchange ist </span><span
                        class="T34">SpotX</span></p>
                <p class="Standard"><span class="T1">Mit Sitz in 8181 Arista Place Broomfield, CO 80021, USA. Wenn Sie nicht wollen, dass weiterhin anonymisierte Daten von Spotxchange gesammelt werden, klicken Sie bitte unten auf den Opt-out Link. Dieses OptOut-Cookie löscht die bisher gespeicherten Informationen und verhindert ein weiteres Erfassen von Informationen.</span>
                </p>
                <p class="P5"></p>
                <h1 class="P1"><a id="a__Datenschutzbestimmungen__https___www_spotx_tv_privacy-policy_"><span/></a><span
                        class="T15">Datenschutzbestimmungen</span><span class="T22">: <a href="https://www.spotx.tv/privacy-policy/">https://www.spotx.tv/privacy-policy/</a></span>
                </h1>
                <p class="P19"></p>
                <p class="Standard"><span class="T15">Opt-out: </span><span class="T14"><a href="https://www.spotx.tv/privacy-policy/gdpr/">https://www.spotx.tv/privacy-policy/gdpr/</a></span>
                </p>
                <p class="P5"></p>
                <p class="P5"></p>
                <h1 class="P1"><a id="a__Ströer_SSP"><span/></a><span class="T8">Ströer SSP</span></h1>
                <p class="P4"></p>
                <p class="Standard"><span class="T1">Ströer SSP (https://www.adscale.de) setzt Technologien ein, um Ihnen für Sie relevante Werbeanzeigen zu präsentieren. Anbieter von Ströer SSP ist die Ströer media Deutschland GmbH mit Sitz in Köln – 50999 Köln, Ströer-Allee 1. Wenn Sie nicht wollen, dass weiterhin anonymisierte Daten von Adscale gesammelt werden, klicken Sie bitte unten auf den Opt-out Link. Dieses OptOut-Cookie löscht die bisher gespeicherten Informationen und verhindert ein weiteres Erfassen von Informationen.</span>
                </p>
                <p class="P2"></p>
                <h1 class="P1"><a id="a__Datenschutzbestimmungen__http___www_adscale_de_datenschutz"><span/></a><span
                        class="T14">Datenschutzbestimmungen: </span><a href="http://www.adscale.de/datenschutz"
                                                                       class="ListLabel_20_9"><span class="T22">http://www.adscale.de/datenschutz</span></a>
                </h1>
                <p class="P17"></p>
                <h1 class="P1"><a id="a__Opt-out__ih_adscale_de_adscale-ih_oo"><span/></a><span
                        class="T14">Opt-out: </span><span class="T15">ih.adscale.de/adscale-ih/oo</span></h1>
                <p class="P5"></p>
                <p class="P5"></p>
                <p class="Standard"><span class="T9">The Tradedesk</span><span class="Strong"><span class="T30"> </span></span>
                </p>
                <p class="P2"></p>
                <p class="P27"><span class="T29">Thetradedesk (</span><a href="https://www.thetradedesk.com/"
                                                                         class="ListLabel_20_17"><span class="T31">https://www.thetradedesk.com/</span></a><span
                        class="T1">)</span><span class="T29"> </span><span class="T1">setzt Technologien ein, um Ihnen für Sie relevante Werbeanzeigen zu präsentieren.</span><span
                        class="T29"> Anbieter von The Tradedesk ist The Trade Desk, Inc, Große Theaterstraße 31, 1st Floor, 20354 Hamburg, Deutschland. </span><span
                        class="T29">The Tradedesk ist eine Plattform für einfaches und transparentes Handling von Werbekampagnen im Real Time &amp; Data Driven Advertising Umfeld.</span>
                </p>
                <p class="Standard"><span class="T14">Datenschutzbestimmungen: <a href="https://www.thetradedesk.com/general/privacy">https://www.thetradedesk.com/general/privacy</a></span>
                </p>
                <p class="P5"></p>
                <p class="Standard"><span class="T14">Opt-out: </span><a href="https://www.adsrvr.org/"
                                                                         class="ListLabel_20_7"><span class="T14">https://www.adsrvr.org/</span></a>
                </p>
                <p class="P5"></p>
                <p class="P5"></p>
                <h1 class="P1"><a id="a__Twiago"><span/></a><span class="T12">Twiago</span></h1>
                <p class="P5"></p>
                <p class="Standard"><span class="T1">Twiago (https://www.twiago.com) setzt Technologien ein, um Ihnen für Sie relevante Werbeanzeigen zu präsentieren. Anbieter von Twiago ist Twiago mit Sitz in Köln – Gustav-Heinemann-Ufer 72b, 50968 Köln. Wenn Sie nicht wollen, dass weiterhin anonymisierte Daten von Twiago gesammelt werden, klicken Sie bitte unten auf den Opt-out Link. Dieses OptOut-Cookie löscht die bisher gespeicherten Informationen und verhindert ein weiteres Erfassen von Informationen.</span>
                </p>
                <p class="P5"></p>
                <h1 class="P1"><a id="a__Datenschutzbestimmungen__http___www_twiago_com_datenschutz_"><span/></a><span
                        class="T15">Datenschutzbestimmungen</span><span class="T22">: </span><a
                        href="http://www.twiago.com/datenschutz/" class="ListLabel_20_6"><span class="Internet_20_link"><span
                        class="T4">http://www.twiago.com/datenschutz/</span></span></a></h1>
                <p class="P19"></p>
                <h1 class="P1"><a id="a__Opt-out__http___control_twiago_com_privacy_php?lang=0"><span/></a><span
                        class="T15">Opt-out: </span><a href="http://control.twiago.com/privacy.php?lang=0"
                                                       class="ListLabel_20_8"><span class="Internet_20_link"><span
                        class="T5">http://control.twiago.com/privacy.php?lang=0</span></span></a></h1>
                <p class="P19"></p>
                <p class="P5"></p>
                <h1 class="P1"><a id="a__Mopub"><span/></a><span class="T12">Mopub</span></h1>
                <p class="P5"></p>
                <p class="Standard"><span class="T1">Mopub (https://www.mopub.com) setzt Technologien ein, um Ihnen für Sie relevante Werbeanzeigen zu präsentieren. Anbieter von Mopub ist Twitter, Inc. mit Sitz in San Francisco – 1355 Market Street, Suite 900, San Francisco, Ca 94103. Wenn Sie nicht wollen, dass weiterhin anonymisierte Daten von Moppub gesammelt werden, klicken Sie bitte unten auf den Opt-out Link. Dieses OptOut-Cookie löscht die bisher gespeicherten Informationen und verhindert ein weiteres Erfassen von Informationen.</span>
                </p>
                <p class="P5"></p>
                <h1 class="P1"><a id="a__Datenschutzbestimmungen__https___www_mopub_com_legal_privacy_"><span/></a><span
                        class="T15">Datenschutzbestimmungen</span><span class="T22">: </span><a
                        href="https://www.mopub.com/legal/privacy/" class="ListLabel_20_6"><span
                        class="Internet_20_link"><span class="T4">https://www.mopub.com/legal/privacy/</span></span></a>
                </h1>
                <p class="P13"></p>
                <h1 class="P1"><a id="a__Opt-out__https___www_mopub_com_legal_privacy_"><span/></a><span class="T15">Opt-out: </span><a
                        href="https://www.mopub.com/legal/privacy/" class="ListLabel_20_8"><span
                        class="Internet_20_link"><span class="T5">https://www.mopub.com/legal/privacy/</span></span></a>
                </h1>
                <p class="P5"></p>
                <p class="P9"></p>
                <h1 class="P1"><a id="a__Inmobi"><span/></a><span class="T12">Inmobi</span></h1>
                <p class="P5"></p>
                <p class="Standard"><span class="T1">Inmobi (https://www.inmobi.com) setzt Technologien ein, um Ihnen für Sie relevante Werbeanzeigen zu präsentieren. Anbieter von Inmobi ist Inmobi Pte Ltd mit Sitz in Bangalore – Embassy Tech Square, Kadubeesanahalli Village Outer Ring Roard, </span><span
                        class="T1">Varthur Hobli, Bangalore 560103. Wenn Sie nicht wollen, dass weiterhin anonymisierte Daten von Inmobi gesammelt werden, klicken Sie bitte unten auf den Opt-out Link. Dieses OptOut-Cookie löscht die bisher gespeicherten Informationen und verhindert ein weiteres Erfassen von Informationen.</span>
                </p>
                <p class="P25"></p>
                <h1 class="P1"><a
                        id="a__Datenschutzbestimmungen__https___www_inmobi_com_privacy-policy"><span/></a><span
                        class="T15">Datenschutzbestimmungen</span><span class="T23">: </span><a
                        href="https://www.inmobi.com/privacy-policy" class="ListLabel_20_4"><span
                        class="Internet_20_link"><span
                        class="T1">https://www.inmobi.com/privacy-policy</span></span></a></h1>
                <p class="P14"></p>
                <h1 class="P1"><a id="a__Opt-out__https___www_inmobi_com_page_opt-out_"><span/></a><span class="T15">Opt-out: </span><a
                        href="https://www.inmobi.com/page/opt-out/" class="ListLabel_20_18"><span
                        class="Internet_20_link"><span
                        class="T11">https://www.inmobi.com/page/opt-out/</span></span></a></h1>
                <p class="P2"></p>
                <p class="P2"></p>
                <h1 class="P1"><a id="a__SONSTIGE___UNVORHERSEHBARE_COOKIES"><span/></a><span class="T1">SONSTIGE / UNVORHERSEHBARE COOKIES</span>
                </h1>
                <p class="P2"></p>
                <p class="Standard"><span class="T1">Aufgrund der Funktionsweise von Internet und Websites ist es möglich, dass Yieldlove nicht immer auf die Cookies achtet, die durch seine Banner von Drittanbietern platziert werden. Dies ist insbesondere dann der Fall, wenn seine Banner eingebettete Elemente wie Texte, Dokumente, Bilder oder Filmclips enthalten, die von einer anderen Partei gespeichert, aber auf oder in seinen Banner angezeigt werden.</span>
                </p>
                <p class="P2"></p>
                <p class="Standard"><span class="T1">Sollten Sie auf dieser Website Cookies finden, die in diese Kategorie fallen, die Yieldlove oben nicht erwähnt hat, teilen Sie uns dies bitte umgehend mit oder kontaktieren Sie direkt diesen Drittanbieter und fragen Sie, welche Cookies platziert wurden, was der Grund dafür war, wie lange der Cookie bestehen bleibt und auf welche Weise Ihre Privatsphäre geschützt wird.</span>
                </p>
                <p class="P2"></p>
                <p class="P2"></p>
                <p class="P2"></p>
                <h1 class="P1"><a id="a__IHRE_RECHTE_IN_BEZUG_AUF_IHRE_DATEN"><span/></a><span class="T1">IHRE RECHTE IN BEZUG AUF IHRE DATEN</span>
                </h1>
                <p class="P2"></p>
                <p class="Standard"><span class="T1">Yieldlove betrachtet die Daten der Werbebanner nicht als personenbezogene Daten gemäß geltendem Recht. Ebenso sammelt oder verarbeitet Yieldlove keine sensiblen persönlichen Daten wie Daten über Rasse oder ethnische Herkunft, politische Meinungen, religiöse oder philosophische Überzeugungen, Gewerkschaftsmitgliedschaft, Gesundheit oder Sexualleben. Darüber hinaus sammelt Yieldlove wissentlich auch keine Daten von Kindern unter 12 Jahren.</span>
                </p>
                <p class="P2"></p>
                <p class="Standard"><span class="T1">Yieldlove nimmt an den Selbstregulierungs-Programmen der European Digital Advertising Alliance (EDAA) teil und hält sich an die EDAA-Prinzipien für Online Behavioral Advertising. Die EDAA fungiert hauptsächlich als zentrale Lizenzierungsstelle für das OBA-Symbol und bietet den Verbrauchern technische Möglichkeiten, Transparenz und Kontrolle über OBA über die Online-Plattform für </span><span
                        class="T1">Verbraucherwahl von youronlinechoices.eu auszuüben. Die EDAA wird von Organisationen auf EU-Ebene geregelt, die die Wertschöpfungskette der OBA in Europa bilden und die europäische Konsistenz in der Vorgehensweise sicherstellen. Klicken Sie </span><a
                        href="http://www.edaa.eu/" class="ListLabel_20_4"><span class="Internet_20_link"><span
                        class="T1">hier</span></span></a><span class="T1">, um mehr über die EDAA zu erfahren.</span>
                </p>
                <p class="P2"></p>
                <p class="P2"></p>
                <p class="P2"></p>
                <h1 class="P1"><a id="a__ANPASSUNGEN_UND_KONTAKT"><span/></a><span
                        class="T1">ANPASSUNGEN UND KONTAKT</span></h1>
                <p class="P2"></p>
                <p class="Standard"><span class="T1">Gelegentlich muss Yieldlove Passagen dieser Datenschutzbestimmungen anpassen. Zum Beispiel, wenn Yieldlove seine Webseite ändert oder wenn sich die Gesetze für Cookies oder Datenschutz ändern. Yieldlove und seine Partner können den Inhalt der Aussagen und der Cookies, die ohne vorherige Warnung angegeben werden, jederzeit ändern. </span>
                </p>
                <p class="P2"></p>
                <p class="Standard"><span class="T1">Wenn Sie Fragen und / oder Kommentare haben oder eine Beschwerde einreichen möchten, kontaktieren Sie bitte den Datenschutzbeauftragten von Yieldlove per E-Mail unter </span><a
                        href="mailto:datenschutzbeauftragter@stroeer.de" class="ListLabel_20_4"><span
                        class="Internet_20_link"><span class="T1">datenschutzbeauftragter@stroeer.de</span></span></a>
                </p>
                <p class="P2"></p>

                <!-- /yieldlove -->
                
            </g:if>
            <g:else>
        
                (Nothing here yet)
        
            </g:else>

    </body>
</html>
