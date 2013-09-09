<%@page import="com.vionto.vithesaurus.tools.StringTools" %>
    <g:if test="${terms.size() == 0}">
        <g:message code="result.no.matches.for" args="${[params.q.toString()?.encodeAsHTML()]}"/>
    </g:if>
    <g:else>
	    <table>
	        <g:each in="${terms}" status="i" var="term">
	             <g:set var="radioButtonId" value="radioButtonAntonym${i}"/>
	             <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
	                 <td valign="top"><g:radio id="${radioButtonId}" name="targetAntonymTermId" value="${term.id}"
	                    checked="${false}"/></td>
	                 <td valign="top">
	                     <label for="${radioButtonId}">
	                         <g:set var="firstVal" value="${true}"/>
	                         <g:each in="${term.synset.terms?.sort()}" var="tmpTerm">
                                 <g:set var="match" value='${tmpTerm.toString()?.toLowerCase()}'/>
                                 <g:set var="cleanedMatch" value='${StringTools.normalize(match).equals(params.q)}'/>
	                             <g:if test="${!firstVal}">
	                             	<span class="d">&middot;</span>
	                             </g:if>
	                             <g:if test="${cleanedMatch}">
	                                <span class="synsetmatch">
	                             </g:if>
	                             ${tmpTerm.toString()?.encodeAsHTML()}
                                 <g:if test="${tmpTerm.level}">
                                   (${tmpTerm.level.shortLevelName})
                                 </g:if>
	                             <g:if test="${cleanedMatch}">
	                                </span>
	                             </g:if>
	                             <g:set var="firstVal" value="${false}"/>
	                         </g:each>
	                     </label>
	                     <g:link target="_blank" action="edit" id="${term.id}">&gt;&gt;&nbsp;Details</g:link>
	                 </td>
	             </tr>
	        </g:each>
	    </table>
	    <div class="metaInfo">Tipp: Auswahl mit den rauf/runter Cursor-Tasten</div>

    </g:else>

    <table>
      <tr>
        <td valign="top">
          <g:link controller="synset" action="create" params="[term : params.q]" target="_blank">
               <img src="${createLinkTo(dir:'images',file:'icon-add.png')}" width="11" height="11" alt="Add icon" />
          </g:link>
        </td>
        <td>&nbsp;</td>
        <td>
          <g:link controller="synset" action="create" params="[term : params.q]" target="_blank">
               <g:message code="result.create.synset" args="${[params.q]}" />
          </g:link>
        </td>
      </tr>
    </table>
