<%@ page import="com.vionto.vithesaurus.SemType" %>  
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title>Show SemType</title>
    </head>
    <body>
        <div class="nav">
            <span class="menuButton"><a class="home" href="${createLinkTo(dir:'')}">Home</a></span>
            <span class="menuButton"><g:link class="list" action="list">SemType List</g:link></span>
            <span class="menuButton"><g:link class="create" action="create">New SemType</g:link></span>
        </div>
        <div class="body">
            <h1>Show SemType</h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <div class="dialog">
                <table>
                    <tbody>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Id:</td>
                            
                            <td valign="top" class="value">${semType.id}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Sem Type:</td>
                            
                            <td valign="top" class="value">${semType.semType}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Category Type:</td>
                            
                            <td valign="top" class="value">${semType.categoryType}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Category Type ID:</td>
                            
                            <td valign="top" class="value">${semType.categoryTypeID}</td>
                            
                        </tr>
                    
                    </tbody>
                </table>
            </div>
            <div class="buttons">
                <g:form controller="semType">
                    <input type="hidden" name="id" value="${semType?.id}" />
                    <span class="button"><g:actionSubmit class="edit" value="Edit" /></span>
                    <span class="button"><g:actionSubmit class="delete" onclick="return confirm('Are you sure?');" value="Delete" /></span>
                </g:form>
            </div>
        </div>
    </body>
</html>
