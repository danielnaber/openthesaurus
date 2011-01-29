<html>
    <head>
        <title>vithesaurus - admin page</title>
        <meta name="layout" content="main" />
    </head>
    <body>

        <hr/>
          
		<h2>Admin Page</h2>
		
        <p>
        Manage:
        <g:link controller="user" action="list">Users</g:link> |
        <g:link controller="language" action="list">Languages</g:link> |
        <g:link controller="source" action="list">Sources</g:link> |
        <g:link controller="category" action="list">Categories</g:link> |
        <g:link controller="termLevel" action="list">Term Level</g:link> |
        <g:link controller="linkType" action="list">Synset Link Types</g:link> |
        <g:link controller="termLinkType" action="list">Term Link Types</g:link> |
        <g:link controller="wordGrammar" action="list">Grammar Forms</g:link> |
        <g:link controller="section" action="list">Thesauri</g:link> |
        <g:link controller="thesaurusConfigurationEntry" action="list">Configuration</g:link></p>

        <p>Import:
        <g:link controller="suggest" action="index">Find words without synonyms</g:link> |
        Export:
        <g:link controller="exportOxt" action="run">Export OXT (slow for large data sets)</g:link> |
        <g:link controller="exportText" action="run">Export text</g:link> 
        </p>

        <p>Lists:
        <g:link controller="check" action="listInvisibleSynsets">Invisible synsets</g:link>
        </p>

        <p>Term Checks:
        <g:link controller="check" action="listHomonyms" params="['section.id': 0]">Homonyms</g:link></p>

        <p>Sanity checks:
        <g:link controller="admin" action="checkNormalizedTermIntegrity">Normalized term integrity</g:link>
        </p>

		<h2 style="margin-top:25px">Latest ${resultLimit} User subscription</h2>

        <div class="colspanlist">
          <table>
          <thead>
              <tr>
                  <th>Email</th>
                  <th>DisplayName</th>
                  <th>Permission</th>
                  <th>Registration</th>
                  <th>Last Login</th>
                  <th>Blocked</th>
              </tr>
          </thead>
          <g:each in="${latestUsers}" status="i" var="latestUser">
              <tr>
                  <td>${latestUser.userId.encodeAsHTML()}</td>
                  <td>${latestUser.realName?.encodeAsHTML()}</td>
                  <td>${latestUser.permission?.encodeAsHTML()}</td>
                  <td>${latestUser.creationDate}</td>
                  <td>${latestUser.lastLoginDate}</td>
                  <td>${latestUser.blocked ? "yes" : ""}</td>
              </tr>
          </g:each>
          <tr>
            <td colspan="5"><g:link controller="user" action="list" params="${[sort: 'creationDate', order: 'desc']}">Show more</g:link></td>
          </tr>
          </table>
        </div>
		
    </body>
</html>
