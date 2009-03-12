<%@ page import="com.vionto.vithesaurus.SemType" %>  
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title>Edit SemType</title>
    </head>
    <body>
        <div class="nav">
            <span class="menuButton"><a class="home" href="${createLinkTo(dir:'')}">Home</a></span>
            <span class="menuButton"><g:link class="list" action="list">SemType List</g:link></span>
            <span class="menuButton"><g:link class="create" action="create">New SemType</g:link></span>
        </div>
        <div class="body">
            <h1>Edit SemType</h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${semType}">
            <div class="errors">
                <g:renderErrors bean="${semType}" as="list" />
            </div>
            </g:hasErrors>
            <g:form controller="semType" method="post" >
                <input type="hidden" name="id" value="${semType?.id}" />
                <div class="dialog">
                    <table>
                        <tbody>
                        
                            <tr class='prop'>
                                <td valign='top' class='name'>
                                    <label for='semType'>Sem Type:</label>
                                </td>
                                <td valign='top' class='value ${hasErrors(bean:semType,field:'semType','errors')}'>
                                    <input type="text" id='semType' name='semType' value="${fieldValue(bean:semType,field:'semType')}"/>
                                </td>
                            </tr> 
                        
                            <tr class='prop'>
                                <td valign='top' class='name'>
                                    <label for='categoryType'>Category Type:</label>
                                </td>
                                <td valign='top' class='value ${hasErrors(bean:semType,field:'categoryType','errors')}'>
                                    <input type="text" id='categoryType' name='categoryType' value="${fieldValue(bean:semType,field:'categoryType')}"/>
                                </td>
                            </tr> 
                        
                            <tr class='prop'>
                                <td valign='top' class='name'>
                                    <label for='categoryTypeID'>Category Type ID:</label>
                                </td>
                                <td valign='top' class='value ${hasErrors(bean:semType,field:'categoryTypeID','errors')}'>
                                    <input type='text' id='categoryTypeID' name='categoryTypeID' value="${fieldValue(bean:semType,field:'categoryTypeID')}" />
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
