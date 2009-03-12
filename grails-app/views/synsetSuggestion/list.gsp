
<%@ page import="com.vionto.vithesaurus.SynsetSuggestion" %>
<html>
    <head>
        <g:javascript library="prototype" />
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title>Concept Suggestions (${hits} of ${totalHits})</title>
        <script type="text/javascript">
        <!--
            function showProgress(id) {
                $('spinner'+id).show();
            }
            function hideProgress(id) {
                $('spinner'+id).hide();
            }
            function prepareApprove(id, word) {
                $('spinner'+ id).show();
                new Ajax.Request("${createLink(controller: 'synsetSuggestion', 
                        action: 'relatedWords')}?suggestionId=" + id + "&word=" + encodeURI(word),
                    {
                        method: 'get',
                        onSuccess: function(transport) {
                            $('relatedWords'+id).update(transport.responseText);
                            $('spinner'+ id).hide();
                        },
                        onFailure: function(transport) {
                            $('relatedWords'+id).update(transport.responseText);
                            $('spinner'+ id).hide();
                        }
                    });
            }
            // called when the synset has been created successfully.
            function approved(id) {
                // disable the radio buttons, as it doesn't make sense to
                // reject or unreject a word once a concept with this word
                // has been created:
                $('opinion_neutral_'+ id).setAttribute('disabled', 'disabled');
                $('opinion_reject_'+ id).setAttribute('disabled', 'disabled');
                // select approval radio button:
                $('opinion_approve_'+ id).checked = true;
                $('opinion_approve_'+ id).setAttribute('disabled', 'disabled');
                // There may be an Ajax response like "rejected" displayed from
                // the previous rejection, remove it:
                $('update'+id).update("");
            }
            // Add a word to the list of rejected words:
            function reject(id, word) {
                $('spinner'+ id).show();
                new Ajax.Request("${createLink(controller: 'rejectedWord',
                        action:'reject')}?word=" + encodeURI(word),
                    {
                        method: 'post',
                        onSuccess: function(transport) {
                            $('update'+id).update(transport.responseText);
                            $('spinner'+ id).hide();
                        },
                        onFailure: function(transport) {
                            $('update'+id).update(transport.responseText);
                            $('spinner'+ id).hide();
                        }
                    });
                $('suggestion'+id).setStyle({textDecoration: 'line-through'});
            }
            // Remove a word from the list of rejected words:
            function unreject(id, word) {
                $('spinner'+ id).show();
                new Ajax.Request("${createLink(controller: 'rejectedWord',
                        action:'unreject')}?word=" + encodeURI(word),
                    {
                        method: 'post',
                        onSuccess: function(transport) {
                            $('update'+id).update(transport.responseText);
                            $('spinner'+ id).hide();
                        },
                        onFailure: function(transport) {
                            $('update'+id).update(transport.responseText);
                            $('spinner'+ id).hide();
                        }
                    });
                $('suggestion'+id).setStyle({textDecoration: 'none'});
            }
        // -->
        </script>
    </head>
    <body>

        <div class="body">
            
            <h1>Concept Suggestions (${hits} of ${totalHits})</h1>
            
            <p><g:link controller="rejectedWord">Also see the list of rejected words.</g:link></p>
            <br />
            
            <g:if test="${flash.message}">
                <div class="message">${flash.message}</div>
            </g:if>
            
            <div class="nohoverlist">
                
                <form method="get">
                    <g:if test="${params.prefix}"><input type="hidden" name="prefix" value="${params.prefix.encodeAsHTML()}" /></g:if>
                    <g:if test="${params.sort}"><input type="hidden" name="sort" value="${params.sort.encodeAsHTML()}" /></g:if>
                    <g:if test="${params.order}"><input type="hidden" name="order" value="${params.order.encodeAsHTML()}" /></g:if>
                    <g:if test="${params.max}"><input type="hidden" name="max" value="${params.max.encodeAsHTML()}" /></g:if>
                    Filter (use % as joker):
                    <input name="filter" value="${params?.filter?.encodeAsHTML()}" />
                    <input type="submit" value="Go" />
                    <input type="submit" name="clear" value="Clear" />
                </form>
                
                <%
                String[] chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ".split("")
                %>
                <div class="paginateButtons">
                    <g:set var="origPrefix" value="${params.prefix}" />
                    <g:set var="origOffset" value="${params.offset}" />
	                <g:each in="${chars}" var="ch">
	                   <g:set var="displayPrefix" value="${ch}" />
	                   <g:if test="${displayPrefix == ''}">
	                       <g:set var="displayPrefix" value="${'[any]'}" />
	                   </g:if>
	                   <g:if test="${ch == origPrefix || (!origPrefix && ch == '')}">
                           <span class="strongCurrentStep">${displayPrefix}</span>
	                   </g:if>
	                   <g:else>
                           <%
                           tempParams = params
                           tempParams.prefix = ch
                           tempParams.offset = 0
                           %>
                           <g:link class="step" params="${tempParams}">${displayPrefix}</g:link>
	                   </g:else>
	                </g:each>
                    <%
                    params.prefix = origPrefix
                    params.offset = origOffset
                    %>
                </div>
                
                <table>
                    <thead>
                        <tr>
                            <th>Status&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</th>
                            <%
                            // keep parameters when re-sorting by column:
                            def tempParams = [:]
                            for (elem in params) {
                                if (elem.key != "sort" && elem.key != "order") {
                                    tempParams[elem.key] = elem.value
                                }
                            }
                            %>
                   	        <g:sortableColumn params="${tempParams}" property="term" title="Suggested Word" />
                   	        <g:sortableColumn params="${tempParams}" property="termCount" title="Word Count" />
                        </tr>
                    </thead>
                    <tbody>
                    <g:if test="${hits > 0}">
                        <tr class='prop'>
                            <td valign='bottom' style="padding-bottom:0px">
                                <img src="${createLinkTo(dir:'images',file:'questionmark.png')}" alt="Question Mark"
                                    title="Word with unknown status" />
                                <img src="${createLinkTo(dir:'images',file:'wrongway.png')}" alt="Wrong Way Sign"
                                    title="Select to reject words" />
                                <img src="${createLinkTo(dir:'images',file:'smiley.png')}" alt="Smiley"
                                    title="Select to prepare approval" />
                            </td>
                        </tr>
                    </g:if>
                    <g:each in="${synsetSuggestionList}" status="i" var="synsetSuggestion">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        
                            <td width="7%">
                                <g:set var="buttonSelection" value="neutral" />
                                <g:if test="${synsetSuggestion.identicalWord}">
                                    <g:set var="buttonSelection" value="approve" />
                                </g:if>
                                <g:elseif test="${synsetSuggestion.rejectionId > 0}">
                                    <g:set var="buttonSelection" value="reject" />
                                </g:elseif>
                                <span class="neutralLinkRadioButton"><g:managedRadio
                                    disabled="${buttonSelection == 'approve'}"
                                    id="opinion_neutral_${synsetSuggestion.id}" 
                                    name="opinion_${synsetSuggestion.id}" value="${synsetSuggestion.id}"
                                    checked="${buttonSelection == 'neutral'}" 
                                    onchange="unreject(${synsetSuggestion.id},
                                    '${JavaScriptUtils.javaScriptEscape(synsetSuggestion.suggestedWord)}')" /></span>
                                <span class="rejectLinkRadioButton"><g:managedRadio
                                    disabled="${buttonSelection == 'approve'}" 
                                    id="opinion_reject_${synsetSuggestion.id}"
                                    name="opinion_${synsetSuggestion.id}" value="${synsetSuggestion.id}"
                                    checked="${buttonSelection == 'reject'}" 
                                    onchange="reject(${synsetSuggestion.id},
                                    '${JavaScriptUtils.javaScriptEscape(synsetSuggestion.suggestedWord)}')" /></span>
                                <span class="approveLinkRadioButton"><g:managedRadio
                                    disabled="${buttonSelection == 'approve'}"
                                    id="opinion_approve_${synsetSuggestion.id}" 
                                    name="opinion_${synsetSuggestion.id}" value="${synsetSuggestion.id}"
                                    checked="${buttonSelection == 'approve'}"
                                    onchange="prepareApprove(${synsetSuggestion.id},
                                    '${JavaScriptUtils.javaScriptEscape(synsetSuggestion.suggestedWord)}')" /></span>
                            </td>
                            
                            <td>
                                <g:if test="${synsetSuggestion.identicalWord || synsetSuggestion.rejectionId > 0}">
                                    <span style="text-decoration: line-through">
                                </g:if>
                                <g:else>
                                    <span>
                                </g:else>
                                <strong id="suggestion${synsetSuggestion.id}"
                                    >${synsetSuggestion.suggestedWord.encodeAsHTML()}</strong>
                                </span>
                                <g:if test="${buttonSelection == 'approve'}">
                                    <g:link controller="synset" action="search"
                                        params="${[q: synsetSuggestion.suggestedWord]}">[Search]</g:link>
                                </g:if>
                                &nbsp;&nbsp;
                                <a href="http://www.google.de/search?q=%22${synsetSuggestion.suggestedWord.encodeAsURL()}%22"
                                    target="_blank">[Google]</a>
                                
                                <div id="update${synsetSuggestion.id}"></div>
                                
                                <div id="spinner${synsetSuggestion.id}" style="display:none;">
                                    <img src="${createLinkTo(dir:'images',file:'spinner.gif')}" alt="Spinner" />
                                </div>
                                <div id="relatedWords${synsetSuggestion.id}" style="display:inline"></div>
                            </td>
                            
                            <td>${synsetSuggestion.wordCount.encodeAsHTML()}</td>
                            
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
            
            <form action="list" method="get">
                <div class="paginateButtons">
                    <g:paginate total="${hits}" params="${[prefix: params.prefix, filter: params.filter]}" />
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    Matches per page: <g:select name="max" from="${[10,25,50,100]}" value="${params.max}"/>
                    <g:if test="${params.filter}"><input type="hidden" name="filter" value="${params.filter.encodeAsHTML()}" /></g:if>
                    <g:if test="${params.prefix}"><input type="hidden" name="prefix" value="${params.prefix.encodeAsHTML()}" /></g:if>
                    <g:if test="${params.sort}"><input type="hidden" name="sort" value="${params.sort.encodeAsHTML()}" /></g:if>
                    <g:if test="${params.order}"><input type="hidden" name="order" value="${params.order.encodeAsHTML()}" /></g:if>
                    <g:if test="${params.offset}"><input type="hidden" name="offset" value="${params.offset.encodeAsHTML()}" /></g:if>
                    <g:actionSubmit action="list" value="Go" />
                </div>
            </form>
        </div>
    </body>
</html>
