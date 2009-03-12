  
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title>Import Complex Concepts</title>
    </head>
    <body>

        <div class="body">

            <h1>Import Complex Concepts</h1>

            <g:if test="${flash.message}">
                <div class="message">${flash.message}</div>
            </g:if>
            
            <g:form controller="importConcepts" method="post">
                    <table>
                        <tbody>
                            <tr class='prop'>
                                <td valign='top' class='name'>
                                    <label>Text input file:</label>
                                </td>
                                <td valign='top'>
                                    <input type="text" name='file' value=""/>
                                </td>
                            </tr> 
                            <tr class='prop'>
                                <td valign='top' class='name'>
                                    <label>Text ouput file (optional):</label>
                                </td>
                                <td valign='top'>
                                    <input type="text" name='outfile' value=""/>
                                </td>
                            </tr> 
                        </tbody>
                    </table>
                <span class="button"><g:actionSubmit action="run"
                    value="Import" /></span>
            </g:form>
            
        </div>

    </body>
</html>
