<%@ page import="com.vionto.vithesaurus.Tag" %>

<div class="dialog">
<table>
<tr>
	<td><label for="name">Name</label></td>
	<td>
		<div class="fieldcontain ${hasErrors(bean: tagInstance, field: 'name', 'error')} ">
			<g:textField name="name" value="${tagInstance?.name}"/>
		</div>
	</td>
</tr>
<tr>
	<td><label for="shortName">Short Name</label></td>
	<td>
		<div class="fieldcontain ${hasErrors(bean: tagInstance, field: 'shortName', 'error')} ">
			<g:textField name="shortName" value="${tagInstance?.shortName}"/>
		</div>
	</td>
</tr>
<tr>
	<td><label for="color">Color</label></td>
	<td>
		<div class="fieldcontain ${hasErrors(bean: tagInstance, field: 'color', 'error')} ">
			<input id="color" type='color' name="color" value="${tagInstance?.color}" />
			<br/><br/>
		</div>
	</td>
</tr>
</table>
</div>
