
<%@ page import="com.vionto.vithesaurus.ThesaurusConfigurationEntry" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title>Show ThesaurusConfigurationEntry</title>
    </head>
    <body>
        <div class="nav">
            <span class="menuButton"><a class="home" href="${createLinkTo(dir:'')}">Home</a></span>
            <span class="menuButton"><g:link class="list" action="list">ThesaurusConfigurationEntry List</g:link></span>
            <span class="menuButton"><g:link class="create" action="create">New ThesaurusConfigurationEntry</g:link></span>
        </div>
        <div class="body">
            <h1>Show ThesaurusConfigurationEntry</h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <div class="dialog">
                <table>
                    <tbody>

                    
                        <tr class="prop">
                            <td valign="top" class="name">Id:</td>
                            
                            <td valign="top" class="value">${thesaurusConfigurationEntry.id}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Key:</td>
                            
                            <td valign="top" class="value">${thesaurusConfigurationEntry.key}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Value:</td>
                            
                            <td valign="top" class="value">${thesaurusConfigurationEntry.value}</td>
                            
                        </tr>
                    
                    </tbody>
                </table>
            </div>
            <div class="buttons">
                <g:form controller="thesaurusConfigurationEntry">
                    <input type="hidden" name="id" value="${thesaurusConfigurationEntry?.id}" />
                    <span class="button"><g:actionSubmit class="edit" value="Edit" /></span>
                    <span class="button"><g:actionSubmit class="delete" onclick="return confirm('Are you sure?');" value="Delete" /></span>
                </g:form>
            </div>
        </div>
    </body>
</html>
