  
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title>Show LinkType</title>
    </head>
    <body>
        <div class="nav">
            <span class="menuButton"><a class="home" href="/">Home</a></span>
            <span class="menuButton"><g:link class="list" action="list">LinkType List</g:link></span>
            <span class="menuButton"><g:link class="create" action="create">New LinkType</g:link></span>
        </div>
        <div class="body">
            <h1>Show LinkType</h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <div class="dialog">
                <table>
                    <tbody>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Id:</td>
                            
                            <td valign="top" class="value">${linkType.id}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Link Name:</td>
                            
                            <td valign="top" class="value">${linkType.linkName}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Verb Name:</td>
                            
                            <td valign="top" class="value">${linkType.verbName}</td>
                            
                        </tr>

                        <tr class="prop">
                            <td valign="top" class="name">Other Direction Link Name:</td>
                            
                            <td valign="top" class="value">${linkType.otherDirectionLinkName}</td>
                            
                        </tr>
                    
                    </tbody>
                </table>
            </div>
            <div class="buttons">
                <g:form controller="linkType">
                    <input type="hidden" name="id" value="${linkType?.id}" />
                    <span class="button"><g:actionSubmit class="edit" value="Edit" /></span>
                    <span class="button"><g:actionSubmit class="delete" onclick="return confirm('Are you sure?');" value="Delete" /></span>
                </g:form>
            </div>
        </div>
    </body>
</html>
