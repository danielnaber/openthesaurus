<%@page import="com.vionto.vithesaurus.tools.*" %>  
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <g:set var="preventSearchFocus" value="true" scope="request" />
        <meta name="layout" content="main" />
        <title><g:message code="create.title"/></title>
    </head>
    <body>

            <h2><g:message code="create.headline"/></h2>
            
            <g:if test="${flash.message}">
                <div class="message">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${synset}">
            <div class="errors">
                <g:renderErrors bean="${synset}" as="list" />
            </div>
            </g:hasErrors>
            <g:form action="multiSearch" method="post" >
            	
            	<input type="hidden" name="isVisible" value="true" />
            	
                <div class="dialog">
                    <table>
                        <tbody>
                        
                            <tr class='prop'>
                                <td valign='top' class='name'>
                                    <label for='terms'><g:message code="create.terms"/></label>
                                </td>
                                <td valign='top' class='value'>
                                    <g:if test="${params.term}">
                                        <g:textArea autofocus rows="5" cols="30" id='terms' name='terms' spellcheck="true" value="${StringTools.slashUnescape(params.term)}\n"/>
                                    </g:if>
                                    <g:else>
                                        <g:textArea autofocus rows="5" cols="30" id='terms' name='terms' spellcheck="true" value=""/>
                                    </g:else>
                                </td>
                                <td valign='top'>
                                    <g:message code="create.example"/>
                                </td>
                            </tr>
                            
                            <tr>
                            	<td></td>
                            	<td>
					                <div class="buttons">
					                    <span class="button"><input
					                    	class="submitButton" type="submit" value="${message(code:'create.continue')}"/></span>
					                </div>
                            	</td>
                            </tr> 
                        </tbody>
                    </table>

                    <p style="margin-top: 15px">
                        <g:link controller="suggest"><g:message code="user.create.synset.missingwords.link"/></g:link>
                    </p>
                    
                </div>
            </g:form>

    </body>
</html>
