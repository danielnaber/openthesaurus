<%@ page import="com.vionto.vithesaurus.WordGrammar" %>  
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title>Create WordGrammar</title>         
    </head>
    <body>
        <div class="nav">
            <span class="menuButton"><a class="home" href="${createLinkTo(dir:'')}">Home</a></span>
            <span class="menuButton"><g:link class="list" action="list">WordGrammar List</g:link></span>
        </div>
        <div class="body">
            <h1>Create WordGrammar</h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${wordGrammar}">
            <div class="errors">
                <g:renderErrors bean="${wordGrammar}" as="list" />
            </div>
            </g:hasErrors>
            <g:form action="save" method="post" >
                <div class="dialog">
                    <table>
                        <tbody>
                        
                            <tr class='prop'>
                                <td valign='top' class='name'>
                                    <label for='form'>Form:</label>
                                </td>
                                <td valign='top' class='value ${hasErrors(bean:wordGrammar,field:'form','errors')}'>
                                    <input type="text" id='form' name='form' value="${fieldValue(bean:wordGrammar,field:'form')}"/>
                                </td>
                            </tr> 
                        
                        </tbody>
                    </table>
                </div>
                <div class="buttons">
                    <span class="button"><input class="save" type="submit" value="Create"></input></span>
                </div>
            </g:form>
        </div>
    </body>
</html>
