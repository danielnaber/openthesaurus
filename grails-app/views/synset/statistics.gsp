<%@page import="com.vionto.vithesaurus.*" %>  
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title>Statistics</title>
    </head>
    <body>

        <div class="body">
            
            <h1>Statistics</h1>
            
                <table>
                    <tbody>
                    
                        <g:each in="${Section.list().sort()}" var="section">
                        	<g:if test="${Section.list().size > 1}">
	                            <tr>
	                                <td><h4>${section.encodeAsHTML()}</h4></td>
	                            </tr>
                            </g:if>
	                        <tr class="prop">
	                            <td valign="top" class="name">Concepts:</td>
	                            <td valign="top" class="value"><g:decimal number="${Synset.countByIsVisibleAndSection(true, section)}" /></td>
	                        </tr>
	
	                        <tr class="prop">
	                            <td valign="top" class="name">Terms:</td>
	                            <td valign="top" class="value"><g:decimal number="${termCount.get(section)}" /></td>
	                        </tr>
	
                                <tr class="prop">
                                    <td valign="top" class="name">Invisible Concepts:</td>
                                    <td valign="top" class="value"><g:decimal number="${Synset.countByIsVisibleAndSection(false, section)}" /></td>
                                </tr>

	                        <tr class="prop">
	                            <td valign="top" class="name">Changes in the last 7 days:</td>
	                            <td valign="top" class="value"><g:decimal number="${latestChanges.get(section)}" /></td>
	                        </tr>
                        </g:each>
                    
                    </tbody>
                </table>
            
        </div>
    </body>
</html>
