<%@page import="com.vionto.vithesaurus.*" %>

<g:form action="search" method="get">

    <p><g:message code="powersearch.intro" /></p>

    <div class="dialog">
        <table>
            <tr>
                <td><g:message code="powersearch.word.contains" /></td>
                <!--<td><input name="contains" value="${params.contains}" autofocus/></td>-->
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
                <td><g:message code="powersearch.level" /></td>
                <td><g:select name="level" from="${TermLevel.list().sort()}" optionKey="levelName" noSelection="['null':'-']" value="${params.level}"></g:select></td>
            </tr>
            <tr>
                <td><g:message code="powersearch.category" /></td>
                <td><g:select name="category" from="${Category.findAllByIsDisabled(false, [sort:'categoryName'])}" noSelection="['null':'-']" value="${params.category}"></g:select></td>
            </tr>
            <tr>
                <td><g:message code="powersearch.tag" /></td>
                <td>
                    <input class="tags" name="tags" value="${params.tags}"/>
                </td>
            </tr>
            <tr>
                <td></td>
                <td><input class="submitButton" type="submit" value="${message(code:'powersearch.submit')}"/></td>
            </tr>
        </table>
    </div>

</g:form>
