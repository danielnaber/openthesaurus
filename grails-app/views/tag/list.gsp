
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

			<div style="line-height: 20px;">
				<g:each in="${tags}" status="i" var="tag">
					<g:set var="count" value="${nameToCount.get(tag.name)}"/>
					<g:if test="${count}">
						<span class="tag" style="background-color: ${tag.getBackgroundColor()}">${tag.name.encodeAsHTML()} (${count})</span>
					</g:if>
				</g:each>
			</div>
		</div>
	</div>
	</body>
</html>
