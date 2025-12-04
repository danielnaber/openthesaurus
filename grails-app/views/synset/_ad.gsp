<g:if test="${!session.user && withAd}">
    <%
    String imgMobile = "";
    String altText = "";
    String currentUrl = request.forwardURI ? request.forwardURI : "";
    //int rnd = Math.abs(currentUrl.hashCode()) % 4;
    int rnd = Math.abs(currentUrl.hashCode()) % 2;
    if (rnd == 0 || params?.ad == "gfdw") {
        altText = "Geld für die Welt e.V. beteiligt Menschen in Armut an den Gewinnen der Weltwirtschaft";
        int rnd2 = Math.abs(("foo" + currentUrl).hashCode()) % 5;
        if (rnd2 == 0) {
            imgMobile = "OT6-der-etf.png";
            link = "https://www.gfdw.eu/?utm_source=openthesaurus&utm_medium=banner&utm_campaign=brand&utm_term=OT6-der-etf";
        } else if (rnd2 == 1) {
            imgMobile = "OT7-du-setzt-auf-etfs.png";
            link = "https://www.gfdw.eu/?utm_source=openthesaurus&utm_medium=banner&utm_campaign=question&utm_term=OT7-du-setzt-auf-etfs";
        } else if (rnd2 == 2) {
            imgMobile = "OT8-etf-sparen.png";
            link = "https://www.gfdw.eu/?utm_source=openthesaurus&utm_medium=banner&utm_campaign=question&utm_term=OT8-etf-sparen";
        } else if (rnd2 == 3) {
            imgMobile = "OT9-schenke-was-bleibt.png";
            link = "https://www.gfdw.eu/spende-schenken?utm_source=openthesaurus&utm_medium=banner&utm_campaign=gift&utm_term=OT9-schenke-was-bleibt";
        } else if (rnd2 == 4) {
            imgMobile = "OT10-schenke-was-waechst.png";
            link = "https://www.gfdw.eu/spende-schenken?utm_source=openthesaurus&utm_medium=banner&utm_campaign=gift&utm_term=OT10-schenke-was-waechst";
        }
    } else if (rnd == 1) {
        imgMobile = "es_banner_V02_a.png";
        altText = "effektiv-spenden.org - bei uns geht deine Spende an Hilfsorganisationen mit der größten Wirkung";
        link = "https://effektiv-spenden.org";
    } else if (rnd == 2) {
        imgMobile = "eversion.png";
        altText = "Eversion - mit den 0°-Sohlen Entlastung bei jedem Schritt erleben";
        link = "https://www.eversion.tech?utm_source=openthesaurus&utm_medium=banner&utm_campaign=banner1";
    } else if (rnd == 3) {
        //imgMobile = "help-gerade.png";
        imgMobile = "help-schraeg.png";
        altText = "help - Deine App zur Begleitung bei chronischen Schmerzen";
        link = "https://www.help-app.de/?utm_source=openthesaurus&utm_medium=banner&utm_campaign=random_banner_1";
        //imgMobile = "empty.png";
        //imgMobile = "help-schraeg.png";
        //altText = "";
        //link = "https://www.help-app.de/?utm_source=openthesaurus&utm_medium=banner&utm_campaign=empty_banner";
    }
    /*
    } else if (rnd == 1) {
        imgMobile = "es_banner_V02_a.png";
        altText = "effektiv-spenden.org - bei uns geht deine Spende an Hilfsorganisationen mit der größten Wirkung";
        link = "https://effektiv-spenden.org";
    } else if (rnd == 2) {
        imgMobile = "es_banner_V02_b.png";
        altText = "effektiv-spenden.org - Deutschlands wirksamste Spendenplattform";
        link = "https://effektiv-spenden.org";
    }*/
    %>
    <div id="mainBn">
        <a href="${link}"><img style="max-width: 100%; height: auto;" src="/assets/external/${imgMobile}" alt="${altText}" /></a>
    </div>
    <hr>
</g:if>
