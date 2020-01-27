<!doctype html>
<html lang="${message(code:'html.lang')}">
<head>
  <title><g:layoutTitle default="OpenThesaurus" /></title>
  <meta name='keywords' content='${message(code:"homepage.meta.keywords")}' />
  <meta name='description' content='${message(code:"homepage.meta.description")}' />
  <asset:stylesheet src="application"/>
  <link rel="shortcut icon" href="${createLinkTo(dir:'images',file:message(code:'favicon.name'))}" />
  <link rel="search" type="application/opensearchdescription+xml" title="${message(code:'opensearch.link.title')}" href="/openSearch" />
  <link rel="alternate" type="application/rss+xml" title="<g:message code='rss.title'/>" href="/feed" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta name="flattr:id" content="62lgqk">
  <asset:javascript src="application"/>
  <g:render template="/script"/>
  <g:layoutHead />
  <g:render template="/layouts/scripts"/>
  <g:if test="${mso}">
      <!--MSO1-->
      <g:render template="/layouts/scripts_mso"/>
      <!--/MSO-->
  </g:if>
</head>
<body>

    <g:if test="${mso}">
        <!--MSO2-->
        <!-- Google Tag Manager (noscript) -->
        <noscript><iframe src="https://www.googletagmanager.com/ns.html?id=GTM-WZMBZTG"
                          height="0" width="0" style="display:none;visibility:hidden"></iframe></noscript>
        <!-- End Google Tag Manager (noscript) -->
    </g:if>
    
    <div id="searchResultArea" class="searchResultPopup" style="display: none">
    </div>

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
    
    </body>
</html>
