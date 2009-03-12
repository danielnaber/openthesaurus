<%@page import="com.vionto.vithesaurus.*" %>  
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title>Edit Category</title>
    </head>
    <body>
        <div class="nav">
            <span class="menuButton"><a class="home" href="${createLinkTo(dir:'')}">Home</a></span>
            <span class="menuButton"><g:link class="list" action="list">Category List</g:link></span>
            <span class="menuButton"><g:link class="create" action="create">New Category</g:link></span>
        </div>
        <div class="body">
            <h1>Edit Category</h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${category}">
            <div class="errors">
                <g:renderErrors bean="${category}" as="list" />
            </div>
            </g:hasErrors>
            <g:form controller="category" method="post" >
                <input type="hidden" name="id" value="${category?.id}" />
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
                            
                            <tr class='prop'>
                                <td valign='top' class='name'>
                                    <label for='uri'>Uri:</label>
                                </td>
                                <td valign='top' class='value ${hasErrors(bean:category,field:'uri','errors')}'>
                                    <input type="text" id='uri' name='uri' value="${fieldValue(bean:category,field:'uri')}"/>
                                </td>
                            </tr>

                            <tr class='prop'>
                                <td valign='top' class='name'>
                                    <label for='isDisabled'>Is Disabled:</label>
                                </td>
                                <td valign='top' class='value ${hasErrors(bean:category,field:'isDisabled','errors')}'>
                                    <g:checkBox name="isDisabled" value="${category.isDisabled || category.isDisabled == null}"/>
                                </td>
                            </tr>

                            <tr class='prop'>
                                <td valign='top' class='name'>
                                    <label for='isDisabled'>From Large Category Set:</label>
                                </td>
                                <td valign='top' class='value ${hasErrors(bean:category,field:'isOriginal','errors')}'>
                                    <g:checkBox name="isOriginal" value="${category.isOriginal || category.isOriginal == null}"/>
                                </td>
                            </tr>
                            
                            <tr class='prop'>
                                <td valign='top' class='name'>
                                    <label for='isDisabled'>Category Type:</label>
                                </td>
                                <td valign='top' class='value ${hasErrors(bean:category,field:'isDisabled','errors')}'>
								    <g:select name="categoryType.id" from="${Category.findAllByIsOriginal(false).sort()}" optionKey="id"
								        value="${category.categoryType?.id}" optionValue="${detailedString}"
								        noSelection="['null':'(none)']" style="width:120px" />
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
