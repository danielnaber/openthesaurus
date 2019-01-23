<g:if test="${!session.user && withAd}">
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
    <div style="margin-top:20px; text-align: center">
        <g:if test="${mso}">
            <!--MSO-ad-->
            <div id="openthesaurus_medium_rectangle_1"></div>
            <!--/MSO-->
        </g:if>
        <g:else>
            <!-- Yieldlove AdTag - openthesaurus.de - responsive -->
            <script type='text/javascript'>
                googletag.cmd.push(function() {
                    if (window.innerWidth >= 801) {
                        googletag.defineSlot('/53015287/openthesaurus.de_d_336x250_1', [336, 250], 'div-gpt-ad-1407836043208-0').addService(googletag.pubads());
                    }
                    if (window.innerWidth < 801) {
                        googletag.defineSlot('/53015287/openthesaurus.de_m_300x250_2', [300, 250], 'div-gpt-ad-1407836043208-0').addService(googletag.pubads());
                    }
                    googletag.pubads().enableSingleRequest();
                    googletag.enableServices();
                });
            </script>
            <div id='div-gpt-ad-1407836043208-0'>
                <script type='text/javascript'>
                    googletag.cmd.push(function() { googletag.display('div-gpt-ad-1407836043208-0'); });
                </script>
            </div>
        </g:else>
        <span style="color:#999999">Anzeige</span>
    </div>
    <hr>
</g:if>
