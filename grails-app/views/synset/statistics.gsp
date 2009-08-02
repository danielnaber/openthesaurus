<%@page import="com.vionto.vithesaurus.*" %>  
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title><g:message code="statistics.title" /></title>
    </head>
    <body>

        <div class="body">
            
            <h1><g:message code="statistics.headline" /></h1>
            
                <table>
                    <tbody>
                    
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
                    
                    </tbody>
                </table>
            
        <g:render template="/ads/statistics_bottom"/>
        
        </div>
    </body>
</html>
