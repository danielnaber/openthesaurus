  
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title>Show UserEvent</title>
    </head>
    <body>
        <div class="nav">
            <span class="menuButton"><a class="home" href="${createLinkTo(dir:'')}">Home</a></span>
            <span class="menuButton"><g:link class="list" action="list">UserEvent List</g:link></span>
        </div>
        <div class="body">
            <h1>Show UserEvent</h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <div class="dialog">
                <table>
                    <tbody>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Id:</td>
                            
                            <td valign="top" class="value">${userEvent.id}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Other Synset:</td>
                            
                            <td valign="top" class="value"><g:link controller="synset" action="show" id="${userEvent?.otherSynset?.id}">${userEvent?.otherSynset}</g:link></td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">By User:</td>
                            
                            <td valign="top" class="value"><g:link controller="user" action="show" id="${userEvent?.byUser?.id}">${userEvent?.byUser}</g:link></td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Ip Address:</td>
                            
                            <td valign="top" class="value">${userEvent.ipAddress}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Change Desc:</td>
                            
                            <td valign="top" class="value">${userEvent.changeDesc}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Creation Date:</td>
                            
                            <td valign="top" class="value">${userEvent.creationDate}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Event Type:</td>
                            
                            <td valign="top" class="value">${userEvent.eventType}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Synset:</td>
                            
                            <td valign="top" class="value"><g:link controller="synset" action="show" id="${userEvent?.synset?.id}">${userEvent?.synset}</g:link></td>
                            
                        </tr>
                    
                    </tbody>
                </table>
            </div>
            <div class="buttons">
                <g:form controller="userEvent">
                    <input type="hidden" name="id" value="${userEvent?.id}" />
                    <span class="button"><g:actionSubmit class="edit" value="Edit" /></span>
                </g:form>
            </div>
        </div>
    </body>
</html>
