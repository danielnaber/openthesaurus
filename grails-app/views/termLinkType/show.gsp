
<%@ page import="com.vionto.vithesaurus.TermLinkType" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title>Show TermLinkType</title>
    </head>
    <body>
        <div class="nav">
            <span class="menuButton"><a class="home" href="/">Home</a></span>
            <span class="menuButton"><g:link class="list" action="list">TermLinkType List</g:link></span>
            <span class="menuButton"><g:link class="create" action="create">New TermLinkType</g:link></span>
        </div>
        <div class="body">
            <h1>Show TermLinkType</h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <div class="dialog">
                <table>
                    <tbody>

                    
                        <tr class="prop">
                            <td valign="top" class="name">Id:</td>
                            
                            <td valign="top" class="value">${fieldValue(bean:termLinkTypeInstance, field:'id')}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Link Name:</td>
                            
                            <td valign="top" class="value">${fieldValue(bean:termLinkTypeInstance, field:'linkName')}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Verb Name:</td>
                            
                            <td valign="top" class="value">${fieldValue(bean:termLinkTypeInstance, field:'verbName')}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Other Direction Link Name:</td>
                            
                            <td valign="top" class="value">${fieldValue(bean:termLinkTypeInstance, field:'otherDirectionLinkName')}</td>
                            
                        </tr>
                    
                    </tbody>
                </table>
            </div>
            <div class="buttons">
                <g:form>
                    <input type="hidden" name="id" value="${termLinkTypeInstance?.id}" />
                    <span class="button"><g:actionSubmit class="edit" value="Edit" /></span>
                    <span class="button"><g:actionSubmit class="delete" onclick="return confirm('Are you sure?');" value="Delete" /></span>
                </g:form>
            </div>
        </div>
    </body>
</html>
