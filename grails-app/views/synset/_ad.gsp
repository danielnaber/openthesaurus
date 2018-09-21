<g:if test="${!session.user}">
    <div style="margin-top:20px; text-align: center">
        <g:if test="${Math.random() < 0.5}">
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
        <span style="color:#999999">Anzeige</span>
    </div>
    <hr>
</g:if>
