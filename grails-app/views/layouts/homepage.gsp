<!doctype html>
<html>
<head>
  <title><g:layoutTitle default="OpenThesaurus" /></title>
  <meta name='keywords' content='${message(code:"homepage.meta.keywords")}' />
  <meta name='description' content='${message(code:"homepage.meta.description")}' />
  <link type="text/css" rel="stylesheet" href="${createLinkTo(dir:'css',file:'reset-min.css')}" />
  <link type="text/css" rel="stylesheet" href="${createLinkTo(dir:'css',file:'layout.css')}" />
  <link rel="shortcut icon" href="${createLinkTo(dir:'images',file:message(code:'favicon.name'))}" />
  <link rel="search" type="application/opensearchdescription+xml" title="${message(code:'opensearch.link.title')}" href="${createLinkTo(dir:'openSearch',file:message(code:'index'))}" />
  <link rel="alternate" type="application/rss+xml" title="<g:message code='rss.title'/>" href="${createLinkTo(dir:'feed')}" />
  <g:layoutHead />
</head>
<body>

  <g:layoutBody />
  <g:render template="/analytics"/>

</body>
</html>
