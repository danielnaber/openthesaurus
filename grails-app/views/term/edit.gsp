<%@page import="com.vionto.vithesaurus.*" %>  
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title>Edit Term '${term.toString()?.encodeAsHTML()}'</title>
    </head>
    <body>

        <div class="body">
            <h1>Edit Term '${term.toString()?.encodeAsHTML()}'</h1>
    
            <g:if test="${flash.message}">
                <div class="message">${flash.message}</div>
            </g:if>
    
            <g:hasErrors bean="${term}">
            <div class="errors">
                <g:renderErrors bean="${term}" as="list" />
            </div>
            </g:hasErrors>
            
            <g:if test="${!session.user}">
                <g:set var="disabled" value="disabled='true'"/>
            </g:if>

            <g:form controller="term" method="post" >
                <input type="hidden" name="id" value="${id}" />
                <div class="dialog">
                    <table>
                        <tbody>
                        
                            <tr class='prop'>
                                <td valign='top' class='name'>
                                    <label for='word'>Term:</label>
                                </td>
                                <td valign='top' class='value ${hasErrors(bean:term,field:'word','errors')}'>
                                    <input ${disabled} type="text" id='word' name='word' value="${fieldValue(bean:term,field:'word')}"/>
                                </td>
                            </tr> 

                            <tr class='prop'>
                                <td valign='top' class='name'>
                                    <label for='synset'>Concept:</label>
                                </td>
                                <td valign='top' class='value'>
                                    <g:link controller="synset" action="edit" id="${term.synset.id}">${term.synset.toString()?.encodeAsHTML()}</g:link>
                                </td>
                            </tr> 

                            <tr class='prop'>
                                <td valign='top' class='name'>
                                    <label for='synset'>Language:</label>
                                </td>
                                <td valign='top' class='value ${hasErrors(bean:term,field:'language','errors')}'>
                                    <g:if test="${session.user}">
                                        <g:select value="${term.language.id}" name="language.id"
                                            optionKey="id" from="${Language.list()}" />
                                    </g:if>
                                    <g:else>
                                        ${term.language.longForm.toString()?.encodeAsHTML()}
                                    </g:else>
                                </td>
                            </tr> 

                            <tr class='prop'>
                                <td valign='top' class='name'>
                                    <label for='wordGrammar'>Word form:</label>
                                </td>
                                <td valign='top' class='value ${hasErrors(bean:term,field:'wordGrammar','errors')}'>
                                    <g:if test="${session.user}">
                                        <g:select value="${term.wordGrammar?.id}" name="wordGrammar.id"
                                            optionKey="id" from="${WordGrammar.list()}" />
                                    </g:if>
                                    <g:else>
                                        ${term.wordGrammar?.toString()?.encodeAsHTML()}
                                    </g:else>
                                </td>
                            </tr> 

                            <!-- 
                            <tr class='prop'>
                                <td valign='top' class='name'>
                                    <label for='synset'>Level:</label>
                                </td>
                                <td valign='top' class='value ${hasErrors(bean:term,field:'level','errors')}'>
                                    <g:select value="${term.level?.id}" name="level.id" 
                                        optionKey="id" from="${TermLevel.list()}" noSelection="['null':'[none]']" />
                                </td>
                            </tr>
                             --> 

                            <tr class='prop'>
                                <td valign='top' class='name'>
                                </td>
                                <td valign='top' class='value'>
                                    <label><g:managedRadio disabled="${!session.user}" id="wordFormCommon" name="wordForm"
                                        value="common" checked="${true}" /> common word</label>&nbsp;
                                    <label><g:managedRadio disabled="${!session.user}" id="wordFormAcronym" name="wordForm"
                                        value="acronym" checked="${term.isAcronym}" /> acronym</label>&nbsp;
                                    <label><g:managedRadio disabled="${!session.user}" id="wordFormAbbreviation" name="wordForm"
                                        value="abbreviation" checked="${term.isShortForm}" /> abbreviation</label>
                                </td>
                            </tr> 
                                                
                            <tr class='prop'>
                                <td valign='top' class='name'>
                                    <label for='userComment'>Comment:</label>
                                </td>
                                <td valign='top' class='value ${hasErrors(bean:term,field:'userComment','errors')}'>
                                    <g:if test="${session.user}">
                                        <g:textArea id='userComment' name='userComment' value="${term.userComment}"/>
                                    </g:if>
                                    <g:else>
                                        ${term.userComment?.toString()?.encodeAsHTML()}
                                    </g:else>
                                </td>
                            </tr> 

                        </tbody>
                    </table>
                </div>
                <g:if test="${session.user}">
	                <div class="buttons">
	                    <span class="button"><g:actionSubmit class="save" value="Update" /></span>
	                </div>
	            </g:if>
            </g:form>
        </div>
    </body>
</html>
