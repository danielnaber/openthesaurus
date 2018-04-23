<!doctype html>
<html lang="${message(code:'html.lang')}">
<head>
  <title><g:layoutTitle default="OpenThesaurus" /></title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link href="https://fonts.googleapis.com/css?family=Montserrat:300,400,500,600" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/fonts/fontawesome-webfont.woff2">
  <meta name='keywords' content='${message(code:"homepage.meta.keywords")}' />
  <meta name='description' content='${message(code:"homepage.meta.description")}' />
  <link type="text/css" rel="stylesheet" href="${createLinkTo(dir:'css',file:'layout.css')}?v20180423" />
  <link rel="shortcut icon" href="${createLinkTo(dir:'images',file:message(code:'favicon.name'))}" />
  <link rel="search" type="application/opensearchdescription+xml" title="${message(code:'opensearch.link.title')}" href="${createLinkTo(dir:'openSearch')}" />
  <link rel="alternate" type="application/rss+xml" title="<g:message code='rss.title'/>" href="${createLinkTo(dir:'feed')}" />
  <meta name="flattr:id" content="62lgqk">
  <script type="text/javascript" src="${createLinkTo(dir:'js',file:'jquery-2.1.1.min.js')}"></script>
  <g:render template="/script"/>
  <g:layoutHead />
  <g:render template="/layouts/scripts"/>
</head>
<body>

    <g:render template="/navigation"/>

    <div id="body">
    
        <div id="content">
    
            <g:render template="/searchform" model="${[homepage: true]}"/>
    
            <g:if test="${session.user}">
                <noscript>
                    <div class="nojs">
                        <g:message code='no.javascript.warning'/>
                    </div>
                </noscript>
            </g:if>
    
            <g:render template="/loggedin"/>
    
            <g:layoutBody />
            
            <div id="searchResultArea" class="searchResultPopup" style="display: none"></div>

        </div>
    
    </div>
    
    <g:render template="/footer" model="${[homepage:false]}"/>
    
    <g:render template="/analytics"/>
    
    </body>
</html>
