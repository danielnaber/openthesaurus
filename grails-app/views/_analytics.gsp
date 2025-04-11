<%-- add your analytics code here --%>
<!-- Matomo -->
<script type="text/javascript">
    var _paq = _paq || [];
    /* tracker methods like "setCustomDimension" should be called before "trackPageView" */
    _paq.push(['trackPageView']);
    _paq.push(['enableLinkTracking']);

    /*var secondaryTracker = 'https://SERVER-URL/';
    var secondaryWebsiteId = 1;
    _paq.push(['addTracker', secondaryTracker, secondaryWebsiteId]);*/

    (function() {
        var u="//analytics.languagetoolplus.com/matomo/";
        _paq.push(['setTrackerUrl', u+'piwik.php']);
        _paq.push(['setSiteId', '5']);
        var d=document, g=d.createElement('script'), s=d.getElementsByTagName('script')[0];
        g.type='text/javascript'; g.async=true; g.defer=true; g.src=u+'piwik.js'; s.parentNode.insertBefore(g,s);
    })();
</script>
<!-- End Matomo Code -->
