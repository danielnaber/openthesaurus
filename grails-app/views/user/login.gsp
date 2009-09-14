  
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="login" />
        <title><g:message code="user.login.title"/></title>         
    </head>
    <body>

        <div class="body">
        
            <h1><g:message code="user.login.headline"/></h1>
            
            <g:if test="${flash.message}">
                <div class="message">${flash.message}</div>
            </g:if>
            
            <g:hasErrors bean="${user}">
	            <div class="errors">
	                <g:renderErrors bean="${user}" as="list" />
	            </div>
            </g:hasErrors>
            
            <g:form action="login" method="post" name="loginform">
                <div class="dialog">
                    <table>
                        <tbody>
                        
                            <tr class='prop'>
                            	<td></td>
                                <td valign='top' class='name'>
                                    <g:message code="user.login.register"/>
                                </td>
                            </tr> 

                            <tr class='prop'>
                                <td valign='top' class='name'>
                                    <label for='userId'><g:message code="user.login.form.username"/></label>
                                </td>
                                <td valign='top' class='value'>
                                    <input size="40" type="text" id='userId' name='userId' value="${params.userId?.encodeAsHTML()}"/>
                                </td>
                            </tr> 
                        
                            <tr class='prop'>
                                <td valign='top' class='name'>
                                    <label for='password'><g:message code="user.login.form.password"/></label>
                                </td>
                                <td valign='top' class='value'>
                                    <input size="40" type="password" id='password' name='password' value=""/>
                                </td>
                            </tr> 

                            <tr>
                                <td>
                                </td>
                                <td>
					                <div class="buttons">
					                    <span class="button"><input class="login" type="submit" value="${message(code:'user.login.form.submit')}"></input></span>
					                </div>
                                </td>
                            </tr> 

                        </tbody>
                    </table>
                </div>
            </g:form>
        </div>
        
        <script type="text/javascript">
        <!--
            document.loginform.userId.focus();
        // -->
        </script>
        
    </body>
</html>
