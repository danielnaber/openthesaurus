<g:if test="${!session.user && withAd}">
    <%
    String imgDesktop = "";
    String imgMobile = "";
    String altText = "";
    int rnd = new Random().nextInt(3);
    if (rnd == 0) {
        imgDesktop = "gfdw2.png";
        imgMobile = "gfdw1.png";
        altText = "Geld für die Welt e.V. beteiligt Menschen in Armut an den Gewinnen der Weltwirtschaft";
        link = "https://www.gfdw.eu/de?utm_source=openthesaurus&utm_medium=banner&utm_campaign=random_banner";
    } else if (rnd == 1) {
        imgDesktop = "es_banner_V01_a.png";
        imgMobile = "es_banner_V02_a.png";
        altText = "effektiv-spenden.org - bei uns geht deine Spende an Hilfsorganisationen mit der größten Wirkung";
        link = "https://effektiv-spenden.org?1";
    } else if (rnd == 2) {
        imgDesktop = "es_banner_V01_b.png";
        imgMobile = "es_banner_V02_b.png";
        altText = "effektiv-spenden.org - Deutschlands wirksamste Spendenplattform";
        link = "https://effektiv-spenden.org?2";
    }
    %>
    <div style="margin-top:60px; text-align: center" id="desktopAd">
        <a href="${link}"><img src="/assets/external/${imgDesktop}" alt="${altText}" /></a>
        <!--<br><span style="color:#999999">Anzeige</span>-->
    </div>
    <div style="margin-top:60px; text-align: center" id="mobileAd">
        <a href="${link}"><img src="/assets/external/${imgMobile}" alt="${altText}" /></a>
        <!--<br><span style="color:#999999">Anzeige</span>-->
    </div>
    <div style="height:60px">&nbsp;</div>
</g:if>
<g:else>
    <div style="height:100px">&nbsp;</div>
</g:else>
