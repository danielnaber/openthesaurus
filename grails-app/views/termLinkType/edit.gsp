
<%@ page import="com.vionto.vithesaurus.TermLinkType" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title>Edit TermLinkType</title>
    </head>
    <body>
        <div class="nav">
            <span class="menuButton"><a class="home" href="/">Home</a></span>
            <span class="menuButton"><g:link class="list" action="list">TermLinkType List</g:link></span>
            <span class="menuButton"><g:link class="create" action="create">New TermLinkType</g:link></span>
        </div>
        <div class="body">
            <h1>Edit TermLinkType</h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${termLinkTypeInstance}">
            <div class="errors">
                <g:renderErrors bean="${termLinkTypeInstance}" as="list" />
            </div>
            </g:hasErrors>
            <g:form method="post" >
                <input type="hidden" name="id" value="${termLinkTypeInstance?.id}" />
                <div class="dialog">
                    <table>
                        <tbody>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="linkName">Link Name:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:termLinkTypeInstance,field:'linkName','errors')}">
                                    <input type="text" id="linkName" name="linkName" value="${fieldValue(bean:termLinkTypeInstance,field:'linkName')}"/>
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="verbName">Verb Name:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:termLinkTypeInstance,field:'verbName','errors')}">
                                    <input type="text" id="verbName" name="verbName" value="${fieldValue(bean:termLinkTypeInstance,field:'verbName')}"/>
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="otherDirectionLinkName">Other Direction Link Name:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:termLinkTypeInstance,field:'otherDirectionLinkName','errors')}">
                                    <input type="text" id="otherDirectionLinkName" name="otherDirectionLinkName" value="${fieldValue(bean:termLinkTypeInstance,field:'otherDirectionLinkName')}"/>
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
