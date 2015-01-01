<%@page import="com.vionto.vithesaurus.tools.StringTools" %>
<%@page import="java.util.regex.Pattern" %>
<%@page import="java.util.regex.Matcher" %>

    <g:if test="${params.home != 'true'}">
        <div style="float: right;margin-left:10px"><a href="#" onclick="closePopup();return false;"><img
                src="${createLinkTo(dir:'images',file:'close.png')}" width="20" height="20" alt="${message(code:'popup.alt.attribute')}" title="${message(code:'popup.title.attribute')}"></a></div>
    </g:if>

    <g:if test="${synsetList.size() == 0}">
        <div class="metaInfo" style="margin-top:8px;margin-bottom:4px">
            <g:message code="result.ajax.no.exact.matches.for" args="${[params.q.toString()]}"/>
            <g:if test="${mostSimilarTerm}">
                <g:set var="simTerm" value="${mostSimilarTerm.term}"/>
                - meinten Sie <g:link url="${createLinkTo(dir:'synonyme')}/${simTerm.encodeAsURL()}">${simTerm.encodeAsHTML()}</g:link>?
            </g:if>
        </div>
    </g:if>
    <g:else>
        <%
        String quotedQuery = Pattern.quote(params.q?.trim())
        // treat o = ö - this is debatable, but it's how MySQL searches, so highlight this way:
        // TODO: this had to be commented out again because it doesn't work with quoting the input,
        // which is needed to avoid an exception if a user searches for e.g. "foo) "
        //umlautNormalizedQuery = umlautNormalizedQuery.replaceAll('[ÜüUu]', '[ÜüUu]').replaceAll('[ÄäAa]', '[ÄäAa]').replaceAll('[ÖöOo]', '[ÖöOo]')
        String directPatternStr = "\\b(" + quotedQuery + ")\\b";
        Pattern directPattern = Pattern.compile(directPatternStr, Pattern.CASE_INSENSITIVE);
        %>
        <g:each in="${synsetList}" status="i" var="synset">
            <div style="margin-top:4px;margin-bottom:10px">
                 <g:set var="firstVal" value="${true}"/>
                 <g:if test="${i < 10}">
                   <g:each in="${synset?.terms?.sort()}" var="term">
                       <g:set var="match" value='${term.toString()?.toLowerCase()}'/>
                       <g:if test="${!firstVal}">
                          <span class="d">&middot;</span>
                       </g:if>
                       <%
                       Matcher directMatcher = directPattern.matcher(term.toString());
                       String directMatchingTerm = directMatcher.replaceAll("___beginhighlight___\$1___endhighlight___");
                       directMatchingTerm = directMatchingTerm.encodeAsHTML();
                       directMatchingTerm = directMatchingTerm.replace("___beginhighlight___", "<span class=\"synsetmatchDirect\">");
                       directMatchingTerm = directMatchingTerm.replace("___endhighlight___", "</span>");
                       if (term.normalizedWord2?.equalsIgnoreCase(params.q?.trim())) {
                           directMatchingTerm = '<span class="synsetmatchDirect">' + directMatchingTerm + '</span>'
                       }
                       %>
                       <g:link url="${createLinkTo(dir:'synonyme')}/${term.toString().encodeAsURL()}">
                           ${directMatchingTerm}
                           <g:render template="metaInfo" model="${[term:term]}"/>
                       </g:link>
                       <g:set var="firstVal" value="${false}"/>
                   </g:each>
                 </g:if>
            </div>
        </g:each>
        <g:if test="${synsetList.size() > 10}">
          <span class="metaInfo"><g:message code="result.ajax.more.exact.matches" /></span>
            <g:link controller="synset" action="search" params="${[q: params.q]}"><g:message code="result.ajax.show.all.exact.matches" /></g:link>
        </g:if>
    </g:else>

    <hr style="margin-bottom:5px"/>

    <g:if test="${substringSynsetList.size() == 0}">
        <div class="metaInfo">
            <g:if test="${params.q.trim().length() < minLengthForSubstringQuery}">
                <g:message code="result.ajax.too.short" args="${[minLengthForSubstringQuery]}"/>
            </g:if>
            <g:else>
                <g:message code="result.ajax.no.substring.matches.for" args="${[params.q]}"/>
            </g:else>
        </div>
    </g:if>
    <g:else>
        <%
        Pattern pattern = Pattern.compile("(" + Pattern.quote(params.q.encodeAsHTML()) + ")", Pattern.CASE_INSENSITIVE);
        %>
        <g:each in="${substringSynsetList}" status="i" var="synset">
            <g:if test="${i < 5}">
                <div style="margin-bottom:10px">
                    <g:set var="firstVal" value="${true}"/>
                    <g:each in="${synset?.terms?.sort()}" var="term">
                        <g:set var="match" value='${term.toString()?.toLowerCase()}'/>
                        <g:if test="${!firstVal}">
                            <span class="d">&middot;</span>
                        </g:if>
                        <%
                            Matcher matcher = pattern.matcher(term.toString().encodeAsHTML());
                            String matchingTerm = matcher.replaceAll("<span class=\"synsetmatchDirect\">\$1</span>");
                        %>
                        <g:link url="${createLinkTo(dir:'synonyme')}/${term.toString().encodeAsURL()}">
                            ${matchingTerm}
                            <g:render template="metaInfo" model="${[term:term]}"/>
                        </g:link>
                        <g:set var="firstVal" value="${false}"/>
                    </g:each>
                </div>
            </g:if>
        </g:each>
        <g:if test="${substringSynsetList.size() > 5}">
          <span class="metaInfo"><g:message code="result.ajax.more.substring.matches" /></span>
            <g:link controller="synset" action="substring" params="${[q: params.q]}"><g:message code="result.ajax.show.all.exact.matches" /></g:link>
        </g:if>
    </g:else>
        
    <hr style="margin-bottom:20px"/>
        
    <table style="opacity: 0.7">
      <tr>
        <td valign="top">
          <g:link controller="synset" action="create" params="[term : params.q]">
               <img src="${createLinkTo(dir:'images',file:'icon-add.png')}" width="11" height="11" alt="Add icon" />
          </g:link>
        </td>
        <td>&nbsp;</td>
        <td>
          <g:link controller="synset" action="create" params="[term : params.q]">
               <g:message code="result.create.synset" args="${[params.q]}" />
          </g:link>
        </td>
      </tr>
      <g:if test="${params.forumLink != 'false'}">
        <tr>
          <td colspan="3"><g:render template="/synset/forumlink" /></td>
        </tr>
      </g:if>
    </table>
