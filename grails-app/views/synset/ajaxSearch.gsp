
    <g:if test="${synsetList.size() == 0}">
    	<g:message code="result.no.matches.for" args="${[params.q.toString()?.encodeAsHTML()]}"/>
    </g:if>
    <g:else>
	    <table>
	        <g:each in="${synsetList}" status="i" var="synset">
	             <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
	                 <td><g:radio name="targetSynset${params.linkTypeName.encodeAsHTML()}.id" value="${synset.id}"
	                    checked="${i == 0 ? true : false }"/></td>
	                 <td>
	                     <g:link target="_blank" action="edit" id="${synset.id}">
	                     	 <g:set var="firstVal" value="${true}"/>
	                         <g:each in="${synset?.otherTerms()?.sort()}" var="term">
	                             <g:if test="${!firstVal}">
	                             	<span class="d">&middot;</span>
	                             </g:if>
	                             ${term.toString()?.encodeAsHTML()}
                                 <g:if test="${term.level}">
                                   (${term.level.shortLevelName})
                                 </g:if>
	                             <g:set var="firstVal" value="${false}"/>
	                         </g:each>
	                     </g:link>
	                 </td>
	             </tr>
	        </g:each>
	    </table>
    </g:else>
