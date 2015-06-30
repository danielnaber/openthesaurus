<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <g:set var="preventSearchFocus" value="true" scope="request" />
        <title><g:message code="user.prepare.message.title" args="${[receiver.realName.encodeAsHTML()]}"/></title>
    </head>
    <body>

        <div class="body">

            <hr/>

            <h2><g:message code="user.prepare.message.headline" args="${[receiver.realName.encodeAsHTML()]}"/></h2>

            <g:if test="${flash.message}">
              <div class="message">${flash.message}</div>
            </g:if>

            <form action="sendMessage" method="post">
                <input type="hidden" name="receiverId" value="${receiver.id}"/>
    
                <div class="dialog">
                    <table>
                        <tbody>
                        
                            <tr>
                                <td width="10%"><g:message code="user.prepare.message.from"/></td>
                                <td>${session.user.userId.encodeAsHTML()}</td>
                            </tr>
                            <tr>
                                <td><g:message code="user.prepare.message.to"/></td>
                                <td>${receiver.realName.encodeAsHTML()}</td>
                            </tr>
                            <tr>
                                <td><g:message code="user.prepare.message.subject"/></td>
                                <td><input type="text" name="subject" autofocus /></td>
                            </tr>
                            <tr>
                                <td></td>
                                <td><label><input type="checkbox" name="cc" /> <g:message code="user.prepare.message.cc"/></label></td>
                            </tr>
    
                            <tr>
                                <td valign='top' class='name' colspan="2">
                                    <textarea name="message" rows="15" cols="60"></textarea>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2"><g:message code="user.prepare.message.privacy.hint"/></td>
                            </tr>
                            <tr>
                                <td valign='top' class='name' colspan="2">
                                    <input class="submitButton" type="submit" value="${message(code:'user.prepare.message.send')}"/>
                                </td>
                            </tr>
    
                        </tbody>
                    </table>
                </div>
                
            </form>

        </div>
    </body>
</html>
