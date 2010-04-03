<%@page import="com.vionto.vithesaurus.*" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <g:if test="${mobileBrowser}">
        	<meta name="layout" content="main_mobile" />
       	</g:if>
       	<g:else>
       		<meta name="layout" content="main" />
       	</g:else>
        <title><g:message code='result.matches.for.title' args="${[params.q.encodeAsHTML()]}"/></title>
    </head>
    <body>

        <div class="body">

			<g:if test="${!mobileBrowser}">
				<div style="float:right">
					<g:render template="/ads/resultpage"/>
				</div>
			</g:if>

            <g:if test="${flash.message}">
                <div class="message">${flash.message}</div>
            </g:if>

            <h2 style="margin-top:5px"><g:message code='result.matches.for' args="${[params.q.encodeAsHTML()]}"/></h2>

            <g:set var="cleanTerm" value="${params.q.trim()}" />
            
			<g:if test="${mobileBrowser}">
				<div style="width:100%">
	            <ul>
		           <g:render template="mainmatches"/>
	            </ul>
				</div>
          	</g:if>
          	<g:else>
				<div class="maxwidth">
	            <ul>
		            <g:render template="mainmatches"/>
	            </ul>
				</div>

				<g:if test="${totalMatches == 0}">
	                <g:link action="create" params="[term : cleanTerm]">
	                     <img src="../images/skin/database_add.png" alt="Add icon" />
	                     <g:message code="result.create.synset" args="${[cleanTerm.encodeAsHTML()]}" />
	                </g:link>
				</g:if>				
				
          		<g:render template="/ads/resultpage_results"/>
          	</g:else>

			<g:if test="${mobileBrowser}">

                    <div>&nbsp;</div>
					<g:render template="partialmatches"/>
					<g:render template="similarmatches"/>

                    <div>&nbsp;</div>
					<g:render template="wikipedia"/>
					<g:render template="wiktionary"/>

					<h2><g:message code="result.external.search" args="${[params.q.encodeAsHTML()]}"/></h2>
		            <g:render template="/external_links" model="${[q:params.q]}"/>
		            <br/>

		            <p>
                        <g:set var="cleanTerm" value="${params.q.trim()}" />
                        <g:link action="create" params="[term : cleanTerm]">
                            <img src="../images/skin/database_add.png" alt="Add icon" />
                            <g:message code="result.create.synset" args="${[cleanTerm.encodeAsHTML()]}" />
                        </g:link>
		            </p>
						
                    <div style="float:right">
                        <g:render template="/ads/resultpage"/>
                    </div>

			</g:if>
			<g:else>

				<table class="invisibletable" width="100%">
				<tr>
					<td width="40%">
						<g:render template="partialmatches"/>
						<g:render template="similarmatches"/>
	
						<h2><g:message code="result.external.search" args="${[params.q.encodeAsHTML()]}"/></h2>
			            <g:render template="/external_links" model="${[q:params.q]}"/>
			            <br/>
	
			            <table style="margin:0;padding: 0">
                          <tr>
                            <td style="margin:0;padding: 0">
                              <g:link action="create" params="[term : cleanTerm]">
                                  <img src="../images/skin/database_add.png" alt="Add icon" />
                              </g:link>
                            </td>
                            <td style="margin:0;padding: 0 0 0 6px">
                              <g:link action="create" params="[term : cleanTerm]">
                                  <g:message code="result.create.synset" args="${[cleanTerm.encodeAsHTML()]}" />
                              </g:link>
                            </td>
                          </tr>
			            </table>
						
					<td></td>
					<td width="60%">
                        <div class="maxwidth">
						  <g:render template="wikipedia"/>
  						  <g:render template="wiktionary"/>
                        </div>
					</td>
				</tr>
				</table>

			</g:else>
			
			<g:render template="/ads/resultpage_bottom"/>
			
        </div>
    </body>
</html>
