<html>
    <head>
        <title><g:message code="missingwords.title"/></title>
        <meta name="layout" content="main" />
    </head>
    <body>

        <h2><g:message code="missingwords.headline"/></h2>
        
        <p><g:message code="missingwords.result.intro"/></p>

        <ul>
          <g:each in="${unknownTerms}" var="term" status="i">
            <li>
                <g:set var="baseform" value="${unknownTermsBaseforms[i] ? unknownTermsBaseforms[i] : term}"/>
                <g:if test="${term == baseform}">
                    <g:link controller="synset" action="search" params="${[q:baseform]}">${term}</g:link> -
                </g:if>
                <g:else>
                    <g:link controller="synset" action="search" params="${[q:baseform]}">${term}: ${baseform}</g:link> -
                </g:else>
                <g:link controller="synset" action="create" params="${[term:baseform]}"><g:message code="missingwords.result.add"/></g:link>
            </li>
          </g:each>
        </ul>
          
    </body>
</html>
