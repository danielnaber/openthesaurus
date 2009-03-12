  
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title>ConceptList Import</title>
    </head>
    <body>

        <div class="body">

            <h1>ConceptList Import</h1>

            <g:if test="${flash.message}">
                <div class="message">${flash.message}</div>
            </g:if>
            
            <g:form controller="import" method="post">
                    <table>
                        <tbody>
                            <tr class='prop'>
                                <td valign='top' class='name'>
                                    <label>ConceptList input file:</label>
                                </td>
                                <td valign='top'>
                                    <input style="width:600px" type="text" name='file' value=""/>
                                </td>
                            </tr> 
                        </tbody>
                    </table>
                <span class="button"><g:actionSubmit action="run" value="Import" /></span>
            </g:form>
            
        </div>

    </body>
</html>
