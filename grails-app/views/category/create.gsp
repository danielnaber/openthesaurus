<%@page import="com.vionto.vithesaurus.*" %>  
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title>Create Category</title>         
    </head>
    <body>
        <div class="nav">
            <span class="menuButton"><a class="home" href="${createLinkTo(dir:'')}">Home</a></span>
            <span class="menuButton"><g:link class="list" action="list">Category List</g:link></span>
        </div>
        <div class="body">
            <h1>Create Category</h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${category}">
            <div class="errors">
                <g:renderErrors bean="${category}" as="list" />
            </div>
            </g:hasErrors>
            <g:form action="save" method="post" >
                <div class="dialog">
                    <table>
                        <tbody>
                        
                            <tr class='prop'>
                                <td valign='top' class='name'>
                                    <label for='categoryName'>Category Name:</label>
                                </td>
                                <td valign='top' class='value ${hasErrors(bean:category,field:'categoryName','errors')}'>
                                    <input type="text" id='categoryName' name='categoryName' value="${fieldValue(bean:category,field:'categoryName')}"/>
                                </td>
                            </tr> 
                        
                            <!-- 
                            <tr class='prop'>
                                <td valign='top' class='name'>
                                    <label for='uri'>Uri:</label>
                                </td>
                                <td valign='top' class='value ${hasErrors(bean:category,field:'uri','errors')}'>
                                    <input type="text" id='uri' name='uri' value="${fieldValue(bean:category,field:'uri')}"/>
                                </td>
                            </tr>
                             --> 
                        
                            <!-- 
                            <tr class='prop'>
                                <td valign='top' class='name'>
                                    <label for='nameTranslation'>Name Translation:</label>
                                </td>
                                <td valign='top' class='value ${hasErrors(bean:category,field:'nameTranslation','errors')}'>
                                    
                                </td>
                            </tr>
                             --> 
                        
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
