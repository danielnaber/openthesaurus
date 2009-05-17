<%@ import page="com.vionto.vithesaurus.*" %>
<html>
    <head>
        <title>vithesaurus - powered by vionto</title>
        <meta name="layout" content="homepage" />
    </head>
    <body>

        <div class="logo" style="margin:20px"><img border="0"
            src="${createLinkTo(dir:'images',file:'openthesaurus-logo.png')}" 
            alt="Thesaurus Logo" /></div>
            
        <h1 style="text-align:center">OpenThesaurus - Synonyme und Assoziationen</h1>

        <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
        </g:if>

        <g:render template="/searchform"/>

        <br />

        <p class="mainpage"><br />
            <g:link controller="synset" action="list">List all Concepts</g:link> |
            <g:link controller="synset" action="statistics">Statistics</g:link> |
            <g:link controller="userEvent" action="list">Log of Changes</g:link>
        </p>

    </body>
</html>