<header class="header">
    <div class="container">
        <div class="header-inner">
            <div class="header-burger">
                <i class="fa fa-bars"></i>
            </div>
            <div class="header-logo">
                <img src="${createLinkTo(dir:'images',file:'logo-mobile.png')}?2018" alt="OpenThesaurus - Synonyme und Assoziationen">
            </div>
            <nav class="header-menu">
                <g:link class="header-menu-item" controller="wordList"><span><g:message code="homepage.wordlists"/></span></g:link>
                <g:link class="header-menu-item" controller="tag" action="list"><span><g:message code="homepage.tags"/></span></g:link>
                <g:link class="header-menu-item" controller="about" action="api"><span><g:message code="homepage.api.short"/></span></g:link>
                <g:link class="header-menu-item" controller="about"><span><g:message code="homepage.about"/></span></g:link>
            </nav>
            <div class="header-entry">
                <g:link controller="user" action="login" class="lightlink" params="${linkParams}"><g:message code="footer.login"/></g:link>
            </div>
            <g:if test="${session.user && grailsApplication.config.thesaurus.readOnly == 'true'}">
                <div style="color:white;border-width: 2px; background-color: darkorange;padding:8px">
                    <g:message code="server.read.only"/>
                </div>
            </g:if>
        </div>
    </div>
</header>
