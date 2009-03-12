<%@page import="com.vionto.vithesaurus.*" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title>Concept List</title>
    </head>
    <body>

        <div class="body">
            <h1>Concept List (${Synset.countByIsVisible(true)} matches)</h1>

            <g:if test="${flash.message}">
                <div class="message">${flash.message}</div>
            </g:if>

            <div class="list">
                <table>
                    <thead>
                        <tr>

                            <g:sortableColumn property="id" title="ID" />

                               <th>Concept</th>

                            <g:sortableColumn property="source" title="Source" />

                            <g:sortableColumn property="preferredCategory" title="Pref. Category" />

                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${synsetList}" status="i" var="synset">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">

                            <td><g:link action="edit" id="${synset.id}">${synset.id?.toString()?.encodeAsHTML()}</g:link></td>

                            <td><g:link action="edit" id="${synset.id}">${synset?.toString()?.encodeAsHTML()}</g:link></td>

                            <td>${synset?.source?.toString()?.encodeAsHTML()}</td>

                            <td>${synset.preferredCategory?.toString()?.encodeAsHTML()}
                               <g:if test="${synset.preferredCategory?.categoryType}">
                                   <br /><span class="metaInfo">[${synset.preferredCategory?.categoryType}]</span>
                               </g:if>
                            </td>

                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
            <div class="paginateButtons">
                <g:paginate total="${Synset.countByIsVisible(true)}" />
            </div>
        </div>
    </body>
</html>
