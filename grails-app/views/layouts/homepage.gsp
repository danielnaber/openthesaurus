<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "DTD/xhtml1-transitional.dtd">
<html>
    <head>
        <title><g:layoutTitle default="Grails" /></title>
        <meta name='keywords' content='Synonym, Synonyme, Synonymw&ouml;rterbuch, sinnverwandte W&ouml;rter' />
        <meta name='description' content='OpenThesaurus ist ein freies deutsches Synonymw&ouml;rterbuch, bei dem jeder mitmachen kann.' />
        <link type="text/css" rel="stylesheet" href="${createLinkTo(dir:'css',file:'main.css')}" />
        <link rel="shortcut icon" href="${createLinkTo(dir:'images',file:message(code:'favicon.name'))}" />
        <link rel="search" type="application/opensearchdescription+xml" title="OpenThesaurus" href="${createLinkTo(dir:'openSearch',file:message(code:'index'))}" />
        <link rel="alternate" type="application/rss+xml" title="<g:message code='rss.title'/>" href="${createLinkTo(dir:'feed')}" />
        <g:layoutHead />
        <g:javascript library="application" />				
    </head>
    <body>
    
       	<g:layoutBody />	

        <!--
        <p class="buildInfo">Version:
            ${grailsApplication.getMetadata().get('app.version')}<br />
            Application: ${grailsApplication.getMetadata().get('app.name')}
        </p>
        -->

		<g:render template="/analytics"/>

    </body>	
</html>