
    <g:if test="${q.split(" ").length <= 2}">

        <h2><g:message code="result.external.search" args="${[params.q]}"/></h2>

        <p style="line-height: 175%">
            <g:set var="utf8Query" value="${URLEncoder.encode(q, 'utf8')}"/>
            <a href="https://www.korrekturen.de/flexion/suche.php?q=${utf8Query}">Wortformen von korrekturen.de</a>
        </p>

    </g:if>

