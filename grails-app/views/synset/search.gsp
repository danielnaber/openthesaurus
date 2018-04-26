<%@page import="com.vionto.vithesaurus.*" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
   		<meta name="layout" content="main" />
        <title><g:message code='result.matches.for.title' args="${[params.q]}"/></title>
        <script async='async' src='https://www.googletagservices.com/tag/js/gpt.js'></script>
        <script>
            var googletag = googletag || {};
            googletag.cmd = googletag.cmd || [];
        </script>
        <g:if test="${descriptionText}">
          <meta name="description" content="${message(code:'result.matches.for.description', args:[descriptionText.encodeAsHTML()])}"/>
        </g:if>

    </head>
    <body>

    <main class="main">

        <div class="container">
            <section class="main-content matches-page">
                <div class="main-content-col">
                    <div class="main-content-section">

                        <g:render template="mainmatches"/>
                        
                    </div>
                    <div class="main-content-section">
                        <div class="main-content-section-heading">
                            Teilwort-Treffer und ähnliche Wörter
                        </div>
                        <div class="main-content-section-block wordtags">
                            <span class="word word-dot"><a href="#">Klassenarbeit</a></span>
                            <span class="word word-dot"><a href="#">Klausur</a></span>
                            <span class="word word-dot"><a href="#">Leistungsüberprüfung (Amtsdeutsch)</a></span>
                            <span class="word word-dot"><a href="#">Lernerfolgskontrolle (Amtsdeutsch)</a></span>
                            <span class="word word-dot"><a href="#">Prüfung</a></span>
                            <span class="word word-dot"><a href="#">Schularbeit</a> (österr.)</span>
                            <span class="word word-dot"><a href="#">Schulaufgabe</a> (bair.)</span>
                            <span class="word word-dot"><a href="#">Test</a></span>
                            <span class="word word-dot"><a href="#">Arbeit</a> (ugs.)</span>
                        </div>
                    </div>
                    <div class="main-content-section">
                        <div class="main-content-section-heading">
                            Nicht das Richtige dabei?
                        </div>
                        <div class="main-content-section-block nowrap">
                            <button type="button" class="button button-icon button-addsynonym">
                                <i class="fa fa-plus-circle"></i>
                            </button>
                            <span>Eine weitere Bedeutung von 'test' zu OpenThesaurus hinzufügen</span>
                        </div>
                    </div>
                </div>
                <div class="main-content-col">
                    <div class="main-content-section matches-banner">
                        <div class="page-matches-banner">
                            banner here
                        </div>
                    </div>
                    <div class="main-content-section">
                        <div class="main-content-section-heading">
                            Wiktionary
                        </div>
                        <div class="main-content-section-block">
                            <div class="main-content-section-block-heading">
                                Bedeutungen:
                            </div>
                            1. Prüfung einer Eigenschaft oder Fähigkeit (in schriftlicher, mündlicher oder sonstiger Form)
                        </div>
                        <div class="main-content-section-block">
                            <div class="main-content-section-block-heading">
                                Synonyme:
                            </div>
                            1. Erprobung, Feldversuch, Prüfung, Versuch
                        </div>
                        <div class="main-content-section-note">
                            <div class="main-content-section-note-item">
                                Quelle: Wiktionary-Seite zu 'Test' [Autoren]
                            </div>
                            <div class="main-content-section-note-item">
                                Lizenz: Creative Commons Attribution-ShareAlike
                            </div>
                        </div>
                    </div>
                    <div class="main-content-section">
                        <div class="main-content-section-heading">
                            Wikipedia-Links
                        </div>
                        <div class="main-content-section-block wordtags wordtags-big">
                            <span class="word word-dot"><a href="#">Test (Begriffsklärung)</a></span>
                            <span class="word word-dot"><a href="#">Experiment</a></span>
                            <span class="word word-dot"><a href="#">Prüfen</a></span>
                            <span class="word word-dot"><a href="#">Beweis (Logik)</a></span>
                            <span class="word word-dot"><a href="#">Qualität</a></span>
                            <span class="word word-dot"><a href="#">Simulation</a></span>
                            <span class="word word-dot"><a href="#">Primzahltest</a></span>
                            <span class="word word-dot"><a href="#">Statistischer Test</a></span>
                            <span class="word word-dot"><a href="#">Schwangerschaftstest</a></span>
                            <span class="word word-dot"><a href="#">Medizin</a></span>
                            <span class="word word-dot"><a href="#">Blutbild</a></span>
                            <span class="word word-dot"><a href="#">Motodiagnostik</a></span>
                            <span class="word word-dot"><a href="#">Psychologischer Test</a></span>
                            <span class="word word-dot"><a href="#">Psychologie</a></span>
                            <span class="word word-dot"><a href="#">Online-Assessment</a></span>
                        </div>
                        <div class="main-content-section-note">
                            <div class="main-content-section-note-item">
                                Quelle: Wiktionary-Seite zu 'Test' [Autoren]
                            </div>
                            <div class="main-content-section-note-item">
                                Lizenz: Creative Commons Attribution-ShareAlike
                            </div>
                        </div>
                    </div>
                    <div class="main-content-section">
                        <div class="main-content-section-heading">
                            „test“ suchen mit:
                        </div>
                        <div class="main-content-section-block wordtags wordtags-big">
                            <span class="word word-dot"><a href="#">Wortformen von korrekturen.de</a></span>
                            <span class="word word-dot"><a href="#">Beolingus Deutsch-Englisch</a></span>
                        </div>
                    </div>
                </div>
            </section>
        </div>

    </main>

    </body>
</html>
