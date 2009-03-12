<%@ page import="com.vionto.vithesaurus.Section" %>  
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title>Create Thesaurus</title>         
    </head>
    <body>
        <div class="nav">
            <span class="menuButton"><a class="home" href="${createLinkTo(dir:'')}">Home</a></span>
            <span class="menuButton"><g:link class="list" action="list">Section List</g:link></span>
        </div>
        <div class="body">
            
            <h1>Create Thesaurus</h1>
            
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${section}">
            <div class="errors">
                <g:renderErrors bean="${section}" as="list" />
            </div>
            </g:hasErrors>
            <g:form action="save" method="post" >
                <div class="dialog">
                    <table>
                        <tbody>
                        
                            <tr class='prop'>
                                <td valign='top' class='name'>
                                    <label for='sectionName'>Section Name:</label>
                                </td>
                                <td valign='top' class='value ${hasErrors(bean:section,field:'sectionName','errors')}'>
                                    <input type="text" id='sectionName' name='sectionName' value="${fieldValue(bean:section,field:'sectionName')}"/>
                                </td>
                            </tr> 

                            <tr class='prop'>
                                <td valign='top' class='name'>
                                    <label for='sectionName'>Sort priority:</label>
                                </td>
                                <td valign='top' class='value ${hasErrors(bean:section,field:'priority','errors')}'>
                                    <input type="text" id='priority' name='priority' value="${fieldValue(bean:section,field:'priority')}"/>
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
