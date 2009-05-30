<%@ import page="com.vionto.vithesaurus.*" %>
<html>
    <head>
        <title><g:message code="homepage.title"/></title>
        <meta name="layout" content="homepage" />
    </head>
    <body>

        <div class="logo"><a href="${createLinkTo(dir:'',file:'')}"><img
        	src="${createLinkTo(dir:'images',file:message(code:'logo'))}" 
        	alt="<g:message code='logo.alt.text'/>" /></a></div>
            
        <h1 class="homepagehead"><g:message code="homepage.head"/></h1>

        <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
        </g:if>

        <g:render template="/searchform"/>

        <br />

        <p class="mainpage"><br />
        	<g:link controller="about"><g:message code="homepage.about"/></g:link> &middot;
        	<g:link controller="about" action="faq"><g:message code="homepage.faq"/></g:link> &middot;
        	<g:link controller="about" action="download"><g:message code="homepage.download"/></g:link> &middot;
        	<g:link controller="about" action="news_archive"><g:message code="homepage.news_archive"/></g:link> &middot;
        	<g:link controller="about" action="topusers"><g:message code="homepage.top_users"/></g:link> 
		</p>

		<!-- 
		FIXME: A bis Z -  Zufallseinträge - Baumansicht - Österreichische Wörter - Schweizer Wörter
		 -->  
		
        <p class="mainpage"><br />
            <g:link controller="term" action="list"><g:message code="a_to_z"/></g:link> &middot;
            <g:link controller="synset" action="statistics"><g:message code="statistics"/></g:link> &middot;
            <g:link controller="userEvent" action="list"><g:message code="changelog"/></g:link>
        </p>

    </body>
</html>