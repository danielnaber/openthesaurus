<%@page import="com.vionto.vithesaurus.*" %>

<tr class='prop'>
    <td valign='top' class='name'></td>
    <td valign='top' class='value'>
        <div style="margin-bottom:3px">${title}:</div>
        <g:set var="nymCount" value="${0}"/>
        <g:each var='link' in='${synsetLinks}'>
            <%-- filter out those suggested links that have already been approved/rejected
            and that are thus listed above in the page: --%>
            <g:if test="${link.linkType.toString() == linkTypeName && !displayedSynsets.contains(link.targetSynset.id)}">
                <span class="neutralLinkRadioButton"><g:managedRadio disabled="${!session.user}" 
                    name="evaluate_suggestion_link_${link.id}" value="neutral" checked="true"/></span>
                <span class="rejectLinkRadioButton"><g:managedRadio disabled="${!session.user}" 
                    name="evaluate_suggestion_link_${link.id}" value="reject" /></span>
                <span class="approveLinkRadioButton"><g:managedRadio disabled="${!session.user}" 
                    name="evaluate_suggestion_link_${link.id}" value="approve" /></span>
                <g:link controller='synset' action='edit'
                    id='${link.targetSynset.id}'>${link.targetSynset.synsetPreferredTerm}</g:link>
                 <g:if test="${reverseLink}">
                    <input type="hidden" name="reverse_${link.id}" value="1"/>
                    <g:set var="subjectId" value="${link.targetSynset.id}"/>
                    <g:set var="objectId" value="${link.synset.id}"/>
                 </g:if>
                 <g:else>
                    <g:set var="subjectId" value="${link.synset.id}"/>
                    <g:set var="objectId" value="${link.targetSynset.id}"/>
                 </g:else>
                <% nymCount++ %>
                <br />
            </g:if>
        </g:each>
        <g:if test="${nymCount == 0}">
             <span class="metaInfo">[none]</span>
        </g:if>
    </td>
</tr>
