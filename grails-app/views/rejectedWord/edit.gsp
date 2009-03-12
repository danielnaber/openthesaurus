
<%@ page import="com.vionto.vithesaurus.RejectedWord" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title>Edit RejectedWord</title>
    </head>
    <body>
        <div class="nav">
            <span class="menuButton"><a class="home" href="${createLinkTo(dir:'')}">Home</a></span>
            <span class="menuButton"><g:link class="list" action="list">RejectedWord List</g:link></span>
            <span class="menuButton"><g:link class="create" action="create">New RejectedWord</g:link></span>
        </div>
        <div class="body">
            <h1>Edit RejectedWord</h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${rejectedWord}">
            <div class="errors">
                <g:renderErrors bean="${rejectedWord}" as="list" />
            </div>
            </g:hasErrors>
            <g:form controller="rejectedWord" method="post" >
                <input type="hidden" name="id" value="${rejectedWord?.id}" />
                <div class="dialog">
                    <table>
                        <tbody>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="rejectionDate">Rejection Date:</label>
                                </td>
                                <td valign="top" class="value">
                                    ${rejectedWord?.rejectionDate}
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="user">User:</label>
                                </td>
                                <td valign="top" class="value">
                                    ${rejectedWord?.user}
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="word">Word:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:rejectedWord,field:'word','errors')}">
                                    <input type="text" id="word" name="word" value="${fieldValue(bean:rejectedWord,field:'word')}"/>
                                </td>
                            </tr> 
                        
                        </tbody>
                    </table>
                </div>
                <div class="buttons">
                    <span class="button"><g:actionSubmit class="save" value="Update" /></span>
                    <span class="button"><g:actionSubmit class="delete" onclick="return confirm('Are you sure?');" 
                        action="delete" value="Unreject" /></span>
                </div>
            </g:form>
        </div>
    </body>
</html>
