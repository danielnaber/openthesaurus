
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title>Search Syntax Help</title>
    </head>
    <body>

        <div class="body">
            <g:if test="${flash.message}">
                <div class="message">${flash.message}</div>
            </g:if>

            <!-- full text search only:
            <h1>Search Syntax Help</h1>

            <div class="dialog">

                <table>
                    <tr>
                        <th>Example</th>
                        <th>Explanation</th>
                    </tr>
                    <tr>
                        <td>mouse cancer</td>
                        <td>Searches for concepts that contain "mouse" and "cancer"</td>
                    </tr>
                    <tr>
                        <td>mouse OR cancer</td>
                        <td>Searches for concepts that contain "mouse" or "cancer"</td>
                    </tr>
                    <tr>
                        <td>"mouse cancer"</td>
                        <td>Searches for concepts with the phrase "mouse cancer"</td>
                    </tr>
                    <tr>
                        <td>aspi*</td>
                        <td>Searches for concepts that contain terms that start with "aspi"
                         (note: you can use "*" within a term, but not at the start of a term)</td>
                    </tr>
                    <tr>
                        <td>dubios~</td>
                        <td>Searches for concepts that contain terms similar to "dubios"</td>
                    </tr>
                </table>
            </div>
             -->

            <h1>Database Search Syntax Help</h1>

            <div class="dialog">

                <table>
                    <tr>
                        <th>Example</th>
                        <th>Explanation</th>
                    </tr>
                    <tr>
                        <td>mouse</td>
                        <td>Searches for concepts that contain <b>exactly</b> the term "mouse"</td>
                    </tr>
                    <tr>
                        <td>mouse cancer</td>
                        <td>Searches for concepts that contain <b>exactly</b> the term "mouse cancer"</td>
                    </tr>
                    <tr>
                        <td>aspi%</td>
                        <td>Searches for concepts that contain terms that start with "aspi"</td>
                    </tr>
                    <tr>
                        <td>%aspi%</td>
                        <td>Searches for concepts that contain terms that contain "aspi"</td>
                    </tr>
                    <tr>
                        <td>_nimal_</td>
                        <td>Searches for concepts that contain terms with exactly one character
                            before and after "nimal"</td>
                    </tr>
                </table>
            </div>

        </div>
    </body>
</html>
