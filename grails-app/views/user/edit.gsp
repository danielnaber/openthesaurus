  
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title><g:message code="user.edit.title" args="${[user.userId]}"/></title>
        <script type="text/javascript" src="${createLinkTo(dir:'js',file:'blockies.js')}"></script>
    </head>
    <body>

        <div class="body">

            <div style="float: left; margin-right: 10px">
                <g:render template="/identicon" model="${[user: user, count: 0]}"/>
            </div>
            
            <h2><g:message code="user.edit.headline" args="${[user.userId]}"/></h2>

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

                            <tr class='prop'>
                                <td valign='top' class='name'>
                                    <g:message code="user.edit.display.name"/>
                                </td>
                                <td valign='top' class='value'>
                                    ${user.realName ? user.realName.encodeAsHTML() : "-"}
                                </td>
                            </tr>

                            <tr class='prop'>
                                <td valign='top' class='name'>
                                    <g:message code="user.edit.date.of.registration"/>
                                </td>
                                <td valign='top' class='value'>
                                    <g:formatDate format="yyyy-MM-dd" date="${user?.creationDate}"/>
                                </td>
                            </tr> 

                            <tr class='prop'>
                                <td valign='top' class='name'>
                                    <g:message code="user.edit.event.count"/>
                                </td>
                                <td valign='top' class='name' colspan="2">
                                    <g:link controller="userEvent" action="list" params="${[uid: user.id]}">${eventCount}</g:link>
                                </td>
                            </tr>

                            <tr class='prop'>
                                <td valign='top' class='name' colspan="2">
                                    <g:link action="editProfile"><g:message code="user.edit.profile"/></g:link>
                                </td>
                            </tr>

                            <tr class='prop'>
                                <td valign='top' class='name' colspan="2">
                                    <g:link action="profile" params="${[uid:user.id]}"><g:message code="user.edit.public.profile"/></g:link>
                                </td>
                            </tr>

                        </tbody>
                    </table>
                </div>
            </g:form>
        </div>
    </body>
</html>
