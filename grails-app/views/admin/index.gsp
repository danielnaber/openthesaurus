<html>
    <head>
        <title>vithesaurus - admin page</title>
        <meta name="layout" content="main" />
    </head>
    <body>

		<div class="body">

		<h1>Admin Page</h1>
		
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
        <g:link controller="thesaurusConfigurationEntry" action="list">Configuration</g:link><br />

        Export:
        <g:link controller="exportOxt" action="run">Export OXT (slow for large data sets)</g:link>
        <br />

        Lists:
        <g:link controller="check" action="listInvisibleSynsets">Invisible</g:link>
        <br />

        Term Checks:
        <g:link controller="check" action="listHomonyms" params="['section.id': 0]">Homonyms</g:link>

		<h2>Latest ${resultLimit} User subscription</h2>
		
		<table>
		<thead>
			<tr>
				<td>email</td>
				<td>display name</td>
				<td>registration</td>
				<td>last login</td>
			</tr>
		</thead>
		<g:each in="${latestUsers}" status="i" var="latestUser">
			<tr>
				<td>${latestUser.userId}</td>
				<td>${latestUser.realName}</td>
				<td>${latestUser.creationDate}</td>
				<td>${latestUser.lastLoginDate}</td>
			</tr>
		</g:each>
		</table>
		
        </div>

    </body>
</html>
