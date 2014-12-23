<%@page import="com.vionto.vithesaurus.*" %>

<form id="powerSearchForm" action="search" method="get">
    <input type="hidden" name="submitted" value="0"/>

    <p><g:message code="powersearch.intro" /></p>

    <div class="dialog">
        <table>
            <tr>
                <td><g:message code="powersearch.word.contains" /></td>
                <td><g:textField name="contains" value="${params.contains}" autofocus=""/></td>
            </tr>
            <tr>
                <td><g:message code="powersearch.word.starts.with" /></td>
                <td><g:textField name="startsWith" value="${params.startsWith}" /></td>
            </tr>
            <tr>
                <td><g:message code="powersearch.word.end.with" /></td>
                <td><g:textField name="endsWith" value="${params.endsWith}"/></td>
            </tr>
            <tr>
                <td style="vertical-align: top"><g:message code="powersearch.level" /></td>
                <td>
                    <label><input type="checkbox" name="noLevel" value="1" checked/>&nbsp;<span class="metaInfo"><g:message code="edit.term.level.none"/></span></label><br/>
                    <g:each in="${TermLevel.list()}" var="level">
                        <label><input type="checkbox" name="level" value="${level.id}" checked/>&nbsp;${level.levelName.encodeAsHTML()}</label><br/>
                    </g:each>
                </td>
            </tr>
            <tr>
                <td><g:message code="powersearch.category" /></td>
                <td><g:select name="category" from="${Category.findAllByIsDisabled(false, [sort:'categoryName'])}" noSelection="['null':'-']" value="${params.category}"></g:select></td>
            </tr>
            <tr>
                <td><g:message code="powersearch.tag" /></td>
                <td style="width:220px">
                    <input class="tags" name="tags" value="${params.tags}"/>
                </td>
            </tr>
            <tr>
                <td></td>
                <td><input class="submitButton" type="submit" value="${message(code:'powersearch.submit')}"/></td>
            </tr>
        </table>
    </div>

</form>
