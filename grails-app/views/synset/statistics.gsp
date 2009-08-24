<%@page import="com.vionto.vithesaurus.*" %>  
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title><g:message code="statistics.title" /></title>
    </head>
    <body>

        <div class="body">
            
			<table style="width:60%">
			<tr>
				<td>

		            <h1><g:message code="statistics.headline" /></h1>

					<table>
                       <g:each in="${Section.list().sort()}" var="section">

                       	<g:if test="${Section.list().size > 1}">
                            <tr>
                                <td><h4>${section.encodeAsHTML()}</h4></td>
                            </tr>
                        </g:if>

                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="statistics.synsets" /></td>
                            <td valign="top" class="value"><g:decimal number="${Synset.countByIsVisibleAndSection(true, section)}" /></td>
                        </tr>

                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="statistics.terms" /></td>
                            <td valign="top" class="value"><g:decimal number="${termCount.get(section)}" /></td>
                        </tr>

						<!-- 	
                           <tr class="prop">
                               <td valign="top" class="name"><g:message code="statistics.invisible_synsets" /></td>
                               <td valign="top" class="value"><g:decimal number="${Synset.countByIsVisibleAndSection(false, section)}" /></td>
                           </tr>
                           -->

                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="statistics.changes_last_7_days" /></td>
                            <td valign="top" class="value"><g:decimal number="${latestChanges.get(section)}" /></td>
                        </tr>
                       </g:each>
	                </table>
				</td>
				
				<td>
				
					<h1><g:message code="statistics.top.users" /></h1>
					
					<table>
					<g:each in="${topUsers}" var="topUser">
					<tr>
						<td>
							<g:if test="${topUser.displayName}">
								${topUser.displayName}
							</g:if>
							<g:else>
								<span class="metaInfo"><g:message code="statistics.anonymous.user" /></span>
							</g:else>
						</td>
						<td>${topUser.actions}</td>
					</tr>
					</g:each>
					</table>
				</td>
			</tr>
			</table>
						
            
        <g:render template="/ads/statistics_bottom"/>
        
        </div>
    </body>
</html>
