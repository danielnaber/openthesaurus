
<%@ page import="com.vionto.vithesaurus.RejectedWord" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title>Create RejectedWord</title>         
    </head>
    <body>
        <div class="nav">
            <span class="menuButton"><a class="home" href="${createLinkTo(dir:'')}">Home</a></span>
            <span class="menuButton"><g:link class="list" action="list">RejectedWord List</g:link></span>
        </div>
        <div class="body">
        
            <h1>Create RejectedWord</h1>
            
            <g:if test="${flash.message}">
                <div class="message">${flash.message}</div>
            </g:if>
            
            <g:hasErrors bean="${rejectedWord}">
            <div class="errors">
                <g:renderErrors bean="${rejectedWord}" as="list" />
            </div>
            </g:hasErrors>
            <g:form action="save" method="post" >
                <div class="dialog">
                    <table>
                        <tbody>
                        
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
                    <span class="button"><input class="save" type="submit" value="Create" /></span>
                </div>
            </g:form>
        </div>
    </body>
</html>
