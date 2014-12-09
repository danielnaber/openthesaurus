
<%@ page import="com.vionto.vithesaurus.Tag" %>
<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main">
		<title>Show Tag</title>
	</head>
	<body>

		<div class="nav">
			<span class="menuButton"><g:link class="create" action="list">All tags</g:link></span>
		</div>

		<hr/>

		<h2>Show Tag</h2>

		<div id="show-tag" class="content scaffold-show" role="main">

			<g:if test="${flash.message}">
				<div class="message" role="status">${flash.message}</div>
			</g:if>

			<ul class="property-list">
			
				<g:if test="${tagInstance?.name}">
				<li class="fieldcontain">
					<span id="name-label" class="property-label"><g:message code="tag.name.label" default="Name" /></span>:
					<span class="property-value" aria-labelledby="name-label"><g:fieldValue bean="${tagInstance}" field="name"/></span>
				</li>
				</g:if>
			
				<g:if test="${tagInstance?.shortName}">
				<li class="fieldcontain">
					<span id="shortName-label" class="property-label"><g:message code="tag.shortName.label" default="Short Name" /></span>:
					<span class="property-value" aria-labelledby="shortName-label"><g:fieldValue bean="${tagInstance}" field="shortName"/></span>
				</li>
				</g:if>
			
				<g:if test="${tagInstance?.color}">
				<li class="fieldcontain">
					<span id="color-label" class="property-label"><g:message code="tag.color.label" default="Color" /></span>:
					<span class="property-value" aria-labelledby="color-label"><g:fieldValue bean="${tagInstance}" field="color"/></span>
					<span class="tag" style="background-color: ${tagInstance.color}">example</span>
				</li>
				</g:if>
			
			</ul>

			<g:form>
				<fieldset class="buttons">
					<g:hiddenField name="id" value="${tagInstance?.id}" />
					<g:link class="edit" action="edit" id="${tagInstance?.id}"><g:message code="default.button.edit.label" default="Edit" /></g:link>
					<g:actionSubmit class="delete" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" />
				</fieldset>
			</g:form>
		</div>
	</body>
</html>
