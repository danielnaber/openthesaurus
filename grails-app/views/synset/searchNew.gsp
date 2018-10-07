<%@page import="com.vionto.vithesaurus.*" %>

    <div class="resultColumn" style="margin-right:37px">
        <g:render template="mainmatches"/>

        <g:set var="cleanTerm" value="${params.q.trim()}" />
        <g:if test="${totalMatches == 0}">
            <g:render template="addterm" model="${[term:cleanTerm]}" />
        </g:if>

        <hr style="margin-top:20px" />

        <g:render template="partialmatches"/>

        <hr style="margin-top:20px" />

        <h2><g:message code='result.matches.no.like' /></h2>

        <g:render template="addterm" model="${[term:cleanTerm]}" />

        <g:render template="forumlink" />
    </div>

    <div class="resultColumn">
        <%-- this is specific to German OpenThesaurus, but it doesn't harm for other languages --%>
            <g:if test="${remoteWordLookup || remoteGenderLookup || remoteMistakeLookup}">
                <div style="margin-top: 20px">
            </g:if>
            <g:if test="${remoteWordLookup}">
                <div style="margin-bottom: 5px">
                    <a href="${remoteWordLookup.url.encodeAsHTML()}">Tipps zur Rechtschreibung von '${params.q.trim().encodeAsHTML()}'
                        <br/>auf korrekturen.de</a>
                </div>
            </g:if>
            <g:if test="${remoteGenderLookup}">
                <div style="margin-bottom: 5px">
                    <g:if test="${remoteGenderLookup.metaInfo.contains(' / ')}">
                        Je nach Bedeutung heißt es ${remoteGenderLookup.metaInfo.encodeAsHTML().replaceAll("&lt;i&gt;", "<i>").replaceAll("&lt;/i&gt;", "</i>")}
                        ${remoteGenderLookup.term.encodeAsHTML()}.<br/>Details auf <a href="${remoteGenderLookup.url.encodeAsHTML()}">korrekturen.de</a>.
                    </g:if>
                    <g:else>
                        Der Artikel von ${remoteGenderLookup.term.encodeAsHTML()} ist: ${remoteGenderLookup.metaInfo.encodeAsHTML().replaceAll("&lt;i&gt;", "<i>").replaceAll("&lt;/i&gt;", "</i>")}
                        <br/>Mehr auf <a href="${remoteGenderLookup.url.encodeAsHTML()}">korrekturen.de</a>.
                    </g:else>
                </div>
            </g:if>
            <g:if test="${remoteMistakeLookup}">
                <div style="margin-bottom: 5px">
                    <a href="${remoteMistakeLookup.url.encodeAsHTML()}">Tipps zu typischen Fehlern mit '${params.q.trim().encodeAsHTML()}'
                        <br/>auf korrekturen.de</a>
                </div>
            </g:if>
            <g:if test="${remoteWordLookup || remoteGenderLookup || remoteMistakeLookup}">
                <hr style="margin-top:20px" />
                </div>
            </g:if>
            <g:else>
                <g:render template="/ads/resultpage_results2"/>
            </g:else>
        <%-- end of part that's specific to German OpenThesaurus --%>

        <g:render template="/synset/ad"/>
                
        <g:if test="${params.ad == '1'}">
            <div style="margin-top:20px; text-align: center">
                <a rel="nofollow" href="https://languagetool.org"><img align="top" src="${resource(dir:'images/ads',file:'ad180x150.png')}" alt="ad space"/></a>
                <br><span style="color:#999999">Anzeige</span>
                <hr style="margin-top:20px" />
            </div>
        </g:if>

        <g:render template="wiktionary"/>

        <hr style="margin-top:20px" />

        <g:render template="wikipedia"/>

        <g:render template="/ads/resultpage_results"/>

        <hr style="margin-top:20px" />

        <h2><g:message code="result.external.search" args="${[params.q]}"/></h2>

        <g:render template="/external_links" model="${[q:params.q]}"/>
    </div>
    
    <div style="clear: both"></div>
