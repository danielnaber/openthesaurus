
<%@ page import="com.vionto.vithesaurus.Tag" %>
<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main">
		<title><g:message code="tag.title"/></title>
	</head>
	<body>
	<div class="body">

		<hr/>

		<p><g:link controller="wordList"><g:message code="word.list.backlink" /></g:link></p>

		<h2><g:message code="tag.headline"/></h2>

		<div id="list-tag" class="content scaffold-list" role="main">

			<g:if test="${flash.message}">
				<div class="message" role="status">${flash.message}</div>
			</g:if>

			<div style="line-height: 24px;">
				<g:each in="${tags}" var="tag">
					<g:set var="count" value="${nameToCount.get(tag.name)}"/>
					<g:if test="${count}">
						<g:if test="${params.tag == tag.name}">
							<span class="tag selectedTag"
									style="background-color: ${tag.getBackgroundColor()}">${tag.name.encodeAsHTML()}&nbsp;(${count})</span>
						</g:if>
						<g:else>
							<g:link params="${[tag:tag.name]}"><span class="tag"
									style="background-color: ${tag.getBackgroundColor()}">${tag.name.encodeAsHTML()}&nbsp;(${count})</span></g:link>
						</g:else>
					</g:if>
				</g:each>
			</div>

			<g:if test="${taggedTerms}">
				<h2><g:message code="tag.found" args="${[params.tag]}"/></h2>

				<ul>
					<g:each in="${taggedTerms}" var="term">
						<li><g:link controller="synset" action="edit" id="${term.synset.id}">${term.encodeAsHTML()}</g:link></li>
					</g:each>
				</ul>
			</g:if>

		</div>
	</div>
	</body>
</html>
