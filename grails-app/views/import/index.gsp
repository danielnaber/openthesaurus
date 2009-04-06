  
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title>Import data from PHP version of OpenThesaurus</title>
    </head>
    <body>

        <div class="body">

            <h1>Import data from PHP version of OpenThesaurus</h1>

            <g:if test="${flash.message}">
                <div class="message">${flash.message}</div>
            </g:if>
            
            <p>Please specify the source of the data. The content from this
            database will be imported into the database configured in
            <code>datasource.properties</code> <strong>overwriting
            all existing data</strong>.</p>
            
            <g:form controller="import" method="post">
                    <table>
                        <tbody>
                            <tr class='prop'>
                                <td valign='top' class='name'>
                                    <label>Database URL:</label>
                                </td>
                                <td valign='top'>
                                    <g:textField name="dbUrl"/>
                                    <br />Example: jdbc:mysql://127.0.0.1:3306/thesaurus
                                </td>
                            </tr> 
                            <tr class='prop'>
                                <td valign='top' class='name'>
                                    <label>Database Class:</label>
                                </td>
                                <td valign='top'>
                                    <g:textField name="dbClass" />
                                    <br />Example: com.mysql.jdbc.Driver
                                </td>
                            </tr> 
                            <tr class='prop'>
                                <td valign='top' class='name'>
                                    <label>Database Username:</label>
                                </td>
                                <td valign='top'>
                                    <g:textField name="dbUsername"/>
                                </td>
                            </tr> 
                            <tr class='prop'>
                                <td valign='top' class='name'>
                                    <label>Database Password:</label>
                                </td>
                                <td valign='top'>
                                    <g:textField name="dbPassword"/>
                                </td>
                            </tr> 
                        </tbody>
                    </table>
                <span class="button"><g:actionSubmit action="run" value="DELETE ALL DATA AND IMPORT" /></span>
            </g:form>
            
        </div>

    </body>
</html>
