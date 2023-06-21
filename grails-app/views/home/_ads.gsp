<g:if test="${!session.user && withAd}">
    <div style="margin-top:60px; text-align: center" id="desktopAd">
        <a href="https://gfdw.eu/"><img src="/assets/external/gfdw-banner2.png" alt="Geld für die Welt e.V. beteiligt Menschen in Armut an den Gewinnen der Weltwirtschaft" /></a>
        <!--<br><span style="color:#999999">Anzeige</span>-->
    </div>
    <div style="margin-top:60px; text-align: center" id="mobileAd">
        <a href="https://gfdw.eu/"><img src="/assets/external/gfdw-banner1.png" alt="Geld für die Welt e.V. beteiligt Menschen in Armut an den Gewinnen der Weltwirtschaft" /></a>
        <!--<br><span style="color:#999999">Anzeige</span>-->
    </div>
    <div style="height:60px">&nbsp;</div>
</g:if>
<g:else>
    <div style="height:100px">&nbsp;</div>
</g:else>
