<%@page import="com.vionto.vithesaurus.*" %>

    <div class='leftColumn name'>
        <h2 class="noTopMargin">${title}</h2>
    </div>
    
    <div valign='top' class='rightColumn value ${hasErrors(bean:synset,field:'synsetLinks','errors')}'>

    <g:set var="nymCount" value="${0}"/>
    
    <table>

        <%
            Set<String> deleteIds = new HashSet<>();
        %>
        <g:each var='link' in='${synsetLinks}'>
           <g:if test="${link.linkType.toString() == linkTypeName}">
            <tr style="vertical-align: top">
           
                <td>
                    <input type="hidden" id="delete_${linkTypeName}_${link.id}" name="delete_${linkTypeName}_${link.id}" value=""/>
                    <%
                        String id = "delete_${linkTypeName}_${link.id}";
                        if (deleteIds.contains(id)) {
                            continue;
                        }
                        deleteIds.add(id);
                    %>        
                    <g:if test="${editable}">
                        <a href="#" onclick="deleteItem('${linkTypeName}', '${link.id}');return false;"><img
                            class="editIcon" align="top" src="${resource(dir:'images',file:'delete.png')}" alt="delete icon" title="${message(code:'edit.select.to.delete.link')}"/></a>
                        </g:if>
                    <g:else>
                        <img align="top" class="brightIcon" src="${resource(dir:'images',file:'delete.png')}" alt="delete icon"/>
                    </g:else>
                </td>

                <td>
                    <div id="${linkTypeName}_${link.id}">
                        <g:link title="${link.targetSynset.toShortStringWithShortLevel(20, true)}" controller='synset' action='edit'
                            id='${link.targetSynset.id}'>${link.targetSynset.toShortStringWithShortLevel(3, true).encodeAsHTML()}</g:link>
                    </div>
                </td>
                            
                <%
                displayedSynsets.add(link.targetSynset.id)
                nymCount++
                %>
            </tr>
           </g:if>
        </g:each>

    </table>

        <g:if test="${nymCount == 0 && (linkTypeName == 'Unterbegriff' || !editable)}">
             <li class="noBulletItemList"><span class="noMatches"><g:message code="edit.not.set"/></span></li>
        </g:if>        

        <g:if test="${editable && showAddLink}">
        <li class="noBulletItemList">
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
                    <g:textField name="q${linkTypeName}" value="" onkeypress="return doNotSubmitOnReturn(event);" onkeyup="return doSynsetSearchOnKeyUp(event, '${linkTypeName}', '/synset/ajaxSearch');" autocomplete="off"/>
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
        
    </div>
    <div style="clear: both"></div>
