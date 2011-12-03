<%@page import="com.vionto.vithesaurus.tools.StringTools" %>
<%@page import="java.util.regex.Pattern" %>
<%@page import="java.util.regex.Matcher" %>

    <g:if test="${synsetList.size() == 0}">
        <div class="metaInfo" style="margin-top:4px;margin-bottom:4px">
            <g:message code="result.ajax.no.exact.matches.for" args="${[params.q.toString()?.encodeAsHTML()]}"/>
        </div>
    </g:if>
    <g:else>
        <g:each in="${synsetList}" status="i" var="synset">
            <div style="margin-top:4px;margin-bottom:4px">
                 <g:set var="firstVal" value="${true}"/>
                 <g:each in="${synset?.otherTerms()?.sort()}" var="term">
                     <g:set var="match" value='${term.toString()?.toLowerCase()}'/>
                     <g:set var="cleanedMatch" value='${StringTools.normalize(match).equals(params.q)}'/>
                     <g:if test="${!firstVal}">
                        <span class="d">&middot;</span>
                     </g:if>
                     <g:if test="${cleanedMatch}">
                        <span class="synsetmatch">
                     </g:if>
                     ${term.toString()?.encodeAsHTML()}
                     <g:if test="${term.level}">
                       <span class="metaInfo">(${term.level.shortLevelName})</span>
                     </g:if>
                     <g:if test="${cleanedMatch}">
                        </span>
                     </g:if>
                     <g:set var="firstVal" value="${false}"/>
                 </g:each>
                 <g:link controller="synset" action="edit" id="${synset.id}">&gt;&gt;&nbsp;mehr</g:link>
            </div>
        </g:each>
    </g:else>
        
    <hr style="margin-bottom:5px"/>

    <g:if test="${substringSynsetList.size() == 0}">
        <div class="metaInfo">
            <g:if test="${params.q.trim().length() < minLengthForSubstringQuery}">
                <g:message code="result.ajax.too.short" args="${[minLengthForSubstringQuery]}"/>
            </g:if>
            <g:else>
                <g:message code="result.ajax.no.substring.matches.for" args="${[params.q.toString()?.encodeAsHTML()]}"/>
            </g:else>
        </div>
    </g:if>
    <g:else>
        <%
        Pattern pattern = Pattern.compile("(" + params.q.encodeAsHTML() + ")", Pattern.CASE_INSENSITIVE);
        %>
        <g:each in="${substringSynsetList}" status="i" var="synset">
             <div style="margin-bottom:4px">
                 <g:set var="firstVal" value="${true}"/>
                 <g:each in="${synset?.otherTerms()?.sort()}" var="term">
                     <g:set var="match" value='${term.toString()?.toLowerCase()}'/>
                     <g:set var="cleanedMatch" value='${StringTools.normalize(match).contains(params.q)}'/>
                     <g:if test="${!firstVal}">
                        <span class="d">&middot;</span>
                     </g:if>
                     <%
                     Matcher matcher = pattern.matcher(term.toString().encodeAsHTML());
                     String matchingTerm = matcher.replaceAll("<span class=\"synsetmatch\">\$1</span>");
                     %>
                     ${matchingTerm}
                     <g:if test="${term.level}">
                       <span class="metaInfo">(${term.level.shortLevelName})</span>
                     </g:if>
                     <g:set var="firstVal" value="${false}"/>
                 </g:each>
                 <g:link controller="synset" action="edit" id="${synset.id}">&gt;&gt;&nbsp;mehr</g:link>
             </div>
        </g:each>
    </g:else>
        
    <hr style="margin-bottom:5px"/>
        
    <table>
      <tr>
        <td valign="top">
          <g:link controller="synset" action="create" params="[term : params.q]">
               <img src="${createLinkTo(dir:'images',file:'icon-add.png')}" alt="Add icon" />
          </g:link>
        </td>
        <td>&nbsp;</td>
        <td>
          <g:link controller="synset" action="create" params="[term : params.q]">
               <g:message code="result.create.synset" args="${[params.q.encodeAsHTML()]}" />
          </g:link>
        </td>
      </tr>
    </table>
