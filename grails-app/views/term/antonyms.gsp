<%@page import="com.vionto.vithesaurus.*" %>
<html>
    <head>
        <meta name="layout" content="main" />
        <title><g:message code="antonyms.title" /></title>
    </head>
    <body>

        <hr/>

        <p><g:link controller="wordList"><g:message code="word.list.backlink" /></g:link></p>

        <h2><g:message code="antonyms.headline" /> (${matchCount})</h2>

        <ul>
            <g:each in="${termLinks}" var="termLink">
                <li>
                  <g:link controller="term" action="edit" id="${termLink.term.id}">${termLink.term.encodeAsHTML()}
                      <g:render template="/ajaxSearch/metaInfo" model="${[term:termLink.term]}"/></g:link>
                  ~
                  <g:link controller="term" action="edit" id="${termLink.targetTerm.id}">${termLink.targetTerm.encodeAsHTML()}
                      <g:render template="/ajaxSearch/metaInfo" model="${[term:termLink.targetTerm]}"/></g:link>
                </li>
            </g:each>
        </ul>

        <div class="paginateButtons">
            <g:paginate total="${matchCount}"/>
        </div>

    </body>
</html>
