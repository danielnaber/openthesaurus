
<%@ page import="com.vionto.vithesaurus.TermLevel" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title>Create TermLevel</title>         
    </head>
    <body>
        <div class="nav">
            <span class="menuButton"><a class="home" href="${createLinkTo(dir:'')}">Home</a></span>
            <span class="menuButton"><g:link class="list" action="list">TermLevel List</g:link></span>
        </div>
        <div class="body">
            <h1>Create TermLevel</h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${termLevelInstance}">
            <div class="errors">
                <g:renderErrors bean="${termLevelInstance}" as="list" />
            </div>
            </g:hasErrors>
            <g:form action="save" method="post" >
                <div class="dialog">
                    <table>
                        <tbody>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="levelName">Level Name:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:termLevelInstance,field:'levelName','errors')}">
                                    <input type="text" id="levelName" name="levelName" value="${fieldValue(bean:termLevelInstance,field:'levelName')}"/>
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="shortLevelName">Short Level Name:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:termLevelInstance,field:'shortLevelName','errors')}">
                                    <input type="text" id="shortLevelName" name="shortLevelName" value="${fieldValue(bean:termLevelInstance,field:'shortLevelName')}"/>
                                </td>
                            </tr> 
                        
                        </tbody>
                    </table>
                </div>
                <div class="buttons">
                    <span class="button"><input class="save" type="submit" value="Create" /></span>
                </div>
            </g:form>
        </div>
    </body>
</html>
