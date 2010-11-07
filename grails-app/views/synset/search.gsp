<%@page import="com.vionto.vithesaurus.*" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <g:if test="${mobileBrowser && false}">  <%-- TODO --%>
        	<meta name="layout" content="main_mobile" />
       	</g:if>
       	<g:else>
       		<meta name="layout" content="main" />
       	</g:else>
        <title><g:message code='result.matches.for.title' args="${[params.q.encodeAsHTML()]}"/></title>

        <g:if test="${descriptionText}">
          <meta name="description" content="Gefundene Synonyme: ${descriptionText.encodeAsHTML()}..."/>
        </g:if>

    </head>
    <body>

        <table width="980">
        <tr>
          <td colspan="3">
            <hr/>
          </td>
        </tr>
        <tr>
          <td width="380">
            <h1>Ergebnisse</h1>
          </td>
          <td width="40"></td>
          <td width="380"></td>
          <td width="20"></td>
          <td width="160" rowspan="2" valign="top">
            <g:render template="/ads/resultpage"/>
          </td>
        </tr>

        <tr>
          <td valign="top">
            <table>
              <tr>
                <td>
                  <g:render template="mainmatches"/>

                  <g:set var="cleanTerm" value="${params.q.trim()}" />
                  <g:if test="${totalMatches == 0}">
                      <div style="margin-top: 10px">
                        <g:link action="create" params="[term : cleanTerm]">
                             <img src="../images/icon-add.png" alt="Add icon" />
                             <g:message code="result.create.synset" args="${[cleanTerm.encodeAsHTML()]}" />
                        </g:link>
                      </div>
                  </g:if>

                  <hr />
                  
                  <g:render template="partialmatches"/>

                  <hr style="margin-top:15px" />

                  <h2>Nicht das Richtige dabei?</h2>

                  <p class="addNewTerm">
                    <g:link action="create" params="[term : cleanTerm]">
                         <img src="../images/icon-add.png" alt="Add icon" />
                         <g:message code="result.create.synset" args="${[cleanTerm.encodeAsHTML()]}" />
                    </g:link>
                  </p>
                  
                </td>
              </tr>
            </table>
          </td>
          <td></td>
          <td valign="top">
            <table>
              <tr>
                <td>
                  <g:render template="wiktionary"/>

                  <hr style="margin-top:15px" />

                  <g:render template="wikipedia"/>

                  <g:render template="/ads/resultpage_results"/>

                  <hr style="margin-top:15px" />

                  <h2><g:message code="result.external.search" args="${[params.q.encodeAsHTML()]}"/></h2>

                  <g:render template="/external_links" model="${[q:params.q]}"/>
                  
                </td>
              </tr>
            </table>
          </td>
        </tr>
        </table>


<%--
    
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

        --%>
    
    </body>
</html>
