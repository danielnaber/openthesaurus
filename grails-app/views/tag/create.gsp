<%@ page import="com.vionto.vithesaurus.Tag" %>
<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main">
		<title>Create Tag</title>
	</head>
	<body>

		<div class="nav">
			<span class="menuButton"><g:link class="create" action="list">All tags</g:link></span>
		</div>

		<hr/>

		<h2>Create Tag</h2>

		<div id="create-tag" class="content scaffold-create" role="main">
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
			<g:form action="save" >
				<fieldset class="form">
					<g:render template="form"/>
				</fieldset>
				<fieldset class="buttons">
					<g:submitButton name="create" class="save" value="${message(code: 'default.button.create.label', default: 'Create')}" />
				</fieldset>
			</g:form>
		</div>

	</body>
</html>
