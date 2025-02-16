
<%@ page import="com.vionto.vithesaurus.Tag" %>
<%@ page import="com.vionto.vithesaurus.Term" %>
<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main">
		<title>List all Tags</title>
		<style>
			.odd {
				background-color: #eee;
			}
		</style>
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
                        <th>Usages</th>
						<g:sortableColumn property="created" title="${message(code: 'tag.color.label', default: 'Created')}" />
						<g:sortableColumn property="createdBy" title="${message(code: 'tag.color.label', default: 'Created By')}" />
						<th>Visible</th>
					</tr>
				</thead>
				<tbody>
				<g:each in="${tagInstanceList}" status="i" var="tag">
					<tr class="${(i % 2) == 0 ? 'even' : 'odd'}">
						<td>
                            <g:link action="edit" id="${tag.id}"><span class="tag" style="background-color: ${tag.backgroundColor}">${tag.name.encodeAsHTML()}</span></g:link>
						</td>
						<td>
                            <g:if test="${tag.shortName}">
                                <span class="tag" style="background-color: ${tag.backgroundColor}">${tag.shortName.encodeAsHTML()}</span>
                            </g:if>
						</td>
						<td>
							<%
							def count = Term.createCriteria().count {
								tags {
									eq('id', tag.id)
								}
								synset {
									eq('isVisible', true)
								}
							}
							%>
							<g:link controller="tag" params="${[tag: tag.name]}">${count}</g:link>
						</td>
						<td><g:formatDate format="yyyy-MM-dd HH:mm" date="${tag.created}"/></td>
						<td>${fieldValue(bean: tag, field: "createdBy")}</td>
						<td>${tag.isVisible() ? '✅' : '❌'}</td>
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
