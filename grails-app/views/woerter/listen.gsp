<%@page import="com.vionto.vithesaurus.*" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title><g:message code="wordlists.title" /></title>
    </head>
    <body>

            <hr />

            <h2><g:message code="wordlists.head" /></h2>

            <ul>
              <%-- FIXME
              <li><g:link controller="term" action="list"><g:message code="a_to_z"/></g:link></li>
              --%>
              <li><g:link controller="synset" action="variation" id="at"><g:message code="austrian.words"/></g:link></li>
              <li><g:link controller="synset" action="variation" id="ch"><g:message code="swiss.words"/></g:link></li>
              <li><g:link controller="tree" action="index"><g:message code="tree.headline"/></g:link></li>
              <li><g:link controller="random" action="synsets"><g:message code="random.headline"/></g:link></li>
              <li><g:link controller="association" action="list"><g:message code="association.headline"/></g:link></li>
              <li style="margin-top:14px">Wörter nach Sprachniveau:
              <ul style="margin-top:0px">
                <g:each in="${TermLevel.list()}" var="level">
                  <li><g:link controller="term" action="list" params="${[levelId:level.id]}">${level.encodeAsHTML()}</g:link></li>
                </g:each>
              </ul>
              </li>
              <li style="margin-top:14px">Wörter nach Kategorie:
              <ul style="margin-top:0px">
                <g:each in="${Category.withCriteria { eq('isDisabled', false) }.sort()}" var="category">
                  <li><g:link controller="term" action="list" params="${[categoryId:category.id]}">${category.encodeAsHTML()}</g:link></li>
                </g:each>
              </ul>
              </li>
            </ul>

    </body>
</html>
