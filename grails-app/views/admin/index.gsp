<%@page import="com.vionto.vithesaurus.*" %>
<html>
    <head>
        <title>OpenThesaurus - admin page</title>
        <meta name="layout" content="main" />
    </head>
    <body>

        <hr/>
          
        <h2>Admin Page</h2>

        <p>
        Manage:
        <g:link controller="tag">Tags</g:link> |
        <g:link controller="test">Simple self-test</g:link> |
        <g:link controller="user" action="list">Users</g:link> |
        <g:link controller="language" action="list">Languages</g:link> |
        <g:link controller="category" action="list">Categories</g:link> |
        <g:link controller="termLevel" action="list">Term Level</g:link> |
        <g:link controller="linkType" action="list">Synset Link Types</g:link> |
        <g:link controller="termLinkType" action="list">Term Link Types</g:link> |
        <g:link controller="wordGrammar" action="list">Grammar Forms</g:link> |
        <g:link controller="thesaurusConfigurationEntry" action="list">Configuration</g:link> |
        <g:link controller="synset" action="createMemoryDatabase">createMemoryDatabase</g:link>
        </p>

        <p>Import:
        <g:link controller="suggest" action="index">Find words without synonyms</g:link> |
        Export:
        <g:link controller="exportOxt" action="run">Export OXT (slow for large data sets)</g:link> |
        <g:link controller="exportText" action="run">Export text</g:link> 
        </p>

        <p>Lists:
        <g:link controller="check" action="listInvisibleSynsets">Invisible synsets</g:link>
        <br/>
        Term Checks:
        <g:link controller="check" action="listHomonyms" params="['section.id': 0]">Homonyms</g:link>
        <br/>
        Sanity checks:
        <g:link controller="admin" action="checkNormalizedTermIntegrity">Normalized term integrity</g:link>
        </p>

		<h2 style="margin-top:25px">Latest ${resultLimit} User subscription of ${ThesaurusUser.count()} users</h2>

        <div class="colspanlist">
          <table>
          <thead>
              <tr>
                  <th>Email</th>
                  <th>Perm</th>
                  <th>Registration</th>
                  <th>Confirm</th>
                  <th>Last Login</th>
                  <th>Events</th>
                  <th>Blocked</th>
              </tr>
          </thead>
          <g:each in="${latestUsers}" status="i" var="user">
              <tr>
                  <td valign="top">
                    <a style="font-weight: normal" href="mailto:${user.userId.encodeAsURL()}">${user.userId.encodeAsHTML()}</a><br/>
                    ${user.realName?.encodeAsHTML()}
                  </td>
                  <td valign="top">${user.permission?.encodeAsHTML()}</td>
                  <td valign="top"><g:formatDate format="yyyy-MM-dd" date="${user.creationDate}"/> <span class="metaInfo"><g:formatDate format="HH:mm" date="${user.creationDate}"/></span></td>
                  <td valign="top"><g:formatDate format="yyyy-MM-dd" date="${user.confirmationDate}"/> <span class="metaInfo"><g:formatDate format="HH:mm" date="${user.confirmationDate}"/></span></td>
                  <td valign="top"><g:formatDate format="yyyy-MM-dd" date="${user.lastLoginDate}"/> <span class="metaInfo"><g:formatDate format="HH:mm" date="${user.lastLoginDate}"/></span></td>
                  <td valign="top" align="right"><g:link controller="userEvent" action="list" params="${[uid:user.id]}">${UserEvent.countByByUser(user)}</g:link></td>
                  <td valign="top">${user.blocked ? "yes" : ""}</td>
              </tr>
          </g:each>
          <tr>
            <td colspan="5"><g:link controller="user" action="list" params="${[sort: 'creationDate', order: 'desc']}">Show more</g:link></td>
          </tr>
          </table>
        </div>
		
    </body>
</html>
