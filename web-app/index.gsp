<%@page import="com.vionto.vithesaurus.*" %>

<html>
    <head>
        <title><g:message code="homepage.title"/></title>
        <meta name="layout" content="homepage" />
    </head>
    <body>

		<g:if test="${!BrowserDetection.isMobileDevice(request)}">
			<div class="homepagead_right">
	        	<g:render template="/ads/homepage"/>
	        </div>
		</g:if>    

		<div class="homepagecontent">

	        <div class="logo"><img
	        	src="${createLinkTo(dir:'images',file:message(code:'logo'))}?v1" 
	        	alt="<g:message code='logo.alt.text'/>" width="292" height="80"/></div>
	            
	        <h1 class="homepagehead"><g:message code="homepage.head"/></h1>
	        
	        <g:if test="${flash.message}">
	            <div class="message">${flash.message}</div>
	        </g:if>
	
	        <g:render template="/searchform"/>
	
	        <p class="mainpage">
	            <g:if test="${session.user?.permission == 'admin'}">
		    	    <g:link controller="admin">special admin links</g:link><br /><br />
	        	</g:if>
	        	<g:link controller="about"><g:message code="homepage.about"/></g:link> <span class="d">&middot;</span>
	        	<g:link controller="about" action="faq"><g:message code="homepage.faq"/></g:link> <span class="d">&middot;</span>
	        	<g:link controller="about" action="api"><g:message code="homepage.api"/></g:link> <span class="d">&middot;</span>
	        	<g:link controller="about" action="download"><g:message code="homepage.download"/></g:link> <span class="d">&middot;</span>
	        	<g:link controller="about" action="newsarchive"><g:message code="homepage.news_archive"/></g:link>
	        	<br />
		        <%--
	            <g:link controller="term" action="list"><g:message code="a_to_z"/></g:link> &middot;
	            --%>
	            <g:link controller="synset" action="variation" id="at"><g:message code="austrian.words"/></g:link> <span class="d">&middot;</span>
	            <g:link controller="synset" action="variation" id="ch"><g:message code="swiss.words"/></g:link> <span class="d">&middot;</span>
	            <g:link controller="tree" action="index"><g:message code="tree.headline"/></g:link> <span class="d">&middot;</span>
	            <g:link controller="synset" action="statistics"><g:message code="statistics"/></g:link> <span class="d">&middot;</span>
	            <g:link controller="userEvent" action="list"><g:message code="changelog"/></g:link>
	        </p>
	        
	        <p class="mainpage intro">
	        	<g:message code="homepage.intro"/>
	        </p>

			<div class="homepagecredits"><g:message code="homepage.credits"/></div>

			<div class="homepagead_bottom">
	        	<g:render template="/ads/homepage_bottom"/>
	        </div>

		</div>
		
    </body>
</html>
