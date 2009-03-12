  
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title>Synset '${synset}'</title>
    </head>
    <body>

		<g:if test="${synset.isVisible}">
			<g:set var="bodyclass" value="body" />
		</g:if>
		<g:else>
			<g:set var="bodyclass" value="deletedBody" />
		</g:else>
		
		
        <div class="${bodyclass}">
            
            <h1>Synset '${synset}'</h1>
            
            <g:if test="${flash.message}">
            	<div class="message">${flash.message}</div>
            </g:if>
            
                <table>
                    <tbody>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Is Visible:</td>
                            
                            <td valign="top" class="value">${synset.isVisible}</td>
                            
                        </tr>

                        <tr class="prop">
                            <td valign="top" class="name">Is Category:</td>
                            
                            <td valign="top" class="value">${synset.isCategory}</td>
                            
                        </tr>

                        <tr class="prop">
                            <td valign="top" class="name">Terms:</td>
                            
                            <td  valign="top" style="text-align:left;" class="value">
                                <ul>
                                <g:each var="t" in="${synset.terms}">
                                    <li><g:link controller="term" action="show" id="${t.id}">${t}</g:link></li>
                                </g:each>
                                </ul>
                            </td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Synset Links:</td>
                            
                            <td  valign="top" style="text-align:left;" class="value">
                                <ul>
                                <g:each var="s" in="${synset.synsetLinks}">
                                    <li><g:link controller="synsetLink" action="show" id="${s.id}">${s}</g:link></li>
                                </g:each>
                                </ul>
                            </td>
                            
                        </tr>
                    
                    
                    </tbody>
                </table>
            
            <div class="buttons">
                <g:form controller="synset">
                    <input type="hidden" name="id" value="${synset?.id}" />
                    <span class="button"><g:actionSubmit class="edit" value="Edit" /></span>
                    <span class="button"><g:actionSubmit class="delete" onclick="return confirm('Are you sure?');" value="Delete" /></span>
                </g:form>
            </div>
        </div>
    </body>
</html>
