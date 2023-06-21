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
        <a href="https://gfdw.eu/"><img src="/assets/external/gfdw-banner1.png"
            alt="Geld für die Welt e.V. beteiligt Menschen in Armut an den Gewinnen der Weltwirtschaft" /></a>
        <!--<span style="color:#999999">Anzeige</span>-->
    </div>
    <hr>
</g:if>
