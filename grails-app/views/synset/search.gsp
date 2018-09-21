<%@page import="com.vionto.vithesaurus.*" %>
<g:set var="cleanTerm" value="${params.q.trim()}" />
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
                <div class="main-content-section partial-matches">
                    <g:render template="partialmatches"/>
                </div>
                <div class="main-content-section">
                    <div class="main-content-section-heading">
                        <g:message code="result.matches.no.like"/>
                    </div>
                    <div class="main-content-section-block nowrap">
                        <g:link controller="synset" action="create" params="${[term: params.q]}">
                            <button type="button" class="button button-icon button-addsynonym">
                                <i class="fa fa-plus-circle"></i>
                            </button>
                        </g:link>
                        <span>
                            <g:link controller="synset" action="create" params="${[term: params.q]}"><g:message code="result.create.another.synset" args="${[params.q]}"/></g:link>
                        </span>
                    </div>
                </div>
            </div>
            <div class="main-content-col">
                <g:render template="ad"/>
                <div class="main-content-section wiktionary">
                    <g:render template="wiktionary"/>
                </div>
                <div class="main-content-section">
                    <g:render template="wikipedia"/>
                </div>
                <div class="main-content-section">
                    <div class="main-content-section-heading">
                        <g:message code="result.external.search" args="${[params.q]}"/>
                    </div>
                    <g:set var="utf8Query" value="${java.net.URLEncoder.encode(params.q, 'utf8')}"/>
                    <g:set var="latin1Query" value="${java.net.URLEncoder.encode(params.q, 'latin1')}"/>
                    <div class="main-content-section-block wordtags wordtags-big">
                        <span class="word word-dot"><a href="https://www.korrekturen.de/flexion/suche.php?q=${utf8Query}">Wortformen von korrekturen.de</a></span>
                        &nbsp;&middot;&nbsp;
                        <span class="word word-dot"><a href="http://dict.tu-chemnitz.de/dings.cgi?lang=de&amp;noframes=1&amp;service=&amp;query=${latin1Query}&amp;optword=1&amp;optcase=1&amp;opterrors=0&amp;optpro=0&amp;style=&amp;dlink=self">Beolingus Deutsch-Englisch</a></span>
                    </div>
                </div>
            </div>
        </section>
    </div>

</main>

</body>
</html>
