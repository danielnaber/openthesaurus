
<%@ page import="com.vionto.vithesaurus.ThesaurusConfigurationEntry" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title>Edit ThesaurusConfigurationEntry</title>
    </head>
    <body>
        <div class="nav">
            <span class="menuButton"><a class="home" href="${createLinkTo(dir:'')}">Home</a></span>
            <span class="menuButton"><g:link class="list" action="list">ThesaurusConfigurationEntry List</g:link></span>
            <span class="menuButton"><g:link class="create" action="create">New ThesaurusConfigurationEntry</g:link></span>
        </div>
        <div class="body">
            <h1>Edit ThesaurusConfigurationEntry</h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${thesaurusConfigurationEntry}">
            <div class="errors">
                <g:renderErrors bean="${thesaurusConfigurationEntry}" as="list" />
            </div>
            </g:hasErrors>
            <g:form controller="thesaurusConfigurationEntry" method="post" >
                <input type="hidden" name="id" value="${thesaurusConfigurationEntry?.id}" />
                <div class="dialog">
                    <table>
                        <tbody>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="key">Key:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:thesaurusConfigurationEntry,field:'key','errors')}">
                                    <input type="text" id="key" name="key" value="${fieldValue(bean:thesaurusConfigurationEntry,field:'key')}"/>
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="value">Value:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:thesaurusConfigurationEntry,field:'value','errors')}">
                                    <input type="text" id="value" name="value" value="${fieldValue(bean:thesaurusConfigurationEntry,field:'value')}"/>
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
