<g:if test="${!session.user && withAd}">
    <div style="margin-top:60px; text-align: center">
        <g:if test="${mso}">
            <!--MSO-ad-->
            <div id="openthesaurus_leaderboard_1"></div>
        </g:if>
        <g:else>
            <!-- Yieldlove AdTag - openthesaurus.de - responsive -->
			<!-- Yieldlove AdTag - openthesaurus.de - responsive -->
			<div id='div-gpt-ad-1407836137790-0'>
			  <script type='text/javascript'>
				if (window.innerWidth >= 801) {
				  googletag.cmd.push(function() {
					googletag.defineSlot('/53015287,22719358241/openthesaurus.de_d_336x280_1', [[336, 280], [300, 250]], 'div-gpt-ad-1407836137790-0').addService(googletag.pubads());
					googletag.display('div-gpt-ad-1407836137790-0');
				  });
				}

			if (window.innerWidth < 801) {
				  googletag.cmd.push(function() {
					googletag.defineSlot('/53015287,22719358241/openthesaurus.de_m_300x250_2', [300, 250], 'div-gpt-ad-1407836137790-0').addService(googletag.pubads());
					googletag.display('div-gpt-ad-1407836137790-0');
				  });
				}
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
