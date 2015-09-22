<%@ page import="com.vionto.vithesaurus.Tag" %>
<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main">
		<title>Edit Tag</title>
	</head>
	<body>

		<div class="nav">
			<span class="menuButton"><g:link class="create" action="detailList">All tags</g:link></span>
		</div>

		<hr/>

		<h2>Edit Tag</h2>

		<div id="edit-tag" class="content scaffold-edit" role="main">

			<g:if test="${flash.message}">
				<div class="message" role="status">${flash.message}</div>
			</g:if>

			<g:hasErrors bean="${tagInstance}">
			<ul class="errors" role="alert">
				<g:eachError bean="${tagInstance}" var="error">
				<li <g:if test="${error in org.springframework.validation.FieldError}">data-field-id="${error.field}"</g:if>><g:message error="${error}"/></li>
				</g:eachError>
			</ul>
			</g:hasErrors>
			<g:form method="post" >
				<g:hiddenField name="id" value="${tagInstance?.id}" />
				<g:hiddenField name="version" value="${tagInstance?.version}" />
				<fieldset class="form">
					<g:render template="form"/>
				</fieldset>
				<fieldset class="buttons">
					<g:actionSubmit class="save" action="update" value="${message(code: 'default.button.update.label', default: 'Update')}" />
					<!--this might mess up the data structure, tags should be hidden instead: 
					<g:actionSubmit class="delete" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" formnovalidate="" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" />
					-->
				</fieldset>
			</g:form>
		</div>
	</body>
</html>
