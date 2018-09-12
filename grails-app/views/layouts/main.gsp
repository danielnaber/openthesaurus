<!doctype html>
<html lang="${message(code:'html.lang')}">
    <head>
        <title><g:layoutTitle default="OpenThesaurus" /></title>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/fonts/fontawesome-webfont.woff2">
        <link type="text/css" rel="stylesheet" href="${createLinkTo(dir:'css',file:'layout.css')}?v20180423" />
        <link rel="shortcut icon" href="${createLinkTo(dir:'images',file:message(code:'favicon.name'))}" />
        <link rel="search" type="application/opensearchdescription+xml" title="OpenThesaurus" href="${createLinkTo(dir:'openSearch')}" />
        <meta name="flattr:id" content="62lgqk">
        <script type="text/javascript" src="${createLinkTo(dir:'js',file:'jquery-2.1.1.min.js')}"></script>
        <script type="text/javascript" src="${createLinkTo(dir:'js',file:'cookie-script.js')}"></script>
        <g:render template="/script"/>
        <g:render template="/layouts/scripts"/>
        <g:layoutHead />
    </head>
    <body>

    <g:render template="/navigation"/>

    <div id="body">

      <div id="content">

        <g:render template="/searchform" model="${[homepage: false]}"/>

        <g:if test="${session.user}">
          <noscript>
              <div class="nojs">
                 <g:message code='no.javascript.warning'/>
              </div>
          </noscript>
        </g:if>

        <g:layoutBody />

        <div id="searchResultArea" class="searchResultPopup" style="display: none"></div>

      </div>

    </div>

    <g:render template="/footer" model="${[homepage:false]}"/>

    <g:render template="/analytics"/>

    </body>
</html>