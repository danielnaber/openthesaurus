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
        <g:link controller="csvImport" action="index">Import</g:link> |
        <g:link controller="user" action="list">Users</g:link> |
        <g:link controller="language" action="list">Languages</g:link> |
        <g:link controller="source" action="list">Sources</g:link> |
        <g:link controller="category" action="list">Categories</g:link> |
        <g:link controller="termLevel" action="list">Term Level</g:link> |
        <g:link controller="linkType" action="list">Synset Link Types</g:link> |
        <g:link controller="termLinkType" action="list">Term Link Types</g:link> |
        <g:link controller="wordGrammar" action="list">Grammar Forms</g:link> |
        <!-- <g:link controller="semType" action="list">SemTypes</g:link> | -->
        <g:link controller="section" action="list">Thesauri</g:link> |
        <g:link controller="export" action="run">Export</g:link> |
        <g:link controller="thesaurusConfigurationEntry" action="list">Configuration</g:link><br />

        Concept Checks:
        <g:link controller="synsetSuggestion" action="index">Suggestions</g:link> |
        <g:link controller="check" action="listInvisibleSynsets">Invisible</g:link> |
        <!-- <g:link controller="check" action="listHypernymSynsets">Hypernyms</g:link> | -->
        <g:link controller="check" action="listEmptySynsets">No Terms</g:link> |
        <g:link controller="check" action="listNoPreferredTermSynsets">No Preferred Terms</g:link> |
        <g:link controller="check" action="listNoCategorySynsets">No Category</g:link>
        <!-- comment out because it's too slow for the common user:
        | <g:link controller="check" action="validateSynsets">Validate Synsets</g:link>
         -->
        <br />
        Term Checks:
        <g:link controller="check" action="listUppercaseTerms">Uppercase-Only</g:link> |
        <g:link controller="check" action="listHomonyms" params="['section.id': 0]">Homonyms</g:link>

        </div>

    </body>
</html>
