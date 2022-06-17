<!doctype html>
<%@page import="com.vionto.vithesaurus.*" %>
<html>
<head>
    <title><g:message code="homepage.title"/></title>
    <meta name="layout" content="homepage" />
    <g:if test="${withAd}">
        <!-- yieldlove -->
	<script async='async' src='//cdn-a.yieldlove.com/v2/yieldlove.js?openthesaurus.de'></script>
	<script async='async' src='https://securepubads.g.doubleclick.net/tag/js/gpt.js'></script>
	<script>
	  var googletag = googletag || {};
	  googletag.cmd = googletag.cmd || [];
	  googletag.cmd.push(function() {
	    googletag.pubads().disableInitialLoad();
	    googletag.enableServices();
	  });
	</script>
        <!-- yieldlove end -->
    </g:if>
</head>
<body>

<hr/>

<g:if test="${flash.message}">
    <div class="message">${flash.message}</div>
</g:if>

<g:if test="${!params.test}">
    <g:render template="/home/ads"/>
</g:if>

</body>
</html>
