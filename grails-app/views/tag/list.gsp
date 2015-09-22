
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

			<div style="line-height: 24px;">
                <g:set var="tagLimitIfSearch" value="${taggedTerms ? 15 : Integer.MAX_VALUE}"/>
                <g:if test="${tagLimitIfSearch == Integer.MAX_VALUE}">
                    <span id="moreTags">
                </g:if>
				<g:each in="${tagToCount}" var="item" status="i">
                    <g:set var="showTag" value="${(!item.key.isInternal() || session.user) && item.key.isVisible()}"/>
                    <g:set var="count" value="${item.value}"/>
					<g:if test="${showTag && count > 0}">
						<g:set var="tag" value="${item.key}"/>
						<g:set var="titleAttr" value="${tag.isInternal() ? message(code:'tag.internal.tooltip') : message(code:'')}"/>
						<g:if test="${params.tag == tag.name}">
							<span class="tag selectedTag" title="${titleAttr}"
									style="background-color: ${tag.getBackgroundColor()}">${tag.name.encodeAsHTML().replace(' ', '&nbsp;')}&nbsp;(${count})</span>
						</g:if>
						<g:else>
							<g:link params="${[tag:tag.name]}"><span class="tag" title="${titleAttr}"
									style="background-color: ${tag.getBackgroundColor()}">${tag.name.encodeAsHTML().replace(' ', '&nbsp;')}&nbsp;(${count})</span></g:link>
						</g:else>
					</g:if>
                    <g:if test="${i == tagLimitIfSearch}">
                        <span id="moreTagsLink"><a href="#" onclick="$('#moreTags').show();$('#moreTagsLink').hide()"><g:message code="tag.more.tags"/></a></span>
                        <span id="moreTags" style="display: none">
                    </g:if>
				</g:each>
            </div>
			</span><!-- end id=moreTags -->

			<g:if test="${taggedTerms}">
				<h2><g:message code="tag.found" args="${[params.tag]}"/></h2>

				<ul>
					<g:each in="${taggedTerms}" var="term">
						<li><g:link controller="synset" action="edit" id="${term.synset.id}">${term.encodeAsHTML()}
                            <g:render template="/ajaxSearch/metaInfo" model="${[term:term]}"/></g:link></li>
					</g:each>
				</ul>
			</g:if>

		</div>
	</div>
	</body>
</html>
