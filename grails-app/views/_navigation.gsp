<header class="header">
    <div class="container">
        <div class="header-inner">
            <div class="header-burger">
                <span class="icon-wrapper">
                    <i class="fa fa-bars icon icon--closed" aria-hidden="true"></i>
                    <i class="fa fa-angle-left icon icon--opened" aria-hidden="true"></i>
                </span>
            </div>
            <div class="header-logo">
                <a href="${createLinkTo(dir:'/',file:'')}">
                    <img 
                        src="${createLinkTo(dir:'images',file:'logo-mobile.png')}?2018" 
                        alt="OpenThesaurus - Synonyme und Assoziationen" 
                    />
                </a>
            </div>
            <nav class="header-menu">
                <g:link class="header-menu-item" controller="wordList"><span><g:message code="homepage.wordlists"/></span></g:link>
                <g:link class="header-menu-item" controller="tag" action="list"><span><g:message code="homepage.tags"/></span></g:link>
                <g:link class="header-menu-item" controller="about" action="api"><span><g:message code="homepage.api.short"/></span></g:link>
                <g:link class="header-menu-item" controller="about"><span><g:message code="homepage.about"/></span></g:link>
            </nav>
            <div class="header-entry">
                <g:if test="${session.user}">
                    <g:if test="${session.user.userId.toString() == 'admin'}">
                        <g:link controller="admin" action="index"><span class="adminOnly"><g:message code="user.successful.login" args="${[session.user.userId]}"/></span></g:link>
                    </g:if>
                    <g:else>
                        <span style="color:white"><g:link controller="user" action="edit"><g:message code="user.successful.login" args="${[session.user.userId]}"/></g:link></span>
                    </g:else>
                    &nbsp;
                    <g:link controller="user" action="logout">Logout</g:link>
                </g:if>
                <g:else>
                    <g:link controller="user" action="login" class="lightlink" params="${linkParams}"><g:message code="footer.login"/></g:link>
                </g:else>
            </div>
            <g:if test="${session.user && grailsApplication.config.thesaurus.readOnly == 'true'}">
                <div style="color:white;border-width: 2px; background-color: darkorange;padding:8px">
                    <g:message code="server.read.only"/>
                </div>
            </g:if>
        </div>
    </div>
</header>
