<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "DTD/xhtml1-transitional.dtd">
<html>
    <head>
        <title><g:layoutTitle default="Grails" /></title>
        <link type="text/css" rel="stylesheet" href="${createLinkTo(dir:'css',file:'main.css')}" />
        <link rel="shortcut icon" href="${createLinkTo(dir:'images',file:message(code:'favicon.name'))}" />
        <link rel="search" type="application/opensearchdescription+xml" title="OpenThesaurus" href="${createLinkTo(dir:'openSearch',file:message(code:'index'))}" />
        <g:layoutHead />
        <g:javascript library="application" />				
    </head>
    <body>

        <div class="logo"><a href="${createLinkTo(dir:'',file:'')}"><img
        	src="${createLinkTo(dir:'images',file:message(code:'logo'))}" 
        	alt="<g:message code='logo.alt.text'/>" /></a></div>

       	<g:layoutBody />	

		<g:render template="/analytics"/>

    </body>	
</html>