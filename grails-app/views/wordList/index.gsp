<%@page import="com.vionto.vithesaurus.*" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title><g:message code="wordlists.title" /></title>
    </head>
    <body>

            <hr />

            <h2><g:message code="wordlists.head" /></h2>

            <div style="float:left;margin-right: 35px">
                <ul>
                    <%-- FIXME
                    <li><g:link controller="term" action="list"><g:message code="a_to_z"/></g:link></li>
                    --%>
                    <li><g:link controller="tag" action="list"><g:message code="tag.link"/></g:link></li>
                    <li><g:link controller="association" action="list"><g:message code="association.link"/></g:link></li>
                    <li><g:link controller="term" action="antonyms"><g:message code="antonyms.link"/></g:link></li>
                    <li><g:link controller="synset" action="variation" id="at"><g:message code="austrian.words"/></g:link></li>
                    <li><g:link controller="synset" action="variation" id="ch"><g:message code="swiss.words"/></g:link></li>
                    <li><g:link controller="random" action="synsets"><g:message code="random.headline"/></g:link></li>
                    <li><g:link controller="tree" action="index"><g:message code="tree.headline"/></g:link></li>
                    <li><g:message code="by.size.headline"/>:<br/>
                        <g:link controller="synset" action="listBySize" params="${[direction: 'desc']}"><g:message code="by.size.headline.largest"/></g:link>,<br/>
                        <g:link controller="synset" action="listBySize" params="${[direction: 'asc']}"><g:message code="by.size.headline.smallest"/></g:link>
                    </li>
                    <li style="margin-top:14px"><g:message code="word.list.by.level"/>
                        <ul style="margin-top:0">
                            <g:each in="${TermLevel.list()}" var="level">
                                <li><g:link controller="term" action="list" params="${[levelId:level.id]}">${level.encodeAsHTML()}</g:link></li>
                            </g:each>
                        </ul>
                    </li>
                </ul>
            </div>
    
            <div style="float:left">
                <g:set var="categories" value="${Category.withCriteria { eq('isDisabled', false) }.sort()}"/>
                <g:set var="categoriesLen" value="${categories.size()}"/>
                <g:set var="categories1" value="${categories.subList(0, (categoriesLen/2).intValue())}"/>
                <g:set var="categories2" value="${categories.subList((categoriesLen/2).intValue(), categoriesLen)}"/>
                
                <h2><g:message code="word.list.by.category"/></h2>
                
                <table>
                    <tr>
                    <td valign="top">
                        <ul>
                            <g:each in="${categories1}" var="category">
                                <li><g:link controller="term" action="list" params="${[categoryId:category.id]}">${category.encodeAsHTML()}</g:link></li>
                            </g:each>
                        </ul>
                    </td>
                    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                    <td valign="top">
                        <ul>
                            <g:each in="${categories2}" var="category">
                                <li><g:link controller="term" action="list" params="${[categoryId:category.id]}">${category.encodeAsHTML()}</g:link></li>
                            </g:each>
                        </ul>
                    </td>
                    </tr>
                </table>
            </div>

            <div style="clear: both"></div>
    
    </body>
</html>
