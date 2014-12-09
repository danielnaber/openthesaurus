<%@ page import="com.vionto.vithesaurus.Tag" %>

<div class="fieldcontain ${hasErrors(bean: tagInstance, field: 'name', 'error')} ">
	<label for="name">
		<g:message code="tag.name.label" default="Name" />
	</label>
	<g:textField name="name" value="${tagInstance?.name}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: tagInstance, field: 'shortName', 'error')} ">
	<label for="shortName">
		<g:message code="tag.shortName.label" default="Short Name" />
	</label>
	<g:textField name="shortName" value="${tagInstance?.shortName}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: tagInstance, field: 'color', 'error')} ">
	<label for="color">
		<g:message code="tag.color.label" default="Color" />
	</label>
	<input id="color" type='color' name="color" value="${tagInstance?.color}" />
	<br/><br/>
</div>
