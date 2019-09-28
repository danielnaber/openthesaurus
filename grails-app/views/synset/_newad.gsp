<g:if test="${!session.user}">

    <g:set var="googleBlock" value="${false}"/>
    <g:if test="${request.forwardURI}">
        <g:if test="${request.forwardURI}">
            <g:set var="url" value="${request.forwardURI.toLowerCase()}"/>
            <g:set var="googleBlock" value="${url.endsWith('/hure') || url.endsWith('/ficken') ||
                url.endsWith('/orgasmus') || url.endsWith('/sex') || url.endsWith('/masturbieren') || url.endsWith('/sexy') ||
                url.endsWith('/sexspielzeug') || url.endsWith('/akt') || url.endsWith('/dildo') || url.endsWith('/sex%20haben') ||
                url.endsWith('/%28sich%29%20einen%20runterholen') || url.endsWith('/hardcore') || url.endsWith('/votze') ||
                url.endsWith('/pornografie') || url.endsWith('/pornographie')
                }"/>
        </g:if>
    </g:if>


    <span style="color:#999999">Anzeige</span><br>
    <!--<img src="http://localhost:8080/openthesaurus/static/images/ads/ad300x250.png">-->


    <g:if test="${withAd}">
        <g:if test="${Math.random() < 0.5 && !googleBlock}">
            <script async src="//pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>
            <!-- Ergebnisseite -->
            <ins class="adsbygoogle"
                 style="display:inline-block;width:300px;height:250px"
                 data-ad-client="ca-pub-3414496606998809"
                 data-ad-slot="2169876034"></ins>
            <script>
            (adsbygoogle = window.adsbygoogle || []).push({});
        </script>
        </g:if>
        <g:else>
            <!-- Yieldlove AdTag - openthesaurus.de - responsive -->
            <script type='text/javascript'>
            googletag.cmd.push(function() {
                if (window.innerWidth >= 799) {
                    googletag.defineSlot('/53015287/openthesaurus.de_d_300x250_1', [300, 250], 'div-gpt-ad-1407836274301-0').addService(googletag.pubads());
                }
                if (window.innerWidth < 799) {
                    googletag.defineSlot('/53015287/openthesaurus.de_m_300x250_1', [300, 250], 'div-gpt-ad-1407836274301-0').addService(googletag.pubads());
                }
                googletag.pubads().enableSingleRequest();
                googletag.enableServices();
            });
        </script>
            <div id='div-gpt-ad-1407836274301-0'>
                <script type='text/javascript'>
                googletag.cmd.push(function() { googletag.display('div-gpt-ad-1407836274301-0'); });
            </script>
            </div>
        </g:else>
    </g:if>
    
</g:if>
