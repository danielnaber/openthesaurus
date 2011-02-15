  
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title>Logbuch für ${user.userId.encodeAsHTML()} - OpenThesaurus</title>
    </head>
    <body>

        <div class="body">

            <hr/>

            <h2>Logbuch für ${user.userId.encodeAsHTML()}</h2>

            <g:if test="${flash.message}">
              <div class="message">${flash.message}</div>
            </g:if>

            <g:hasErrors bean="${user}">
            <div class="errors">
                <g:renderErrors bean="${user}" as="list" />
            </div>
            </g:hasErrors>

            <g:form controller="user" method="post" >
                <input type="hidden" name="id" value="${user?.id}" />
                <div class="dialog">
                    <table>
                        <tbody>

                            <%--
                            <tr class='prop'>
                                <td valign='top' class='name'>
                                    <label for='password'>Password:</label>
                                </td>
                                <td valign='top' class='value ${hasErrors(bean:user,field:'password','errors')}'>
                                    <input type="password" id='password' name='password' value=""/>
                                    <br />
                                    <span class="metaInfo">enter only if you want to change your password</span>
                                </td>
                            </tr> 

                            <tr class='prop'>
                                <td valign='top' class='name'>
                                    <label for='realName'>Real Name:</label>
                                </td>
                                <td valign='top' class='value ${hasErrors(bean:user,field:'realName','errors')}'>
                                    <input type="text" id='realName' name='realName' value="${fieldValue(bean:user,field:'realName')}"/>
                                </td>
                            </tr> 
                        
                            <tr class='prop'>
                                <td valign='top' class='name'>
                                    <label for='permission'>Permission:</label>
                                </td>
                                <td valign='top' class='value ${hasErrors(bean:user,field:'permission','errors')}'>
                                    <g:select id='permission' name='permission' from='${user.constraints.permission.inList.collect{it.encodeAsHTML()}}' value="${fieldValue(bean:user,field:'permission')}" ></g:select>
                                </td>
                            </tr> --%>
                        
                            <tr class='prop'>
                                <td valign='top' class='name'>
                                    Angezeigter Name:
                                </td>
                                <td valign='top' class='value'>
                                    ${user.realName.encodeAsHTML()}
                                </td>
                            </tr>

                            <tr class='prop'>
                                <td valign='top' class='name'>
                                    Datum der Anmeldung:
                                </td>
                                <td valign='top' class='value'>
                                    <g:formatDate format="yyyy-MM-dd" date="${user?.creationDate}"/>
                                </td>
                            </tr> 

                            <tr class='prop'>
                                <td valign='top' class='name' colspan="2">
                                    <g:link controller="userEvent" action="list" params="${[userId: user.userId]}">Liste aller meiner Beiträge</g:link>
                                </td>
                            </tr>

                        </tbody>
                    </table>
                </div>
                <%--
                <div class="buttons">
                    <span class="button"><g:actionSubmit class="save" value="Update" /></span>
                </div>
                --%>
            </g:form>
        </div>
    </body>
</html>
