<g:if test="${!session.user && withAd}">
    <%
    String imgMobile = "";
    String altText = "";
    int rnd = new Random().nextInt(3);
    if (rnd == 0) {
        imgMobile = "gfdw1.png";
        altText = "Geld für die Welt e.V. beteiligt Menschen in Armut an den Gewinnen der Weltwirtschaft";
        link = "https://www.gfdw.eu/de?utm_source=openthesaurus&utm_medium=banner&utm_campaign=random_banner";
    } else if (rnd == 1) {
        imgMobile = "es_banner_V02_a.png";
        altText = "effektiv-spenden.org - bei uns geht deine Spende an Hilfsorganisationen mit der größten Wirkung";
        link = "https://effektiv-spenden.org";
    } else if (rnd == 2) {
        imgMobile = "es_banner_V02_b.png";
        altText = "effektiv-spenden.org - Deutschlands wirksamste Spendenplattform";
        link = "https://effektiv-spenden.org";
    }
    %>
    <div id="mainBn">
        <a href="${link}"><img style="max-width: 100%; height: auto;" src="/assets/external/${imgMobile}" alt="${altText}" /></a>
    </div>
    <hr>
</g:if>
