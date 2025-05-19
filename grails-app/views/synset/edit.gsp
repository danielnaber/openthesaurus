<%@page import="com.vionto.vithesaurus.tools.StringTools; com.vionto.vithesaurus.*" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title><g:message code='edit.title' args="${[synset.toShortString()]}"/></title>
        <script type="text/javascript" src="${createLinkTo(dir:'js',file:'blockies.js')}"></script>
        <g:render template="/taggingIncludes" model="${[readOnly: !session.user || readOnlyMode]}"/>
        <g:if test="${synset?.isVisible == false || params.offset}">
          <meta name="robots" content="noindex" />
        </g:if>
        <script type="text/javascript">
        <!--

          function deleteItem(id, termId) {
            var hiddenFieldName = 'delete_' + id + '_' + termId;
            var deleted = document.getElementById(hiddenFieldName).value == 'delete';
            var divName = id + '_' + termId;
            if (deleted) {
              document.getElementById(hiddenFieldName).value = '';
              document.getElementById(divName).style.textDecoration = '';
            } else {
              document.getElementById(hiddenFieldName).value = 'delete';
              document.getElementById(divName).style.textDecoration = 'line-through';
            }
            return false;
          }

          <g:render template="completion"/>

          function showNewTerm() {
            document.getElementById('newTermLink').style.display='none';
            document.getElementById('newTerm').style.display='block';
            document.editForm.word_0.focus();
            return false;
          }

          function showNewCategory() {
            document.getElementById('newCategoryLink').style.display='none';
            document.getElementById('newCategory').style.display='block';
            return false;
          }

          function showChangeCategory() {
            document.getElementById('changeCategoryLink').style.display='none';
            document.getElementById('newCategory').style.display='block';
            return false;
          }

          function showNewSynsetLink(linkType) {
            document.getElementById('addSynsetLink-' + linkType).style.display='none';
            document.getElementById('addSynset-' + linkType).style.display='block';
            document.editForm["q" + linkType].focus();
            return false;
          }

          function showAddComment() {
            document.getElementById('addCommentLink').style.display='none';
            document.getElementById('addComment').style.display='block';
            document.editForm.userComment.focus();
            return false;
          }

          function toggleId(divId) {
            if (document.getElementById(divId).style.display == 'block') {
                document.getElementById(divId).style.display='none';
             } else {
                document.getElementById(divId).style.display='block';
             }
          }

          function toggleDeleteButton() {
            var divId = 'mainSaveButton';
            if (document.getElementById(divId).disabled) {
              document.getElementById(divId).disabled = false;
            } else {
              document.getElementById(divId).disabled = 'disabled';
            }
            toggleId('deleteButton');
          }

        // -->
        </script>
    </head>
    <body>

        <hr />

        <h1 style="margin-bottom:12px"><g:message code='edit.headline' args="${[synset.toShortString()]}"/></h1>

        <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
        </g:if>

        <g:hasErrors bean="${synset}">
        <div class="error">
            <g:renderErrors bean="${synset}" as="list" />
        </div>
        </g:hasErrors>

        <g:hasErrors bean="${newTerm}">
        <div class="error">
            <g:renderErrors bean="${newTerm}" as="list" />
        </div>
        </g:hasErrors>

        <g:if test="${!synset?.isVisible}">
            <div class="warning"><g:message code='edit.invisible'/></div>
            <div class="invisibleSynset">
        </g:if>

        <g:if test="${!session.user || readOnlyMode}">
            <g:set var="disabled" value="disabled='true'"/>
            <g:set var="editable" value="${false}"/>
        </g:if>
        <g:else>
            <g:set var="editable" value="${true}"/>
        </g:else>

        <g:form controller="synset" method="post" name="editForm">
            <input type="hidden" name="id" value="${synset?.id}" />
            <input type="hidden" name="synset.id" value="${synset?.id}" />
            <div class="dialog">

            <div class='leftColumn'>
                <h2 class="noTopMargin"><g:message code='edit.terms'/></h2>
            </div>
            
            <div class='rightColumn value ${hasErrors(bean:synset,field:'terms','errors')}'>

                <table>
                    <g:set var="previousLanguage" value=""/>
                    <g:each var='t' in='${synset?.sortedTerms()}'>
                        <tr style="vertical-align:top">
                        <td>
                            <input type="hidden" id="delete_termId_${t.id}" name="delete_${t.id}" value=""/>
                            <g:if test="${editable}">
                                <a href="#" onclick="deleteItem('termId', '${t.id}');return false;"><img
                                        align="top" src="${resource(dir:'images',file:'delete.png')}" alt="delete icon" title="${message(code:'edit.select.to.delete')}"/></a>
                            </g:if>
                            <g:else>
                                <img align="top" class="brightIcon" src="${resource(dir:'images',file:'delete.png')}" alt="delete icon"/>
                            </g:else>
                        </td>
                        <td>
                            <g:link class="termMetaInfo otherMeaningSearchLink" controller='term' action='edit' id='${t.id}'>
                                <img align="top" src="${resource(dir:'images',file:'edit.png')}" alt="edit icon"/></g:link>
                        </td>
                        <td>

                            <div id="termId_${t.id}">

                                <strong>${t.toString()?.encodeAsHTML()}</strong>

                                <g:render template="audio" model="${[term:t]}"/>

                                <g:render template="/tag/termTags" model="${[term: t]}"/>

                                <g:if test="${t.level}">
                                    <span class="termMetaInfo">${t.level.toString()?.encodeAsHTML()}</span>
                                </g:if>
                                <g:set var="termCount" value="${t.listHomonyms().size()}"/>

                                <span title="${message(code:'edit.find.all.meanings', args: [StringTools.normalizeParenthesis(t.word)])}"><g:link
                                        class="termMetaInfo otherMeaningSearchLink" action="search" params="[q : StringTools.normalizeParenthesis(t.word)]">[${termCount}]</g:link></span>

                                <g:if test="${t.userComment}">
                                    <div>
                                        <span class="termMetaInfo">${StringTools.wikipediaUrlsToLinks(t.userComment.encodeAsHTML())}</span>
                                    </div>
                                </g:if>

                            </div>

                            <g:set var="previousLanguage" value="${t.language}"/>

                            <g:set var="termLinkInfos" value="${t.termLinkInfos().sort()}"/>
                            <g:if test="${termLinkInfos.size() > 0}">
                                <div>
                                    <g:set var="prevLinkName" value=""/>
                                    <g:each var='termLinkInfo' in='${termLinkInfos}'>
                                        <g:if test="${termLinkInfo.getLinkName() == 'Antonym' && termLinkInfo.getLinkName() == prevLinkName}">
                                            &ndash;
                                        </g:if>
                                        <g:elseif test="${termLinkInfo.getLinkName() == 'Antonym' && termLinkInfos.size() > 1}">
                                            <g:message code="edit.term.antonyms"/>
                                        </g:elseif>
                                        <g:elseif test="${termLinkInfo.getLinkName() == 'Antonym'}">
                                            <g:message code="edit.term.antonym"/>
                                        </g:elseif>
                                        <g:else>
                                            ${termLinkInfo.getLinkName().encodeAsHTML()}:
                                        </g:else>
                                        <g:set var="prevLinkName" value="${termLinkInfo.getLinkName()}"/>
                                        <g:link title="${termLinkInfo.getTerm2().synset.toShortStringWithShortLevel(10, true)}" controller="synset"
                                                action="edit" id="${termLinkInfo.getTerm2().synset.id}">${termLinkInfo.getTerm2().encodeAsHTML()}
                                            <g:if test="${termLinkInfo.getTerm2().level}">
                                                <span class="meta">(${termLinkInfo.getTerm2().level.shortLevelName.encodeAsHTML()})</span>
                                            </g:if>
                                        </g:link>
                                    </g:each>
                                </div>
                            </g:if>
                        </td>
                        </tr>
                    </g:each>
                </table>

                    <li class="noBulletItemList" style="margin-top:10px">
                        <g:if test="${editable}">
                            <div id="newTermLink">
                                <a href="#" onclick="showNewTerm();return false;"><img align="top" src="${createLinkTo(dir:'images',file:'plus.png')}" alt="Plus"/>&nbsp;<g:message code='edit.add.terms'/></a>
                            </div>

                            <% int i = 0; %>
                            <div id="newTerm" style="display:none">
                                <g:while test="${i < Integer.parseInt(grailsApplication.config.thesaurus.maxNewTerms)}">
                                    <table>
                                        <tr>
                                            <td style="vertical-align: top"><g:message code="edit.term.term"/>:</td>
                                            <td style="vertical-align: top">
                                                <input onkeypress="return avoidSubmitOnReturn(event);"
                                                       class="termInput" spellcheck="true" name="word_${i}" value="${params['word_'+i].encodeAsHTML()}" />&nbsp;
                                                <g:if test="${Language.findAllByIsDisabled(false)?.size() == 1}">
                                                    <g:hiddenField name="language.id_${i}" value="${Language.findByIsDisabled(false).id}"/>
                                                </g:if>
                                                <g:else>
                                                    <g:select class="submitButton" name="language.id_${i}" optionKey="id" from="${Language.list()}" />&nbsp;
                                                </g:else>
                                                <g:select class="submitButton" name="level.id_${i}" optionKey="id" noSelection="['null':'-']" from="${TermLevel.list()}" />&nbsp;
                                            </td>
                                            <td>
                                                <g:if test="${i == 0}">
                                                    <a href="#" onclick="toggleId('languageLevelHelp');return false;">[?]</a>
                                                    <div id="languageLevelHelp" style="display: none;position: absolute">
                                                        <g:render template="languageLevelHelp" />
                                                    </div>
                                                </g:if>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td></td>
                                            <td style="width:350px">
                                                <input class="tags" name="tags_${i}" type="text" value=""/>
                                            </td>
                                        </tr>
                                        <% i++ %>
                                    </table>
                                    <br/>
                                </g:while>
                            </div>
                        </g:if>
                    </li>

            </div>

            <div style="clear: both"></div>

                        <div class='leftColumn'>
                            <h2 class="noTopMargin"><g:message code='edit.categories'/></h2>
                        </div>

                        <div class='rightColumn value ${hasErrors(bean:synset,field:'synsetLinks','errors')}'>

                        <g:if test="${synset.categoryLinks.size() == 0 && !editable}">
                            <span class="noMatches"><g:message code="edit.not.set"/></span>
                        </g:if>
                        <table style="margin-top:0px">
                            <g:if test="${synset.categoryLinks.size() > 0}">
                              <g:each var='catLink' in='${synset.categoryLinks.sort()}'>
                                  <tr>
                                    <td>
                                    <input type="hidden" id="delete_catLinkId_${catLink.id}" name="delete_catLinkId_${catLink.id}" value=""/>
                                    <div id="catLinkId_${catLink.id}">

                                        <g:if test="${editable}">
                                          <a href="#" onclick="deleteItem('catLinkId', '${catLink.id}');return false;"><img 
                                            align="top" src="${resource(dir:'images',file:'delete.png')}" alt="delete icon" title="${message(code:'edit.select.to.delete.category')}"/></a>
                                        </g:if>
                                        <g:else>
                                          <img align="top" class="brightIcon" src="${resource(dir:'images',file:'delete.png')}" alt="delete icon"/>
                                        </g:else>

                                        ${catLink.category}
                                        <g:link controller="term" action="list" params="${[categoryId:catLink.category.id]}"><g:message code="edit.show.category.terms"/></g:link>
                                    </div>
                                    </td>
                                  </tr>
                              </g:each>                          
                            </g:if>
                        </table>

                              <li class="noBulletItemList" ${synset.categoryLinks.size() > 0 ? 'style="margin-top:10px"' : ''}>
                                <g:if test="${editable}">
                                     <%-- Change or add new category --%>
                                     <div id="newCategoryLink">
                                         <a href="#" onclick="showNewCategory();return false;"><img align="top" src="${createLinkTo(dir:'images',file:'plus.png')}" alt="Plus"/>&nbsp;<g:message code='edit.add.categories'/></a>
                                     </div>

                                     <div id="newCategory" style="display:none">
                                         <% i = 0; %>
                                         <g:while test="${i < Integer.parseInt(grailsApplication.config.thesaurus.maxNewCategories)}">
                                             <select class="submitButton" name="category.id_${i}" id="category.id_${i}" >
                                                <option value="null"><g:message code='edit.no.further.category'/></option>
                                                <g:each var="category" in="${Category.findAllByIsDisabled(false, [sort:'categoryName'])}">
                                                    <option value="${category.id}">${category.toString()?.encodeAsHTML()}</option>
                                                </g:each>
                                             </select>
                                             <br />
                                             <% i++ %>
                                         </g:while>
                                     </div>
                                 </g:if>
                              </li>

                        </div>

                        <div style="clear: both"></div>

                        <g:if test="${LinkType.count() > 0}">

                            <g:set var="synsetLinks" value="${synset?.sortedSynsetLinks()}"/>

                            <%
                            Set displayedSynsets = new HashSet()
                            %>
                            <g:render template="link" model="[title:'Oberbegriffe', linkTypeName:'Oberbegriff',
                                synset:synset, synsetLinks:synsetLinks, showAddLink:true, displayedSynsets: displayedSynsets]" />

                            <g:render template="link" model="[title:'Unterbegriffe', linkTypeName:'Unterbegriff',
                                synset:synset, synsetLinks:synsetLinks, showAddLink:false, displayedSynsets: displayedSynsets,
                                reverseLink:true]" />

                            <g:render template="link" model="[title:'Assoziationen', linkTypeName:'Assoziation',
                                synset:synset, synsetLinks:synsetLinks, showAddLink:true, displayedSynsets: displayedSynsets]" />

                        </g:if>

                        <g:if test="${editable}">
                            <div class='leftColumn name'>
                                <h2 class="noTopMargin"><g:message code='edit.delete'/></h2>
                            </div>
                            <div class="rightColumn">
                                <div class="buttons">
                                    <g:if test="${synset.isVisible}">
                                        <a href="javascript:toggleDeleteButton()">${message(code:'edit.delete.button')}</a>
                                        <div id="deleteButton" style="display:${showOnlyDeleteButton ? 'block' : 'none'};margin-top:12px">
                                            <g:actionSubmit style="background-color: #ff9790" action="hide" class="hide submitButton" value="${message(code:'edit.delete.now.button')}" />
                                        </div>
                                    </g:if>
                                    <g:else>
                                        <g:actionSubmit action="unhide" class="unhide submitButton" value="${message(code:'edit.undelete.button')}" />
                                    </g:else>
                                </div>
                            </div>
                            <div style="clear: both"></div>
                        </g:if>

                        <g:if test="${editable}">
                              <div class='leftColumn name'>
                                 <h2 class="noTopMargin" style="margin-bottom: 0px;"><g:message code='edit.comment.for.change'/></h2>
                                 <g:message code='edit.comment.for.change.detail'/>
                              </div>
                              <div class='rightColumn value'>
                                  <textarea ${disabled} rows="2" cols="50" maxlength="400"
                                       id="changeComment" spellcheck="true" name="changeComment"></textarea>
                              </div>
                              <div style="clear: both"></div>

                              <div class="leftColumn">&nbsp;</div>
                              <div class="rightColumn">
                                    <g:if test="${!showOnlyDeleteButton && synset?.isVisible}">
                                        <div class="buttons">
                                            <g:actionSubmit id="mainSaveButton" action="update" class="save submitButton" value="${message(code:'edit.submit')}" />
                                        </div>
                                    </g:if>
                              </div>
                              <div style="clear: both"></div>
                        </g:if>

                        <div class="leftColumn">&nbsp;</div>
            
                        <div class="rightColumn">
                            <g:set var="linkParams" value="${[controllerName: 'synset',
                                    actionName: 'edit', origId: params.id]}" />
                            <g:if test="${!editable}">
                                  <g:link controller="user" action="login" class="link"
                                        params="${linkParams}"><img align="top" src="${createLinkTo(dir:'images',file:'forum-bubble.png')}" alt="Forum-Icon" /> <g:message code="edit.login.to.improve"/></g:link>
                            </g:if>
                            <br/>
                        </div>
                        <div style="clear: both"></div>

            </div>

        </g:form>

        <g:if test="${editable && synset.isVisible}">
            <g:form controller="merge" method="get" name="mergeForm">
                <input type="hidden" name="synset1" value="${synset?.id}" />
                <div class='leftColumn name'>
                    <h2 class="noTopMargin"><g:message code='edit.merge'/></h2>
                </div>
                <div class="rightColumn">
                    <div class="buttons">
                        <a href="javascript:toggleId('mergeArea')">${message(code:'edit.merge.link')}</a>
                        <div id="mergeArea" style="margin-top:12px; display:none">
                            <g:message code="edit.merge.id"/><br>
                            <input type="text" name="synset2"/>
                            <g:actionSubmit action="index" class="hide mergeArea" value="${message(code:'edit.merge.continue')}" />
                        </div>
                    </div>
                </div>
                <div style="clear: both"></div>
            </g:form>
        </g:if>

        <g:if test="${eventList}">
            <!-- is not always set, e.g. after error -->
            <div class="colspanlist">

              <br />
              <h2><a name="history" style="pointer-events: none;"><g:message code='edit.latest.changes' args="${[eventListCount]}"/></a></h2>

              <table>
                  <tr>
                      <th><g:message code='edit.changelog.date'/></th>
                      <th style="min-width: 55px"><g:message code='changelist.column.user'/></th>
                      <th><g:message code='edit.changelog.change'/></th>
                  </tr>
                  <g:each var='event' in='${eventList}' status='i'>
                      <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                          <td valign="top" width="110">
                              <g:formatDate format="yyyy-MM-dd" date="${event.creationDate}"/>
                              <span class="metaInfo"><g:formatDate format="HH:mm" date="${event.creationDate}"/></span>
                              <g:if test="${session.user && session.user.userId.toString() == 'admin'}">
                                  <span class="metaInfo">${event.id}</span>
                              </g:if>
                          </td>
                          <td valign="top" align="center">
                              <g:link controller="user" action="profile" params="${[uid:event.byUser.id]}">
                                  <g:render template="/identicon" model="${[user: event.byUser, count: i]}"/>
                                  <g:if test="${event.byUser.realName}">
                                      <span style="hyphens: auto">${event.byUser.realName.encodeAsHTML()}</span>
                                  </g:if>
                                  <g:else>
                                      <span class="anonUserId">#${event.byUser.id}</span>
                                  </g:else>
                              </g:link>
                          </td>
                          <td valign="top">${diffs.get(event)
                                  .replaceAll("linking:", " <span class='add'>verlinkt:</span> ")
                                  .replaceAll("adding link:", " <span class='add'>verlinkt:</span> ")
                                  .replaceAll("(deleting|removing) link:", " <span class='del'>Link entfernt:</span> ")
                                  .replaceAll("ist das Antonym von", " <b>ist das Antonym von</b> ")
                                  .replaceAll(" assoziiert ", " <b>assoziiert</b> ")
                                  .replaceAll("&lt;b&gt;", "<b>")
                                  .replaceAll("&lt;/b&gt;", "</b>")
                                  .replaceAll("&lt;br/&gt;", "<br/>")
                                  .replaceAll(" ist ein Oberbegriff von ", " <b>ist ein Oberbegriff von</b> ")}
                              <g:if test="${event.changeDesc}">
                                  <br/>
                                  <g:message code='edit.changelog.comment'/> ${event.changeDesc?.encodeAsHTML()}
                              </g:if>
                          </td>
                      </tr>
                  </g:each>
              </table>
              
              <div class="paginateButtons">
                  <g:paginate fragment="history" total="${eventListCount}" id="${params.id}" />
              </div>
              
            </div>
        </g:if>

        <g:if test="${!synset?.isVisible}">
            </div> <!-- end: invisibleSynset -->
        </g:if>

        <g:render template="/ads/edit_bottom"/>

    </body>
</html>
