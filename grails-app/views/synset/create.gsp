  
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title><g:message code="create.title"/></title>         
    </head>
    <body>

            <hr />

            <h2><g:message code="create.headline"/></h2>
            
            <g:if test="${flash.message}">
                <div class="message">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${synset}">
            <div class="errors">
                <g:renderErrors bean="${synset}" as="list" />
            </div>
            </g:hasErrors>
            <g:form action="multiSearch" method="post" >
            	
            	<input type="hidden" name="isVisible" value="true" />
            	
                <div class="dialog">
                    <table>
                        <tbody>
                        
                            <tr class='prop'>
                                <td valign='top' class='name'>
                                    <label for='terms'><g:message code="create.terms"/></label>
                                </td>
                                <td valign='top' class='value'>
                                	<g:textArea rows="5" cols="30" id='terms' name='terms' value="${params.term}\n"/>
                                </td>
                            </tr>
                            
                            <tr>
                            	<td></td>
                            	<td>
					                <div class="buttons">
					                    <span class="button"><input
					                    	class="save" type="submit" value="${message(code:'create.continue')}"/></span>
					                </div>
                            	</td>
                            </tr> 

                        </tbody>
                    </table>
                </div>
            </g:form>

    </body>
</html>
