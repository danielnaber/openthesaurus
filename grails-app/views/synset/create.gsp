  
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title>Create Concept</title>         
    </head>
    <body>

        <div class="body">
            <h1>Create Concept</h1>
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
                                    <label for='terms'>Terms:<br/>(one per line)</label>
                                </td>
                                <td valign='top' class='value'>
                                	<g:textArea id='terms' name='terms' value="${params.term}"/>
                                </td>
                            </tr> 

                        </tbody>
                    </table>
                </div>
                <div class="buttons">
                    <span class="button"><input class="save" type="submit" value="Search and Create"></input></span>
                </div>
            </g:form>
        </div>
    </body>
</html>
