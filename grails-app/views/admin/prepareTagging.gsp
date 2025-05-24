<%@page import="com.vionto.vithesaurus.*" %>
<html>
<head>
    <title>Tag Words - OpenThesaurus</title>
    <meta name="layout" content="main" />
    <g:render template="/taggingIncludes" model="${[readOnly: false]}"/>
</head>
<body>

<h2>Tag ${terms.size()} Words</h2>

Tag these words with: <span class="tag" style="background-color: ${newTag.getBackgroundColor()}">${newTag.name.encodeAsHTML()}</span>

<ul>
<g:each in="${termToNew}" var="entry">
    <li><g:link controller="synset" action="edit" id="${entry.key.synset.id}">${entry.key.word.encodeAsHTML()}</g:link> -&gt; <tt style="background-color: #dddddd">${entry.value.encodeAsHTML().replace(' ', '&nbsp;')}</tt></li>
</g:each>
</ul>

<br />
<g:form action="doTagging" method="post" onsubmit="return confirm('Really tag all these words? There is no undo.')">
    <input type="hidden" name="pattern" value="${pattern.encodeAsHTML()}">
    <input type="hidden" name="tags" value="${newTag.name.encodeAsHTML()}">
    <input type="submit" value="Go!">
</g:form>

</body>
</html>
