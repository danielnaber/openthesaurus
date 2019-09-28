<g:if test="${!session.user && withAd}">
    <div style="margin-top:60px; text-align: center">
        <g:if test="${mso}">
            <!--MSO-ad-->
            <div id="openthesaurus_leaderboard_1"></div>
        </g:if>
        <g:else>
            <!-- Yieldlove AdTag - openthesaurus.de - responsive -->
            <script type='text/javascript'>
                googletag.cmd.push(function() {
                    if (window.innerWidth >= 1090) {
                        googletag.defineSlot('/53015287/openthesaurus.de_d_970x90_1', [970, 90], 'div-gpt-ad-1407836290508-0').addService(googletag.pubads());
                    }
                    if (window.innerWidth < 1090 && window.innerWidth >= 801) {
                        googletag.defineSlot('/53015287/openthesaurus.de_d_728x90_1', [728, 90], 'div-gpt-ad-1407836290508-0').addService(googletag.pubads());
                    }
                    if (window.innerWidth < 801) {
                        googletag.defineSlot('/53015287/openthesaurus.de_m_300x250_1', [300, 250], 'div-gpt-ad-1407836290508-0').addService(googletag.pubads());
                    }
                    googletag.pubads().enableSingleRequest();
                    googletag.enableServices();
                });
            </script>
            <div id='div-gpt-ad-1407836290508-0'>
                <script type='text/javascript'>
                    googletag.cmd.push(function() { googletag.display('div-gpt-ad-1407836290508-0'); });
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