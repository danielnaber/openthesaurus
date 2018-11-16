
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
			<span class="menuButton"><a class="home" href="/">Home</a></span> &middot;
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
                        <th></th>
						<g:sortableColumn property="color" title="${message(code: 'tag.color.label', default: 'Color')}" />
						<g:sortableColumn property="created" title="${message(code: 'tag.color.label', default: 'Created')}" />
						<g:sortableColumn property="createdBy" title="${message(code: 'tag.color.label', default: 'Created By')}" />
						<g:sortableColumn property="isVisible" title="${message(code: 'tag.color.label', default: 'isVisible')}" />
					</tr>
				</thead>
				<tbody>
				<g:each in="${tagInstanceList}" status="i" var="tag">
					<tr class="${(i % 2) == 0 ? 'even' : 'odd'}">
						<td>
                            <g:link action="edit" id="${tag.id}"><span class="tag" style="background-color: ${tag.backgroundColor}">${tag.name}</span></g:link>
						</td>
						<td>
                            <g:if test="${tag.shortName}">
                                <span class="tag" style="background-color: ${tag.backgroundColor}">${tag.shortName}</span>
                            </g:if>
						</td>
                        <td><g:link controller="tag" params="${[tag: tag.name]}">List</g:link></td>
						<td>${fieldValue(bean: tag, field: "color")}</td>
						<td><g:formatDate format="yyyy-MM-dd HH:mm" date="${tag.created}"/></td>
						<td>${fieldValue(bean: tag, field: "createdBy")}</td>
						<td>${tag.isVisible()}</td>
					</tr>
				</g:each>
				</tbody>
			</table>
			</div>
		</div>
		<div class="paginateButtons">
			<g:paginate total="${tagInstanceTotal}" />
		</div>
	</div>
	</body>
</html>
