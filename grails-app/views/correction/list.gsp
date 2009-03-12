<%@page import="com.vionto.vithesaurus.*" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title>Corrections</title>
    </head>
    <body>
    <table>
        <div class="body">
        <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
        </g:if>

        <tr><td>
        <h1>Corrections chu</h1>
        <g:form controller="correctionsChu">
            <div class="buttons">
                <span class="button"><g:actionSubmit action="testIt" value="Test me" /></span>
            </div>
        </g:form>
        </td></tr>

        <tr><td>
        <h1>Corrections mkl</h1>
        <g:form controller="correctionsMkl">
            <div class="buttons">
                <span class="button"><g:actionSubmit action="listAllTerms" value="List all terms" /></span>
                <span class="button"><g:actionSubmit action="deleteSpecialTermsWithComma" value="Delete Comma" /></span>
            </div>
        </g:form>
        </td></tr>

        <tr><td>
        <h1>General Corrections</h1>
        <h4>The corrections listend here should match general purpose from time to time.</h4>
        <br />
        <g:form controller="correction">
            <div class="buttons">
                <span class="button"><g:actionSubmit action="addPreferredTerms" value="Add preferred term" /></span>
                <span class="button"><g:actionSubmit action="fixTermWhitespaces" value="Fix terms with invalid whitespaces" /></span>
                <span class="button"><g:actionSubmit action="askDeleteInvisible" value="Delete invisible terms" /></span>
            </div>
        </div>
        </g:form>
        </td></tr>

        <tr><td>
        <g:form controller="correction" method="post">
                    <table>
                        <tbody>
                            <tr class='prop'>
                                <td valign='top' class='name'>
                                    <label>List terms with less than given character.</label>
                                </td>
                            </tr>

                            <tr>
                                <td>
                                    <input name="quantity" type="text" size="10" />
                                </td>
                                <td valign='top'>
                                    <span class="button">
                                        <g:actionSubmit action="listWordsLessThanGivenCharacters" value="List them" />
                                    </span>
                                </td>
                            </tr>
                        </tbody>
                    </table>
        </g:form>
        </td></tr>

        <tr><td>
        <g:form controller="correction" method="post">
                    <table>
                        <tbody>
                            <tr class='prop'>
                                <td valign='top' class='name'>
                                    <label>Create outputfile with sysnets containing specified pattern.</label>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <label>pattern:</label>
                                 </td>
                                 <td>
                                    <input name="pattern" type="text" size="20" />
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <label>filename:</label>
                                </td>
                                 <td>
                                    <input name="fileName" type="text" size="20" />
                                </td>
                            </tr>
                            <tr>
                                <td valign='top'>
                                    <span class="button">
                                        <g:actionSubmit action="createOutputFileForGivenPattern" value="Create file" />
                                    </span>
                                </td>
                            </tr>
                        </tbody>
                    </table>
        </g:form>
        </td></tr>

    </table>
    </body>
</html>
