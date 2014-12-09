
<%@ page import="com.vionto.vithesaurus.Tag" %>
<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main">
		<title>List all Tags</title>
	</head>
	<body>
	<div class="body">

		<div class="nav">
			<span class="menuButton"><a class="home" href="${createLinkTo(dir:'')}">Home</a></span> &middot;
			<span class="menuButton"><g:link class="create" action="create">New Tag</g:link></span>
		</div>

		<hr/>

		<h2>List all Tags</h2>

		<div id="list-tag" class="content scaffold-list" role="main">

			<g:if test="${flash.message}">
				<div class="message" role="status">${flash.message}</div>
			</g:if>

			<div class="colspanlist">
			<table>
				<thead>
					<tr>
						<g:sortableColumn property="name" title="${message(code: 'tag.name.label', default: 'Name')}" />
						<g:sortableColumn property="shortName" title="${message(code: 'tag.shortName.label', default: 'Short Name')}" />
						<g:sortableColumn property="color" title="${message(code: 'tag.color.label', default: 'Color')}" />
						<g:sortableColumn property="color" title="${message(code: 'tag.color.label', default: 'Created')}" />
						<g:sortableColumn property="color" title="${message(code: 'tag.color.label', default: 'Created By')}" />
					</tr>
				</thead>
				<tbody>
				<g:each in="${tagInstanceList}" status="i" var="tagInstance">
					<tr class="${(i % 2) == 0 ? 'even' : 'odd'}">
						<td><g:link action="show" id="${tagInstance.id}">${fieldValue(bean: tagInstance, field: "name")}</g:link></td>
						<td>
							<span class="tag" style="background-color: ${fieldValue(bean: tagInstance, field: "color")}">${fieldValue(bean: tagInstance, field: "shortName")}</span>
						</td>
						<td>${fieldValue(bean: tagInstance, field: "color")}</td>
						<td><g:formatDate date="${tagInstance.created}"/></td>
						<td>${fieldValue(bean: tagInstance, field: "createdBy")}</td>
					</tr>
				</g:each>
				</tbody>
			</table>
			</div>
			<div class="pagination">
				<g:paginate total="${tagInstanceTotal}" />
			</div>
		</div>
	</div>
	</body>
</html>
