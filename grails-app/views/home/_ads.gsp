<g:if test="${!session.user && withAd}">
    <%
    String imgDesktop = "";
    String imgMobile = "";
    String altText = "";
    int rnd = new Random().nextInt(3);
    if (rnd == 0) {
        altText = "Geld für die Welt e.V. beteiligt Menschen in Armut an den Gewinnen der Weltwirtschaft";
        int rnd2 = new Random().nextInt(5);
        if (rnd2 == 0) {
            imgMobile = "OT6-der-etf.png";
            imgDesktop = "OT1-der-etf.png";
            link = "https://www.gfdw.eu?utm_source=openthesaurus&utm_medium=banner&utm_campaign=brand&utm_term=OT1-der-etf";
        } else if (rnd2 == 1) {
            imgMobile = "OT7-du-setzt-auf-etfs.png";
            imgDesktop = "OT2-du-setzt-auf-etfs.png";
            link = "https://www.gfdw.eu/?utm_source=openthesaurus&utm_medium=banner&utm_campaign=question&utm_term=OT2-du-setzt-auf-etfs";
        } else if (rnd2 == 2) {
            imgMobile = "OT8-etf-sparen.png";
            imgDesktop = "OT3-etf-sparen.png";
            link = "https://www.gfdw.eu/spende-schenken?utm_source=openthesaurus&utm_medium=banner&utm_campaign=gift&utm_term=OT4-schenke-was-bleibt";
        } else if (rnd2 == 3) {
            imgMobile = "OT9-schenke-was-bleibt.png";
            imgDesktop = "OT4-schenke-was-bleibt.png";
            link = "https://www.gfdw.eu/spende-schenken?utm_source=openthesaurus&utm_medium=banner&utm_campaign=gift&utm_term=OT5-schenke-was-waechst";
        } else if (rnd2 == 4) {
            imgMobile = "OT10-schenke-was-waechst.png";
            imgDesktop = "OT5-schenke-was-waechst.png";
            link = "https://www.gfdw.eu/spende-schenken?utm_source=openthesaurus&utm_medium=banner&utm_campaign=gift&utm_term=OT5-schenke-was-waechst";
        }
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
    </div>
    <div style="margin-top:60px; text-align: center" id="mobileAd">
        <a href="${link}"><img src="/assets/external/${imgMobile}" alt="${altText}" /></a>
    </div>
</g:if>
