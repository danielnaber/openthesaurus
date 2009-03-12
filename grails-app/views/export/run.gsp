<%@page import="com.vionto.vithesaurus.*" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title>Export</title>
    </head>
    <body>

        <g:form controller="export" action="run">

        <div class="body">
            <h1>Export</h1>
            <g:if test="${flash.message}">
                <div class="message">${flash.message}</div>
            </g:if>
            <div class="dialog">
                <table>
                    <tbody>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Path:</td>
                            
                            <td valign="top" class="value"><g:textField name="path" value="/tmp/thesaurus-export.xml" /></td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Thesaurus:</td>
                            
                            <td valign="top" class="value">
                                <g:select name="section.id" from="${Section.list()}" optionKey="id"
                                value="${params['section.id']}" noSelection="['':'-all sections-']" />
                            </td>
                        </tr>
                        
                        <tr class="prop">
                            <td valign="top" class="name">URN prefix:</td>
                            <td valign="top" class="value">
                                <input type="text" name="prefix" value="urn:concept:" />
                            </td>
                        </tr>

                        <tr class="prop">
                            <td valign="top" class="name">Start at ID:</td>
                            <td valign="top" class="value">
                                <input type="text" name="offset" value="0" />
                            </td>
                        </tr>
                    
                    </tbody>
                </table>
            </div>
            <div class="buttons">
                <span class="button"><g:actionSubmit value="Start" /></span>
            </div>
        </div>

        </g:form>
        
    </body>
</html>
