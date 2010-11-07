<!doctype html>
<html>
    <head>
        <title><g:layoutTitle default="Grails" /></title>
        <link type="text/css" rel="stylesheet" href="${createLinkTo(dir:'css',file:'reset-min.css')}" />
        <link type="text/css" rel="stylesheet" href="${createLinkTo(dir:'css',file:'layout.css')}" />
        <link rel="shortcut icon" href="${createLinkTo(dir:'images',file:message(code:'favicon.name'))}" />
        <link rel="search" type="application/opensearchdescription+xml" title="OpenThesaurus" href="${createLinkTo(dir:'openSearch',file:message(code:'index'))}" />
        <g:layoutHead />
        <g:javascript library="application" />
    </head>
    <body>

    <div id="body">

      <div id="content">

        <g:render template="/searchform"/>

        <g:if test="${session.user}">
          <noscript>
              <div class="nojs">
                 <g:message code='no.javascript.warning'/>
              </div>
          </noscript>

          <g:if test="${session.user}">
              <g:message code="user.successful.login" args="${[session.user.userId.toString()?.encodeAsHTML()]}"/>
              <span class="d">&middot;</span>
              <g:link controller="user" action="logout">Logout</g:link>
          </g:if>

        </g:if>

       	<g:layoutBody />

      </div>

    </div>

    <g:render template="/footer" model="${[homepage:false]}"/>

    <g:render template="/analytics"/>

    </body>
</html>