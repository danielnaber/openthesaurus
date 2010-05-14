<html>
    <head>
        <title>Potentially Missing Synonyms - vithesaurus</title>
        <meta name="layout" content="main" />
    </head>
    <body>

		<div class="body">

		<h1>Potentially missing synonyms</h1>

        <ul>
          <g:each in="${unknownTerms}" var="term">
            <li><g:link controller="synset" action="create" params="${[term:term]}">${term}</g:link></li>
          </g:each>
        </ul>
          
        </div>

    </body>
</html>
