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
    <%
    String imgDesktop = "";
    String imgMobile = "";
    String altText = "";
    int rnd = new Random().nextInt(3);
    if (rnd == 0) {
        imgDesktop = "gfdw-banner2.png";
        imgMobile = "gfdw-banner1.png";
        altText = "Geld für die Welt e.V. beteiligt Menschen in Armut an den Gewinnen der Weltwirtschaft";
        link = "https://gfdw.eu";
    } else if (rnd == 1) {
        imgDesktop = "es_banner_V01_a.png";
        imgMobile = "es_banner_V02_a.png";
        altText = "effektiv-spenden.org - bei uns geht deine Spende an Hilfsorganisationen mit der größten Wirkung";
        link = "https://effektiv-spenden.org?3";
    } else if (rnd == 2) {
        imgDesktop = "es_banner_V01_b.png";
        imgMobile = "es_banner_V02_b.png";
        altText = "effektiv-spenden.org - Deutschlands wirksamste Spendenplattform";
        link = "https://effektiv-spenden.org?4";
    }
    %>
    <div style="margin-top:20px; text-align: center">
        <a href="${link}"><img style="max-width: 100%; height: auto;" src="/assets/external/${imgMobile}" alt="${altText}" /></a>
        <!--<span style="color:#999999">Anzeige</span>-->
    </div>
    <hr>
</g:if>
