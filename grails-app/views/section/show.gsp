<%@ page import="com.vionto.vithesaurus.Section" %>  
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title>Show Thesaurus</title>
    </head>
    <body>
        <div class="nav">
            <span class="menuButton"><a class="home" href="${createLinkTo(dir:'')}">Home</a></span>
            <span class="menuButton"><g:link class="list" action="list">Thesaurus List</g:link></span>
            <span class="menuButton"><g:link class="create" action="create">New Thesaurus</g:link></span>
        </div>
        <div class="body">
            
            <h1>Show Thesaurus</h1>
            
            <g:if test="${flash.message}">
                <div class="message">${flash.message}</div>
            </g:if>
            
            <div class="dialog">
                <table>
                    <tbody>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Id:</td>
                            
                            <td valign="top" class="value">${section.id}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Section Name:</td>
                            
                            <td valign="top" class="value">${section.sectionName}</td>
                            
                        </tr>

                        <tr class="prop">
                            <td valign="top" class="name">Sort Priority:</td>
                            
                            <td valign="top" class="value">${section.priority}</td>
                            
                        </tr>
                    
                    </tbody>
                </table>
            </div>
            <div class="buttons">
                <g:form controller="section">
                    <input type="hidden" name="id" value="${section?.id}" />
                    <span class="button"><g:actionSubmit class="edit" value="Edit" /></span>
                    <span class="button"><g:actionSubmit class="delete" onclick="return confirm('Are you sure?');" value="Delete" /></span>
                </g:form>
            </div>
        </div>
    </body>
</html>
