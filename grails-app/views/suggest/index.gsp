<html>
    <head>
        <title><g:message code="missingwords.title"/></title>
        <g:set var="preventSearchFocus" value="true" scope="request" />
        <meta name="layout" content="main" />
    </head>
    <body>

        <hr />

        <h2><g:message code="missingwords.headline"/></h2>

        <p><g:message code="missingwords.copytext"/></p>

        <g:form action="findPotentiallyMissingSynonyms">
          <textarea rows="20" cols="80" name="text" autofocus></textarea>
          <br />
          <br />
          <g:submitButton class="submitButton" name="Go" value="Suchen" />
        </g:form>
          
    </body>
</html>
