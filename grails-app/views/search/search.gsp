<%@page import="com.vionto.vithesaurus.*" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
  <meta name="layout" content="main" />
  <g:set var="preventSearchFocus" value="true" scope="request" />
  <title><g:message code="powersearch.title" /></title>
  <g:render template="/taggingIncludes" model="${[readOnly: false, tagLimit: 1, placeholderText: message(code: 'powersearch.tag.placeholder')]}"/>
</head>
<body>

<hr/>

  <h2><g:message code="powersearch.headline" /></h2>

  <div style="float:left;margin-right: 35px">
    <g:render template="searchform"/>
  </div>

  <div style="float:left; max-width: 330px">
    <h2><g:message code="powersearch.results.headline" args="${[totalMatches]}" /></h2>

    <ul>
      <g:each in="${result}" var="term">
        <li><g:link controller="synset" action="edit" id="${term.synset.id}">${term.word}</g:link></li>
      </g:each>
    </ul>

    <div class="paginateButtons">
      <g:paginate maxsteps="5" max="20" total="${totalMatches}"
                  params="${[contains:params.contains, startsWith:params.startsWith, endsWith:params.endsWith, level:params.level, category:params.category, tags:params.tags]}" />
    </div>

  </div>

  <div style="clear: both"></div>

</body>
</html>
