  
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title>Edit LinkType</title>
    </head>
    <body>
        <div class="nav">
            <span class="menuButton"><a class="home" href="/">Home</a></span>
            <span class="menuButton"><g:link class="list" action="list">LinkType List</g:link></span>
            <span class="menuButton"><g:link class="create" action="create">New LinkType</g:link></span>
        </div>
        <div class="body">
            <h1>Edit LinkType</h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${linkType}">
            <div class="errors">
                <g:renderErrors bean="${linkType}" as="list" />
            </div>
            </g:hasErrors>
            <g:form controller="linkType" method="post" >
                <input type="hidden" name="id" value="${linkType?.id}" />
                <div class="dialog">
                    <table>
                        <tbody>
                        
                            <tr class='prop'>
                                <td valign='top' class='name'>
                                    <label for='linkName'>Link Name:</label>
                                </td>
                                <td valign='top' class='value ${hasErrors(bean:linkType,field:'linkName','errors')}'>
                                    <input type="text" id='linkName' name='linkName' value="${fieldValue(bean:linkType,field:'linkName')}"/>
                                </td>
                            </tr> 
                        
                            <tr class='prop'>
                                <td valign='top' class='name'>
                                    <label for='verbName'>Verb Name:</label>
                                </td>
                                <td valign='top' class='value ${hasErrors(bean:linkType,field:'verbName','errors')}'>
                                    <input type="text" id='verbName' name='verbName' value="${fieldValue(bean:linkType,field:'verbName')}"/>
                                </td>
                            </tr> 

                            <tr class='prop'>
                                <td valign='top' class='name'>
                                    <label for='otherDirectionLinkName'>Other Direction Link Name:</label>
                                </td>
                                <td valign='top' class='value ${hasErrors(bean:linkType,field:'otherDirectionLinkName','errors')}'>
                                    <input type="text" id='otherDirectionLinkName' name='otherDirectionLinkName' value="${fieldValue(bean:linkType,field:'otherDirectionLinkName')}"/>
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
