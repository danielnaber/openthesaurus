<!doctype html>
<html lang="${message(code:'html.lang')}">
    <head>
        <title><g:layoutTitle default="OpenThesaurus" /></title>
        <link type="text/css" rel="stylesheet" href="${createLinkTo(dir:'css',file:'reset-min.css')}" />
        <link type="text/css" rel="stylesheet" href="${createLinkTo(dir:'css',file:'layout.css')}" />
        <link rel="shortcut icon" href="${createLinkTo(dir:'images',file:message(code:'favicon.name'))}" />
        <link rel="search" type="application/opensearchdescription+xml" title="OpenThesaurus" href="${createLinkTo(dir:'openSearch')}" />
        <g:render template="/script"/>
        <g:layoutHead />
        <g:render template="/layouts/scripts"/>
    </head>
    <body>

    <div id="body">

      <div id="content">

        <g:render template="/searchform" model="${[homepage: false, isDirectSearch: true]}"/>

        <g:if test="${session.user}">
          <noscript>
              <div class="nojs">
                 <g:message code='no.javascript.warning'/>
              </div>
          </noscript>
        </g:if>

        <g:render template="/loggedin"/>
        
       	<g:layoutBody />

        <div id="searchResultArea" style="display:none;position:absolute;outline:3px solid white;padding:10px;margin:10px;border:solid 2px #aaaaaa;background-color:white;width:760px;min-height:100px;left:-10px;top:160px;">
        </div>

      </div>

    </div>

    <g:render template="/footer" model="${[homepage:false]}"/>

    <g:render template="/analytics"/>

    </body>
</html>