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
    
        <noscript>
	        <div class="nojs">
	           Note: You need to enable Javascript in order to be able to edit the thesaurus
	        </div>
        </noscript>
        
        <div class="logo_mobile"><a href="${createLinkTo(dir:'/',file:'')}"><img
        	src="${createLinkTo(dir:'images',file:message(code:'logo'))}?v1" 
        	alt="<g:message code='logo.alt.text'/>" width="292" height="80" /></a></div>
        	
        <g:render template="/searchform_mobile"/>

       	<g:layoutBody />

		<g:render template="/analytics"/>

    </body>	
</html>