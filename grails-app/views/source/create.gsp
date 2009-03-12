  
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title>Create Source</title>         
    </head>
    <body>
        <div class="nav">
            <span class="menuButton"><a class="home" href="${createLinkTo(dir:'')}">Home</a></span>
            <span class="menuButton"><g:link class="list" action="list">Source List</g:link></span>
        </div>
        <div class="body">
            <h1>Create Source</h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${source}">
            <div class="errors">
                <g:renderErrors bean="${source}" as="list" />
            </div>
            </g:hasErrors>
            <g:form action="save" method="post" >
                <div class="dialog">
                    <table>
                        <tbody>
                        
                            <tr class='prop'>
                                <td valign='top' class='name'>
                                    <label for='sourceName'>Source Name:</label>
                                </td>
                                <td valign='top' class='value ${hasErrors(bean:source,field:'sourceName','errors')}'>
                                    <input type="text" id='sourceName' name='sourceName' value="${fieldValue(bean:source,field:'sourceName')}"/>
                                </td>
                            </tr> 
                        
                            <tr class='prop'>
                                <td valign='top' class='name'>
                                    <label for='description'>Description:</label>
                                </td>
                                <td valign='top' class='value ${hasErrors(bean:source,field:'description','errors')}'>
                                    <input type="text" id='description' name='description' value="${fieldValue(bean:source,field:'description')}"/>
                                </td>
                            </tr> 
                        
                            <tr class='prop'>
                                <td valign='top' class='name'>
                                    <label for='uri'>Uri:</label>
                                </td>
                                <td valign='top' class='value ${hasErrors(bean:source,field:'uri','errors')}'>
                                    <input type="text" id='uri' name='uri' value="${fieldValue(bean:source,field:'uri')}"/>
                                </td>
                            </tr> 
                        
                        </tbody>
                    </table>
                </div>
                <div class="buttons">
                    <span class="button"><input class="save" type="submit" value="Create"></input></span>
                </div>
            </g:form>
        </div>
    </body>
</html>
