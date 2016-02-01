<%@ page import="com.vionto.vithesaurus.UserEvent" %>
<%@ page import="com.vionto.vithesaurus.ThesaurusUser" %>
  
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title><g:message code="user.edit.title" args="${[visibleName]}"/></title>
        <script type="text/javascript" src="${createLinkTo(dir:'js',file:'blockies.js')}"></script>
    </head>
    <body>

        <div class="body">

            <hr/>

            <div style="float: left; margin-right: 10px">
                <g:render template="/identicon" model="${[user: user, count: 0]}"/>
            </div>

            <h2><g:message code="user.edit.headline" args="${[visibleName]}"/></h2>

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
                                <g:link controller="userEvent" action="list" params="${[uid: user.id]}"><g:decimal number="${UserEvent.countByByUser(user)}"/></g:link>
                            </td>
                        </tr>

                        <tr class='prop'>
                            <td valign='top' class='name'>
                                <g:message code="user.change.profile.website"/>
                            </td>
                            <td valign='top' class='value'>
                                <g:if test="${user.url}">
                                    <a href="${user.url.encodeAsHTML()}" rel="nofollow">${user.url.encodeAsHTML()}</a>
                                </g:if>
                            </td>
                        </tr>

                        <tr class='prop'>
                            <td valign='top' class='name'>
                                <g:message code="user.change.profile.description"/>
                            </td>
                            <td valign='top' class='value'>
                                <g:if test="${user.publicIntro}">
                                    ${user.publicIntro.encodeAsHTML()}
                                </g:if>
                            </td>
                        </tr>

                        <g:if test="${session.user}">
                            <tr class='prop'>
                                <td valign='top' class='name' colspan="2">
                                    <g:if test="${ThesaurusUser.get(params.uid).acceptsMessages}">
                                        <g:link action="prepareMessage" params="${[uid: user.id]}"><g:message code="user.send.message"/></g:link>
                                    </g:if>
                                    <g:else>
                                        <g:message code="user.send.message.disabled"/>
                                    </g:else>
                                </td>
                            </tr>
                        </g:if>

                        <g:if test="${session.user && session.user.id == Long.parseLong(params.uid)}">
                            <tr class='prop'>
                                <td valign='top' class='name' colspan="2">
                                    <br/><br/><br/>
                                    <g:link action="editProfile"><g:message code="user.edit.profile"/></g:link> &mdash; <g:link action="edit" params="${[uid: user.id]}"><g:message code="user.edit.back.to.private.profile"/></g:link>
                                </td>
                            </tr>
                        </g:if>

                    </tbody>
                </table>
            </div>

        </div>
    </body>
</html>
