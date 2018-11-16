<g:if test="${!session.user}">
    <div style="margin-top:60px; text-align: center">
        <g:if test="${Math.random() < 0}">
            <script async src="//pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>
            <!-- Homepage -->
            <ins class="adsbygoogle"
                 style="display:inline-block;width:728px;height:90px"
                 data-ad-client="ca-pub-3414496606998809"
                 data-ad-slot="3207679434"></ins>
            <script>
                (adsbygoogle = window.adsbygoogle || []).push({});
            </script>
        </g:if>
        <g:else>
            <!-- -->
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
        </g:else>
        <br><span style="color:#999999">Anzeige</span>
    </div>
    <div style="height:60px">&nbsp;</div>
</g:if>
<g:else>
    <div style="height:100px">&nbsp;</div>
</g:else>