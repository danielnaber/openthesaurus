<%@ import page="com.vionto.vithesaurus.*" %>
<html>
    <head>
        <title><g:message code="homepage.title"/></title>
        <meta name="layout" content="homepage" />
    </head>
    <body>

        <div class="logo"><img border="0"
            src="${createLinkTo(dir:'images',file:'openthesaurus-logo.png')}" 
            alt="Thesaurus Logo" /></div>
            
        <h1 class="homepagehead"><g:message code="homepage.head"/></h1>

        <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
        </g:if>

        <g:render template="/searchform"/>

        <br />

        <p class="mainpage"><br />
        	<g:link controller="about"><g:message code="homepage.about"/></g:link> -
        	<g:link controller="about" action="faq"><g:message code="homepage.faq"/></g:link> -
        	<g:link controller="about" action="download"><g:message code="homepage.download"/></g:link> -
        	<g:link controller="about" action="topusers"><g:message code="homepage.top_users"/></g:link> - 
        	<g:link controller="about" action="imprint"><g:message code="homepage.imprint"/></g:link>
		</p>

		<!-- 
		FIXME: A bis Z -  Zufallseinträge - Baumansicht - Österreichische Wörter - Schweizer Wörter
		 -->  
		
        <p class="mainpage"><br />
            <g:link controller="term" action="list"><g:message code="a_to_z"/></g:link> |
            <g:link controller="synset" action="statistics"><g:message code="statistics"/></g:link> |
            <g:link controller="userEvent" action="list"><g:message code="changelog"/></g:link>
        </p>

    </body>
</html>