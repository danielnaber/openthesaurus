<g:if test="${!session.user && withAd}">
    <div style="margin-top:60px; text-align: center">
        <!--<br><span style="color:#999999">Anzeige</span>-->
    </div>
    <div style="height:60px">&nbsp;</div>
</g:if>
<g:else>
    <div style="height:100px">&nbsp;</div>
</g:else>
