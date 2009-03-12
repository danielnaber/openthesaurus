<%@page import="com.vionto.vithesaurus.*" %>  
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title>Show Category</title>
    </head>
    <body>
        <div class="nav">
            <span class="menuButton"><a class="home" href="${createLinkTo(dir:'')}">Home</a></span>
            <span class="menuButton"><g:link class="list" action="list">Category List</g:link></span>
            <span class="menuButton"><g:link class="create" action="create">New Category</g:link></span>
        </div>
        <div class="body">
            <h1>Show Category</h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <div class="dialog">
                <table>
                    <tbody>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Id:</td>
                            
                            <td valign="top" class="value">${category.id}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Category Name:</td>
                            
                            <td valign="top" class="value">${category.categoryName}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Uri:</td>
                            
                            <td valign="top" class="value">${category.uri}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Is Disabled:</td>
                            <td valign="top" class="value">${category.isDisabled || category.isDisabled == null ? "yes" : "no"}
                                <span class="metaInfo">(disabled categories cannot be used when creating new concepts)</span></td>
                        </tr>

                        <tr class="prop">
                            <td valign="top" class="name">From Large Category Set:</td>
                            <td valign="top" class="value">${category.isOriginal || category.isOriginal == null ? "yes" : "no"}
                                <span class="metaInfo">(if 'no', this category will be displayed on top in the "-source-" selection for filtering)</span></td>
                        </tr>

                        <tr class="prop">
                            <td valign="top" class="name">Category Type:</td>
                            <td valign="top" class="value">${category.categoryType}</td>
                        </tr>
                    
                    </tbody>
                </table>
            </div>
            <div class="buttons">
                <g:form controller="category">
                    <input type="hidden" name="id" value="${category?.id}" />
                    <span class="button"><g:actionSubmit class="edit" value="Edit" /></span>
                    <span class="button"><g:actionSubmit class="delete" onclick="return confirm('Are you sure?');" value="Delete" /></span>
                </g:form>
            </div>
        </div>
    </body>
</html>
