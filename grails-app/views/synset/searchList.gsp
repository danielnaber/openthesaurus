<%@page import="com.vionto.vithesaurus.*" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title>Matches for '${params.q.encodeAsHTML()}'</title>
    </head>
    <body>

        <div class="body">

            <g:if test="${completeResult}">
                <h1>About ${totalMatches} Matches for '${params.q.encodeAsHTML()}'</h1>
            </g:if>
            <g:else>
                <h1>More than ${upperBound} Matches for '${params.q.encodeAsHTML()}'</h1>
            </g:else>

            <g:if test="${flash.message}">
                <div class="message">${flash.message}</div>
            </g:if>

            <g:if test="${totalMatches > 0}">

                    <form action="search" method="get">
                <table>
                    <tr>
                        <g:set var="sortParams" value="[q: params.q,
                           'section.id': params['section.id'],
                           'source.id': params['source.id'],
                           'category.id': params['category.id'],
                           'max': params.max ? params.max : 10]" />
                        <g:sortableColumn width="30%" property="synsetPreferredTerm" title="Preferred Term" params="${sortParams}" />
                        <th width="30%">Other Terms</th>
                        <g:sortableColumn property="section" title="Thesaurus" params="${sortParams}" />
                        <g:sortableColumn property="source" title="Source" params="${sortParams}" />
                        <g:sortableColumn property="preferredCategory" title="Categories" params="${sortParams}" />
                    </tr>
                   <g:set var="german" value="${Language.findByShortForm('de')}"/>
                   <g:each in="${synsetList}" status="i" var="synset">
                        <g:if test="${synset.isVisible == false}">
                            <g:set var="trClass" value="deletedRow" />
                        </g:if>
                        <g:else>
                            <g:set var="trClass" value="${(i % 2) == 0 ? 'odd' : 'even'}" />
                        </g:else>
                        <tr class="${trClass}">
                            <td>
                                <g:if test="${synset.isVisible == false}">
                                    <strong>Invisible:</strong>
                                </g:if>
                                <g:link action="edit"
                                id="${synset.id}">
                                ${synset?.preferredTerm().toString()?.encodeAsHTML()}
                                </g:link></td>
                            <td>
                                <g:link action="edit" id="${synset.id}">
                                    <g:each in="${synset?.otherTerms()?.sort()}" var="term">
                                        ${term.toString()?.encodeAsHTML()}<br/>
                                    </g:each>
                                </g:link>
                            </td>
                            <td>${synset?.section?.toString()?.encodeAsHTML()}</td>
                            <td>${synset?.source?.toString()?.encodeAsHTML()}</td>
                            <td>
                               <%
                               //make preferred category only bold if it's not the only category
                               %>
                               <g:if test="${synset?.categoryLinks?.size() > 1}">
                                       <b>${synset?.preferredCategory?.toString()?.encodeAsHTML()}</b>
                               </g:if>
                               <g:else>
                                   ${synset?.preferredCategory?.toString()?.encodeAsHTML()}
                               </g:else>
                               <g:if test="${synset?.preferredCategory?.categoryType}">
                                       <br /><span class="metaInfo">[${synset?.preferredCategory?.categoryType?.toString()?.encodeAsHTML()}]</span>
                               </g:if>
                               <g:each in="${synset?.categoryLinks}" var="categoryLink">
                                   <g:if test="${synset?.preferredCategory != categoryLink.category}">
                                           <br />${categoryLink.category}
                                   </g:if>
                               </g:each>
                            </td>
                        </tr>
                   </g:each>
                    </table>

                <div class="paginateButtons">
                    <%
                    // workaround for http://jira.codehaus.org/browse/GRAILS-2088:
                    map = params.findAll { entry, val -> entry != 'offset'}
                    %>
                    <g:paginate total="${totalMatches}" params="${map}" />

                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    Matches per page: <g:select name="max" from="${[10,25,50,100]}" value="${params.max}"/>
                    <input type="hidden" name="q" value="${params.q.encodeAsHTML()}" />
                    <input type="hidden" name="section.id" value="${params['section.id'].encodeAsHTML()}" />
                    <input type="hidden" name="category.id" value="${params['category.id'].encodeAsHTML()}" />
                    <input type="hidden" name="source.id" value="${params['source.id'].encodeAsHTML()}" />
                    <g:if test="${params.sort}">
                        <input type="hidden" name="sort" value="${params.sort.encodeAsHTML()}" />
                    </g:if>
                    <g:if test="${params.order}">
                        <input type="hidden" name="order" value="${params.order.encodeAsHTML()}" />
                    </g:if>
                    <g:if test="${params.offset}">
                        <input type="hidden" name="offset" value="${params.offset.encodeAsHTML()}" />
                    </g:if>
                    <g:actionSubmit value="Go" />
                </div>

                </form>

            </g:if>

            <g:if test="${totalMatches == 0 && params.q && !(params.q.endsWith('%') || params.q.endsWith('_')) }">
                <br />
                <g:set var="noJokerTerm" value="${params.q.trim().replaceAll('%$', '').replaceAll('_$', '')}" />
                <g:link action="search" params="[q : noJokerTerm + '%',
                        'section.id': params['section.id'],
                        'category.id': params['category.id'],
                        'source.id': params['source.id']]">
                    <img src="../images/skin/information.png" alt="Add icon" />
                    <b>Search for '${params.q.encodeAsHTML()}%'</b>
                </g:link>
                <br />
                <g:link action="search" params="[q : noJokerTerm + '_',
                        'section.id': params['section.id'],
                        'category.id': params['category.id'],
                        'source.id': params['source.id']]">
                    <img src="../images/skin/information.png" alt="Add icon" />
                    <b>Search for '${params.q.encodeAsHTML()}_'</b>
                </g:link>
            </g:if>

            <br/>
            <p>
                <g:if test="${params.q}">
                    <g:set var="cleanTerm" value="${params.q.trim().replaceAll('[*%~]', '').replaceAll('[*_~]', '')}" />
                    <g:link action="create" params="[term : cleanTerm]">
                        <img src="../images/skin/database_add.png" alt="Add icon" />
                        <b>Create a new concept with the term '${cleanTerm.encodeAsHTML()}'</b>
                    </g:link>
                </g:if>
                <g:else>
                    <g:link action="create"><b>Create a new concept</b></g:link>
                </g:else>
            </p>

            <p class="metaInfo"><br />Search time: ${runTime}ms</p>

        </div>
    </body>
</html>
