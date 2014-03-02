<%@page import="com.vionto.vithesaurus.*" %>

<tr class='prop'>
    <td valign='top' class='name'>
        <h2 class="noTopMargin">${title}</h2>
    </td>
    <td valign='top' class='value ${hasErrors(bean:synset,field:'synsetLinks','errors')}'>

    <g:set var="nymCount" value="${0}"/>
    
    <ul style="margin-top:0">
    
        <g:each var='link' in='${synsetLinks}'>
           <g:if test="${link.linkType.toString() == linkTypeName}">
           
                <li class="checkboxList">
                    <input type="hidden" id="delete_${linkTypeName}_${link.id}" name="delete_${linkTypeName}_${link.id}" value=""/>
                    <div id="${linkTypeName}_${link.id}">
        
                        <g:if test="${session.user}">
                          <a href="#" onclick="deleteItem('${linkTypeName}', '${link.id}');return false;"><img
                            align="top" src="${resource(dir:'images',file:'delete2.png')}" alt="delete icon" title="${message(code:'edit.select.to.delete.link')}"/></a>
                        </g:if>
                        <g:else>
                          <img align="top" src="${resource(dir:'images',file:'delete2_inactive.png')}" alt="delete icon"/>
                        </g:else>

                        <g:link title="${link.targetSynset.toShortStringWithShortLevel(20, true)}" controller='synset' action='edit'
                            id='${link.targetSynset.id}'>${link.targetSynset.toShortStringWithShortLevel(3, true).encodeAsHTML()}</g:link>
                            
                    </div>
                </li>
    
                <%
                displayedSynsets.add(link.targetSynset.id)
                nymCount++
                %>
           </g:if>
        </g:each>
        
        <g:if test="${nymCount == 0 && (linkTypeName == 'Unterbegriff' || !session.user)}">
             <li class="checkboxList"><span class="noMatches"><g:message code="edit.not.set"/></span></li>
        </g:if>        

        <g:if test="${session.user && showAddLink}">
        <li class="checkboxList">
            <div id="addSynsetLink-${linkTypeName}" ${nymCount > 0 ? 'style="margin-top:10px"' : ''}>
                <a href="#" onclick="showNewSynsetLink('${linkTypeName}');return false;"><img align="top" src="${createLinkTo(dir:'images',file:'plus.png')}" alt="Plus"/>&nbsp;<g:message code="edit.add.link" args="${[linkTypeName]}"/></a>
                <g:if test="${linkTypeName == 'Oberbegriff'}">
                     <a href="#" onclick="toggleId('superordinateHelp');return false;">[?]</a>
                </g:if>        
                <g:if test="${linkTypeName == 'Assoziation'}">
                     <a href="#" onclick="toggleId('associationHelp');return false;">[?]</a>
                </g:if>
            </div>
            <g:if test="${linkTypeName == 'Oberbegriff'}">
                <div id="superordinateHelp" style="display: none">
                    <g:render template="/synset/superordinateHelp" />
                </div>
            </g:if>        
            <g:if test="${linkTypeName == 'Assoziation'}">
                <div id="associationHelp" style="display: none">
                    <g:render template="/synset/associationHelp" />
                </div>
            </g:if>
            <g:set var="linkType" value="${LinkType.findByLinkName(linkTypeName)}"/>
            <g:if test="${linkType}">
                <div id="addSynset-${linkTypeName}" style="display:none;margin-top:5px">
                    <g:textField name="q${linkTypeName}" value="" onkeypress="return doNotSubmitOnReturn(event);" onkeyup="return doSynsetSearchOnKeyUp(event, '${linkTypeName}', 'synset/ajaxSearch');" autocomplete="off"/>
                    <input type="hidden" name="linkType${linkTypeName}.id" value="${linkType.id}">
    
                    <span id="addSynsetProgress${linkTypeName}" style="visibility:hidden;position:absolute">
                        <img src="${createLinkTo(dir:'images',file:'spinner.gif')}" alt="Spinner image"
                             title="Searching..."/>
                    </span>
                    <div id="synsetLink${linkTypeName}" style="min-height:200px">
                    </div>
                </div>
            </g:if>
            <g:else>
                <div class="error">Error: link type '${linkTypeName.encodeAsHTML()}' not found</div>
            </g:else>
         </li>
        </g:if>
    
    </ul>
    
    </td>
</tr>
<tr><td></td></tr>
