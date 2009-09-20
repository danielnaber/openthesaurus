<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "DTD/xhtml1-transitional.dtd">
<html>
    <head>
        <title><g:layoutTitle default="Grails" /></title>
        <meta name='keywords' content='${message(code:"homepage.meta.keywords")}' />
        <meta name='description' content='${message(code:"homepage.meta.description")}' />
        <link type="text/css" rel="stylesheet" href="${createLinkTo(dir:'css',file:'main.css')}" />
        <link rel="shortcut icon" href="${createLinkTo(dir:'images',file:message(code:'favicon.name'))}" />
        <link rel="search" type="application/opensearchdescription+xml" title="${message(code:'opensearch.link.title')}" href="${createLinkTo(dir:'openSearch',file:message(code:'index'))}" />
        <link rel="alternate" type="application/rss+xml" title="<g:message code='rss.title'/>" href="${createLinkTo(dir:'feed')}" />
        <g:layoutHead />
        <g:javascript library="application" />				
    </head>
    <body>
    
       	<g:layoutBody />	

		<g:render template="/analytics"/>

    </body>	
</html>