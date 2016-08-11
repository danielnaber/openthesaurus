
<%@ page import="com.vionto.vithesaurus.Tag" %>
<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main">
		<title>Unused Tags</title>
	</head>
	<body>
	<div class="body">

		<hr/>

		<h2>Unused Tags</h2>

		<div id="list-tag" class="content scaffold-list" role="main">

			<g:if test="${flash.message}">
				<div class="message" role="status">${flash.message}</div>
			</g:if>

            <p>Tags not attached to any term:</p>

			<div style="line-height: 24px;">
                <ul>
                    <g:each in="${tagToCount}" var="tag" status="i">
						<g:if test="${Tag.findByName(tag.key).isVisible}">
							<li>${tag.key}</li>
						</g:if>
						<g:else>
							<li style="color: #888;">${tag.key} (not visible)</li>
						</g:else>
                    </g:each>
                </ul>
            </div>

		</div>
	</div>
	</body>
</html>
