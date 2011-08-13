<html>
    <head>
        <title>Unbekannte Wörter - OpenThesaurus</title>
        <meta name="layout" content="main" />
    </head>
    <body>

        <hr />

        <h2>Unbekannte Wörter</h2>

        <ul>
          <g:each in="${unknownTerms}" var="term">
            <li>
                <g:link controller="synset" action="search" params="${[q:term]}">${term}</g:link> -
                <g:link controller="synset" action="create" params="${[term:term]}">(add)</g:link>
            </li>
          </g:each>
        </ul>
          
        </div>

    </body>
</html>
