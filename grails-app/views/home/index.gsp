<!doctype html>
<%@page import="com.vionto.vithesaurus.*" %>
<html>
<head>
    <title><g:message code="homepage.title"/></title>
    <meta name="layout" content="homepage" />
    <script async='async' src='https://www.googletagservices.com/tag/js/gpt.js'></script>
    <script>
        var googletag = googletag || {};
        googletag.cmd = googletag.cmd || [];
    </script>
</head>
<body>

<hr/>

<g:if test="${flash.message}">
    <div class="message">${flash.message}</div>
</g:if>

<g:if test="${!session.user}">
    <div style="margin-top:60px; text-align: center">
        <!-- Yieldlove AdTag - openthesaurus.de - responsive -->
        <script type='text/javascript'>
            googletag.cmd.push(function() {
                if (window.innerWidth >= 800) {
                    googletag.defineSlot('/53015287/openthesaurus.de_d_728x90_1', [728, 90], 'div-gpt-ad-1407836215276-0').addService(googletag.pubads());
                }
                if (window.innerWidth < 800) {
                    googletag.defineSlot('/53015287/openthesaurus.de_m_300x250_3', [300, 250], 'div-gpt-ad-1407836215276-0').addService(googletag.pubads());
                }
                googletag.pubads().enableSingleRequest();
                googletag.enableServices();
            });
        </script>
        <div id='div-gpt-ad-1407836215276-0'>
            <script type='text/javascript'>
                googletag.cmd.push(function() { googletag.display('div-gpt-ad-1407836215276-0'); });
            </script>
        </div>
        <!-- Ende Yieldlove AdTag -->
        <br><span style="color:#999999">Anzeige</span>
    </div>
    <div style="height:60px">&nbsp;</div>
</g:if>
<g:else>
    <div style="height:100px">&nbsp;</div>
</g:else>

</body>
</html>
