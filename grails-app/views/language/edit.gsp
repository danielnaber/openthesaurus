  
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title>Edit Language</title>
    </head>
    <body>
        <div class="nav">
            <span class="menuButton"><a class="home" href="${createLinkTo(dir:'')}">Home</a></span>
            <span class="menuButton"><g:link class="list" action="list">Language List</g:link></span>
            <span class="menuButton"><g:link class="create" action="create">New Language</g:link></span>
        </div>
        <div class="body">
            <h1>Edit Language</h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${language}">
            <div class="errors">
                <g:renderErrors bean="${language}" as="list" />
            </div>
            </g:hasErrors>
            <g:form controller="language" method="post" >
                <input type="hidden" name="id" value="${language?.id}" />
                <div class="dialog">
                    <table>
                        <tbody>
                        
                            <tr class='prop'>
                                <td valign='top' class='name'>
                                    <label for='longForm'>Long Form:</label>
                                </td>
                                <td valign='top' class='value ${hasErrors(bean:language,field:'longForm','errors')}'>
                                    <input type="text" id='longForm' name='longForm' value="${fieldValue(bean:language,field:'longForm')}"/>
                                </td>
                            </tr> 
                        
                            <tr class='prop'>
                                <td valign='top' class='name'>
                                    <label for='shortForm'>Short Form:</label>
                                </td>
                                <td valign='top' class='value ${hasErrors(bean:language,field:'shortForm','errors')}'>
                                    <input type="text" id='shortForm' name='shortForm' value="${fieldValue(bean:language,field:'shortForm')}"/>
                                </td>
                            </tr> 
                        
                        </tbody>
                    </table>
                </div>
                <div class="buttons">
                    <span class="button"><g:actionSubmit class="save" value="Update" /></span>
                    <span class="button"><g:actionSubmit class="delete" onclick="return confirm('Are you sure?');" value="Delete" /></span>
                </div>
            </g:form>
        </div>
    </body>
</html>
