<!doctype html>
<html lang="${message(code:'html.lang')}">
    <head>
        <title><g:layoutTitle default="OpenThesaurus" /></title>
        <asset:stylesheet src="application"/>
        <link rel="shortcut icon" href="${createLinkTo(dir:'images',file:message(code:'favicon.name'))}" />
        <link rel="search" type="application/opensearchdescription+xml" title="OpenThesaurus" href="/openSearch" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <asset:javascript src="application"/>
        <g:render template="/script"/>
        <g:render template="/layouts/scripts"/>
        <g:layoutHead />
        <script defer add-file-types="oxt,bz2" data-domain="openthesaurus.de" src="https://plausible.io/js/script.file-downloads.outbound-links.tagged-events.js"></script>
        <script>window.plausible = window.plausible || function() { (window.plausible.q = window.plausible.q || []).push(arguments) }</script>
    </head>
    <body>

    <g:render template="/navigation"/>

    <div id="body">

      <div id="content">

        <g:render template="/searchform" model="${[homepage: false]}"/>

        <g:render template="/loggedin"/>

        <hr style="margin-bottom:16px" class="desktopOnly"/>

        <main>
          <div id="searchSpace">
            <g:layoutBody />
          </div>
        </main>

      </div>

    </div>

    <g:render template="/footer" model="${[homepage:false]}"/>

    </body>
</html>