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
    </g:if>
    
</g:if>
