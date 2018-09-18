<!doctype html>
<html lang="${message(code:'html.lang')}">
<head>
  <title><g:layoutTitle default="OpenThesaurus" /></title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta name='keywords' content='${message(code:"homepage.meta.keywords")}' />
  <meta name='description' content='${message(code:"homepage.meta.description")}' />
  <link type="text/css" rel="stylesheet" href="${createLinkTo(dir:'css/font-awesome-4.7.0/css', file:  'font-awesome.min.css')}" />
  <link type="text/css" rel="stylesheet" href="${createLinkTo(dir: 'css', file: 'layout.css')}?v20180423" />
  <link rel="shortcut icon" href="${createLinkTo(dir:'images',file:message(code:'favicon.name'))}" />
  <link rel="search" type="application/opensearchdescription+xml" title="${message(code:'opensearch.link.title')}" href="${createLinkTo(dir:'openSearch')}" />
  <link rel="alternate" type="application/rss+xml" title="<g:message code='rss.title'/>" href="${createLinkTo(dir:'feed')}" />
  <meta name="flattr:id" content="62lgqk">
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
    
        </div>
    
    </div>
    
    <g:render template="/footer" model="${[homepage:false]}"/>
    
    <g:render template="/analytics"/>
    
    <script defer type="text/javascript" src="${createLinkTo(dir:'js',file:'jquery-2.2.4.min.js')}"></script>
    <script defer type="text/javascript" src="${createLinkTo(dir:'js',file:'cookie-script.js')}"></script>
    <script defer type="text/javascript" src="${createLinkTo(dir:'js',file:'main.js')}"></script>
    <g:render template="/script" />

</body>
</html>
