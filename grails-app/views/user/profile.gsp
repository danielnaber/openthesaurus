<%@ page import="com.vionto.vithesaurus.UserEvent" %>
  
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title><g:message code="user.edit.title" args="${[visibleName.encodeAsHTML()]}"/></title>
    </head>
    <body>

        <div class="body">

            <hr/>

            <h2><g:message code="user.edit.headline" args="${[visibleName.encodeAsHTML()]}"/></h2>

            <g:if test="${flash.message}">
              <div class="message">${flash.message}</div>
            </g:if>

            <g:hasErrors bean="${user}">
            <div class="errors">
                <g:renderErrors bean="${user}" as="list" />
            </div>
            </g:hasErrors>

            <div class="dialog">
                <table>
                    <tbody>

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
                            <td valign='top' class='value'>
                                <g:decimal number="${UserEvent.countByByUser(user)}"/>
                            </td>
                        </tr>

                        <tr class='prop'>
                            <td valign='top' class='name' colspan="2">
                                <g:link controller="userEvent" action="list" params="${[uid: user.id]}"><g:message code="user.edit.edits"/></g:link>
                            </td>
                        </tr>

                    </tbody>
                </table>
            </div>

        </div>
    </body>
</html>
