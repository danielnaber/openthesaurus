<%@ import page="com.vionto.vithesaurus.*" %>

<html>
    <head>
        <title><g:message code="homepage.title"/></title>
        <meta name="layout" content="homepage" />
    </head>
    <body>

		<div class="homepagead_right">
        	<g:render template="/ads/homepage"/>
        </div>

		<div class="homepagecontent">

	        <div class="logo"><img
	        	src="${createLinkTo(dir:'images',file:message(code:'logo'))}" 
	        	alt="<g:message code='logo.alt.text'/>" /></div>
	            
	        <h1 class="homepagehead"><g:message code="homepage.head"/></h1>
	        
	        <g:if test="${flash.message}">
	            <div class="message">${flash.message}</div>
	        </g:if>
	
	        <g:render template="/searchform"/>
	
	        <br />
	        
	        <p class="mainpage"><br />
	            <g:if test="${session.user?.permission == 'admin'}">
		    	    <g:link controller="admin">special admin links</g:link><br /><br />
	        	</g:if>
	        	<g:link controller="about"><g:message code="homepage.about"/></g:link> &middot;
	        	<g:link controller="about" action="faq"><g:message code="homepage.faq"/></g:link> &middot;
	        	<g:link controller="about" action="download"><g:message code="homepage.download"/></g:link> &middot;
	        	<g:link controller="about" action="newsarchive"><g:message code="homepage.news_archive"/></g:link> &middot;
	        	<g:link controller="synset" action="statistics"><g:message code="homepage.top_users"/></g:link> 
			</p>
	
			<!-- 
			FIXME: Zufallseinträge
			 -->  
			
	        <p class="mainpage"><br />
		        <!-- 
	            <g:link controller="term" action="list"><g:message code="a_to_z"/></g:link> &middot;
	             -->
	            <g:link controller="synset" action="variation" id="at"><g:message code="austrian.words"/></g:link> &middot;
	            <g:link controller="synset" action="variation" id="ch"><g:message code="swiss.words"/></g:link> &middot;
	            <g:link controller="tree" action="index"><g:message code="tree.headline"/></g:link> &middot;
	            <g:link controller="synset" action="statistics"><g:message code="statistics"/></g:link> &middot;
	            <g:link controller="userEvent" action="list"><g:message code="changelog"/></g:link>
	        </p>

			<div class="homepagecredits"><g:message code="homepage.credits"/></div>

			<div class="homepagead_bottom">
	        	<g:render template="/ads/homepage_bottom"/>
	        </div>

		</div>

    </body>
</html>
