<%@page import="com.vionto.vithesaurus.*" %>
<g:javascript library="prototype" />
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title><g:message code='edit.title' args="${[synset.toShortString()?.encodeAsHTML()]}"/></title>
        <g:if test="${synset?.isVisible == false || params.offset}">
          <meta name="robots" content="noindex" />
        </g:if>
        <script type="text/javascript" src="${createLinkTo(dir:'js/prototype',file:'prototype.js')}"></script>
        <script type="text/javascript">
        <!--
          function loadSearch() {
            document.getElementById('addSynsetProgress').style.position='relative';
            document.getElementById('addSynsetProgress').style.visibility='visible';
          }
          function loadedSearch() {
            document.getElementById('addSynsetProgress').style.visibility='hidden';
          }
          // We have two submit buttons in the page and we cannot guarantee that
          // the correct one is used, so disable submit-by-return:
          function avoidSubmitOnReturn(event) {
        	  if (event.keyCode == 13) {
            	  return false;
        	  }
          }
          function doSearchOnReturn(event, linkType) {
              if (event.keyCode == 13) {
                  // start a search on return (copied from the generated code):
                  new Ajax.Updater('synsetLink' + linkType,'${createLinkTo(dir:"synset/ajaxSearch",file:"")}',{asynchronous:true,evalScripts:true,onLoaded:function(e){loadedSearch()},onLoading:function(e){loadSearch()},parameters:'q=' + document.editForm["q" + linkType].value + '&linkTypeName=' + linkType});
                  // don't send the outer form:
                  return false;
              }
          }
          // TODO: use dojo for this?!
          // TODO: avoid scroll jumping on click
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
          function toggleLanguageLevelHelp() {
            if (document.getElementById('languageLevelHelp').style.display == 'block') {
                document.getElementById('languageLevelHelp').style.display='none';
            } else {
                document.getElementById('languageLevelHelp').style.display='block';
            }
            return false;
          }
        // -->
        </script>
    </head>
    <body>

        <hr />

        <h2><g:message code='edit.headline' args="${[synset.toShortString()?.encodeAsHTML()]}"/></h2>

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
        </g:if>

        <g:if test="${!session.user}">
            <g:set var="disabled" value="disabled='true'"/>
        </g:if>

        <g:form controller="synset" method="post" name="editForm">
            <input type="hidden" name="id" value="${synset?.id}" />
            <input type="hidden" name="synset.id" value="${synset?.id}" />
            <div class="dialog">
                <table>
                    <tbody class="${synset?.isVisible ? '' : 'deletedSynset'}">
                        <tr class='prop'>
                            <td valign='top' class='name'>
                                <g:message code='edit.terms'/>
                            </td>
                            <td valign='top' class='value ${hasErrors(bean:synset,field:'terms','errors')}'>

                            <img src="${createLinkTo(dir:'images',file:'delete.png')}" alt="Trashcan"
                                title="${message(code:'edit.select.to.delete')}"/>
                            <g:if test="${prefTerms}">
                                &nbsp;
                                <img src="${createLinkTo(dir:'images',file:'preferred.png')}" alt="Preferred"
                                    title="Select one preferred term per language" />
                            </g:if>

                            <ul>
                                <g:set var="previousLanguage" value=""/>
                                <g:each var='t' in='${synset?.sortedTerms()}'>
                                    <li class="checkboxList">
                                        <g:if test="${previousLanguage != '' && t.language != previousLanguage}">
                                            <br/>
                                        </g:if>
                                        <g:managedCheckBox checked="false" disabled="${!session.user}" name="delete" value="${t.id}" id="delete_${t.id}"/>

                                        <g:if test="${prefTerms}">
                                            &nbsp;
                                            <g:set var="isPreferred" value="${PreferredTermLink.countByTerm(t) > 0}"/>
                                            <g:if test="${isPreferred}">
                                                <g:managedRadio disabled="${!session.user}" name="preferred_${t.language.shortForm}" value="${t.id}"
                                                    checked="${isPreferred}" id="preferred_${t.language.shortForm}_${t.id}" />
                                            </g:if>
                                            <g:else>
                                                <g:managedRadio disabled="${!session.user}" name="preferred_${t.language.shortForm}" value="${t.id}"
                                                    checked="${false}" />
                                            </g:else>
                                        </g:if>

                                        <g:link class="${isPreferred ? 'preferredTerm' : ''}" controller='term' action='edit' id='${t.id}'>
                                            <%--
                                            <g:set var="flagImg" value="flag_${t.language.shortForm}.png"/>
                                            <img src="${createLinkTo(dir:'images',file:flagImg)}" alt="[${t.language.longForm}]" border="0" />
                                            --%>
                                            ${t.toString()?.encodeAsHTML()}</g:link>

                                        &nbsp;
                                        <g:if test="${t.isAcronym}">
                                            <span class="termMetaInfo">[<g:message code='edit.acronym'/>]</span>
                                        </g:if>
                                        <g:if test="${t.isShortForm}">
                                            <span class="termMetaInfo">[<g:message code='edit.shortform'/>]</span>
                                        </g:if>
                                        <g:if test="${t.level}">
                                            <span class="termMetaInfo">[${t.level.toString()?.encodeAsHTML()}]</span>
                                        </g:if>
                                        <g:if test="${t.wordGrammar && t.wordGrammar.form != 'undefined'}">
                                            <span class="termMetaInfo">[${t.wordGrammar.toString()?.encodeAsHTML()}]</span>
                                        </g:if>
                                        <g:if test="${t.userComment}">
                                            <g:set var="maxCommentSize" value="${10}"/>
                                            <span class="termMetaInfo">[${t.userComment.substring(0,
                                                Math.min(t.userComment.size(), maxCommentSize)).toString()?.encodeAsHTML() +
                                                (t.userComment.size() > maxCommentSize ? "..." : "")}]
                                            </span>
                                        </g:if>

                                        <g:set var="termCount" value="${t.listHomonyms().size()}"/>
                                        <g:set var="termCountThisSection" value="${t.listHomonymsInSection().size()}"/>
                                        <g:link title="${message(code:'edit.find.all.meanings')}" class="termMetaInfo lightlink" action="search" params="[q : t.word]">[${termCount}]</g:link>
                                        <%--
                                        <span class="termMetaInfo">[<g:link class="termMetaInfo" action="search"
                                        params="[q : t.word, 'section.id': t.synset.section.id]">${t.synset.section.sectionName}: ${termCountThisSection}</g:link>,
                                        <g:link class="termMetaInfo" action="search" params="[q : t.word]">all: ${termCount}</g:link>]</span>
                                        --%>

                                        <g:set var="previousLanguage" value="${t.language}"/>

                                        <g:set var="termLinkInfos" value="${t.termLinkInfos()}"/>
                                        <g:if test="${termLinkInfos.size() > 0}">
                                          &nbsp;&nbsp;
                                          <g:each var='termLinkInfo' in='${termLinkInfos}'>
                                            ${termLinkInfo.getLinkName().encodeAsHTML()}: <g:link controller="synset" action="edit" id="${termLinkInfo.getTerm2().synset.id}">${termLinkInfo.getTerm2().encodeAsHTML()}</g:link>
                                          </g:each>
                                        </g:if>

                                    </li>
                                </g:each>
                            </ul>

                            </td>
                        </tr>

                        <tr class='prop'>
                            <td valign='top' class='name'>
                            </td>
                            <td valign='top' class='value ${hasErrors(bean:newTerm,'errors')}'>

                              <g:if test="${session.user}">
                                <div id="newTermLink">
                                    <a href="#" onclick="javascript:showNewTerm();return false;"><g:message code='edit.add.terms'/></a>
                                </div>

                                <% int i = 0; %>
                                <div id="newTerm" style="display:none">
                                    <g:while test="${i < Integer.parseInt(grailsApplication.config.thesaurus.maxNewTerms)}">
                                        <g:message code="edit.term.term"/> <input onkeypress="return avoidSubmitOnReturn(event);" class="termInput" name="word_${i}" value="${params['word_'+i]}" />&nbsp;
                                        <g:if test="${Language.findAllByIsDisabled(false)?.size() == 1}">
                                            <g:hiddenField name="language.id_${i}" value="${Language.findByIsDisabled(false).id}"/>
                                        </g:if>
                                        <g:else>
                                            <g:select name="language.id_${i}" optionKey="id" from="${Language.list()}" />&nbsp;
                                        </g:else>
                                        <g:message code="edit.term.level"/> <g:select name="level.id_${i}" optionKey="id" noSelection="['null':'-']" from="${TermLevel.list()}" />&nbsp;
                                        <g:if test="${i == 0}">
                                            <a href="#" onclick="javascript:toggleLanguageLevelHelp();return false;">[?]</a>
                                            <div id="languageLevelHelp" style="display: none">
                                                <g:render template="languageLevelHelp" />
                                            </div>
                                        </g:if>
                                        <%--
                                        <g:select name="wordGrammar.id_${i}" optionKey="id" from="${WordGrammar.list()}" />&nbsp;
                                        <br />
                                        <label><g:radio id="wordFormCommon_${i}" name="wordForm_${i}" value="common" checked="${true}" />&nbsp;<g:message code='edit.common.word'/></label>&nbsp;
                                        <label><g:radio id="wordFormAcronym_${i}" name="wordForm_${i}" value="acronym" checked="${false}" />&nbsp;<g:message code='edit.acronym'/></label>&nbsp;
                                        <label><g:radio id="wordFormAbbreviation_${i}" name="wordForm_${i}" value="abbreviation" checked="${false}" />&nbsp;<g:message code='edit.shortform'/></label>
                                        --%>
                                        <% i++ %>
                                        <br />
                                    </g:while>
                                </div>
                              </g:if>

                            </td>
                        </tr>

                        <tr class='prop'>
                            <td valign='top' class='name'>
                                <g:message code='edit.categories'/>
                            </td>
                            <td valign='top' class='value ${hasErrors(bean:synset,field:'synsetLinks','errors')}'>

                            <g:if test="${synset.categoryLinks && synset.categoryLinks.size() > 0}">
                                <img src="${createLinkTo(dir:'images',file:'delete.png')}" alt="Trashcan"
                                    title="${message(code:'edit.category.delete')}"/>
                                &nbsp;
                                <g:if test="${prefTerms}">
                                    <img src="${createLinkTo(dir:'images',file:'preferred.png')}" alt="Preferred"
                                        title="${message(code:'edit.category.prefer')}" />
                                </g:if>
                            </g:if>
                            <g:if test="${synset.categoryLinks.size() > 0}">
                              <ul>
                              <g:each var='catLink' in='${synset.categoryLinks.sort()}'>
                                  <li class="checkboxList">
                                      <g:managedCheckBox checked="false" disabled="${!session.user}"
                                         name="delete_category" value="${catLink.id}" />
                                      <g:if test="${prefTerms}">
                                          &nbsp;
                                          <g:set var="isPreferred" value="${synset.preferredCategory?.categoryName == catLink.category.categoryName}"/>
                                          <g:managedRadio disabled="${!session.user}" name="preferred_category" value="${catLink.category.id}"
                                              checked="${isPreferred}" />
                                      </g:if>
                                      ${catLink.category}
                                      <g:if test="${catLink.category.categoryType}">
                                             <span class="termMetaInfo">[${catLink.category.categoryType}]</span>
                                      </g:if>
                                  </li>
                              </g:each>
                              </ul>
                            </g:if>
                            <g:if test="${synset.categoryLinks == null || synset.categoryLinks.size() == 0}">
                                <span class="noMatches"><g:message code='edit.none'/></span>
                            </g:if>

                            </td>
                        </tr>

                        <tr class='prop'>
                            <td valign='top' class='name'>
                            </td>
                            <td valign='top' class='value ${hasErrors(bean:synset,field:'synsetLinks','errors')}'>

                             <g:if test="${session.user}">
                                 <%-- Change or add new category --%>
                                 <g:if test="${synset.preferredCategory?.categoryName == 'Unknown'}">
                                     <div id="changeCategoryLink">
                                        <a href="#" onclick="javascript:showChangeCategory();return false;"><g:message code='edit.change.category'/></a>
                                     </div>
                                 </g:if>
                                 <g:else>
                                     <div id="newCategoryLink">
                                         <a href="#" onclick="javascript:showNewCategory();return false;"><g:message code='edit.add.categories'/></a>
                                     </div>
                                 </g:else>

                                 <div id="newCategory" style="display:none">
                                     <% i = 0; %>
                                     <g:while test="${i < Integer.parseInt(grailsApplication.config.thesaurus.maxNewCategories)}">
                                         <select name="category.id_${i}" id="category.id_${i}" >
                                            <option value="null">[none]</option>
                                            <g:each var="category" in="${Category.findAllByIsDisabled(false, [sort:'categoryName'])}">
                                                <option value="${category.id}">${category.toString()?.encodeAsHTML()}
                                                    <g:if test="${category.categoryType}">
                                                        [${category.categoryType}]
                                                    </g:if>
                                                </option>
                                            </g:each>
                                         </select>
                                         <br />
                                         <% i++ %>
                                     </g:while>
                                 </div>
                             </g:if>

                            </td>
                        </tr>

                        <g:if test="${LinkType.count() > 0}">

                            <g:set var="synsetLinks" value="${synset?.sortedSynsetLinks()}"/>
                            <g:set var="suggestedSynsetLinks" value="${synset?.sortedSynsetLinkSuggestions()}"/>

                            <g:if test="${synsetLinks.size() > 0 || suggestedSynsetLinks.size() > 0}">
                                <tr class='prop'>
                                    <td valign='top' class='name'></td>
                                    <td valign='bottom' style="padding-bottom:0px">
                                        <img src="${createLinkTo(dir:'images',file:'questionmark.png')}" alt="${message(code:'edit.question.mark')}"
                                            title="${message(code:'edit.link.unknown.status')}" />
                                        <img src="${createLinkTo(dir:'images',file:'wrongway.png')}" alt="${message(code:'edit.wrong.way.sign')}"
                                            title="${message(code:'edit.select.reject.link')}" />
                                        <img src="${createLinkTo(dir:'images',file:'smiley.png')}" alt="${message(code:'edit.smiley')}"
                                            title="${message(code:'edit.select.approve.link')}" />
                                    </td>
                                </tr>
                            </g:if>

                            <%
                            Set displayedSynsets = new HashSet()
                            %>
                            <g:render template="link" model="[title:'Assoziationen', linkTypeName:'Assoziation',
                                synset:synset, synsetLinks:synsetLinks, showAddLink:true, displayedSynsets: displayedSynsets]" />

                            <g:render template="link" model="[title:'Oberbegriffe', linkTypeName:'Oberbegriff',
                                synset:synset, synsetLinks:synsetLinks, showAddLink:true, displayedSynsets: displayedSynsets]" />

                            <%--
                            <g:render template="suggestedLink" model="[title:'Suggested Hypernyms', linkTypeName:'Oberbegriff',
                                synset:synset, synsetLinks:suggestedSynsetLinks, displayedSynsets: displayedSynsets]" />
                            --%>

                            <g:render template="link" model="[title:'Unterbegriffe', linkTypeName:'Unterbegriff',
                                synset:synset, synsetLinks:synsetLinks, showAddLink:false, displayedSynsets: displayedSynsets,
                                reverseLink:true]" />

                            <%--
                            <g:render template="suggestedLink" model="[title:'Suggested Hyponyms', linkTypeName:'Unterbegriff',
                                synset:synset, synsetLinks:suggestedSynsetLinks, displayedSynsets: displayedSynsets,
                                reverseLink:true]" />
                            --%>

                        </g:if>

                        <g:if test="${Section.count() > 1}">
                            <tr class='prop'>
                                <td class='name'>
                                    <g:message code='edit.thesaurus'/>
                                </td>
                                <td valign='top' class='value ${hasErrors(bean:synset,field:'section','errors')}'>
                                    <g:if test="${session.user}">
                                        <g:select name="section.id" from="${Section.list()}" optionKey="id"
                                            value="${synset.section?.id}" />
                                    </g:if>
                                    <g:else>
                                        ${synset.section}
                                    </g:else>
                                </td>
                            </tr>
                        </g:if>

                        <g:if test="${session.user}">
                            <tr class='prop'>
                                <td class='name'>
                                    <g:message code='edit.delete'/>
                                </td>
                                <td valign='top'>
                                    <div class="buttons">
                                        <g:if test="${synset.isVisible}">
                                            <span class="submitButton"><g:actionSubmit action="hide" class="hide" value="${message(code:'edit.delete.button')}" /></span>
                                        </g:if>
                                        <g:else>
                                            <span class="submitButton"><g:actionSubmit action="unhide" class="unhide" value="${message(code:'edit.undelete.button')}" /></span>
                                        </g:else>
                                    </div>
                                </td>
                            </tr>
                        </g:if>

                        <tr class='prop'>
                            <td valign='top' class='name'>
                                <g:message code='edit.comment'/>
                            </td>
                            <td valign='top' class='value ${hasErrors(bean:synset,field:'userComment','errors')}'>

                                <g:if test="${synset.userComment}">
                                    <div id="addComment">
                                        <g:if test="${session.user}">
                                            <g:textArea id='userComment' name='userComment' value="${synset.userComment}"/>
                                        </g:if>
                                        <g:else>
                                            <g:textArea readonly="true" id='userComment' name='userComment' value="${synset.userComment}"/>
                                        </g:else>
                                    </div>
                                </g:if>
                                <g:else>
                                    <g:if test="${session.user}">
                                        <div id="addCommentLink">
                                            <a href="#" onclick="javascript:showAddComment();return false;"><g:message code="edit.add.comment"/></a>
                                        </div>
                                        <div id="addComment" style="display:none">
                                            <g:textArea id='userComment' name='userComment' value="${synset.userComment}"/>
                                        </div>
                                    </g:if>
                                    <g:else>
                                        <span class="noMatches"><g:message code="edit.no.comment"/></span>
                                    </g:else>
                                </g:else>

                            </td>
                        </tr>

                        <g:if test="${synset.source}">
                            <tr class='prop'>
                                <td valign='top' class='name'>
                                    <g:message code='edit.source'/>
                                </td>
                                <td valign='top' class='lessImportantValue'>
                                    ${synset.source?.encodeAsHTML()}
                                </td>
                            </tr>
                        </g:if>

                        <g:if test="${showOrigSource}">
                            <tr class='prop'>
                                <td valign='top' class='name'>
                                    Orig. Source:
                                </td>
                                <td valign='top' class='lessImportantValue'>
                                    ${synset.originalURI?.toString()?.encodeAsHTML()}
                                    <g:if test="${synset.sources?.size() > 0}">
                                        ${synset.sources?.sort().toString()?.encodeAsHTML()}
                                    </g:if>
                                </td>
                            </tr>
                        </g:if>

                        <%--
                        <tr class='prop'>
                            <td valign='top' class='name'>
                                <label for='source'>UMLS SemType:</label>
                            </td>
                            <td valign='top' class='lessImportantValue'>
                                ${synset.semTypeLinks?.join(', ').toString()?.encodeAsHTML()}
                            </td>
                        </tr>
                        --%>

                        <%--
                        <tr class='prop'>
                            <td valign='top' class='name'>
                                <label for='source'>Evaluation:</label>
                            </td>
                            <td valign='top' class='lessImportantValue'>
                                ${synset.evaluation?.toString()?.encodeAsHTML()}
                            </td>
                        </tr>
                        --%>

                        <g:if test="${session.user}">
                              <tr class='prop'>
                                  <td valign='top' class='name'>
                                      <label for='changeComment'><g:message code='edit.comment.for.change'/></label>
                                  </td>
                                  <td valign='top' class='value'>
                                      <input ${disabled} onkeypress="return avoidSubmitOnReturn(event);" size="40" id="changeComment" type="text" name="changeComment" value="" />
                                  </td>
                              </tr>

                              <tr>
                                <td></td>
                                <td>
                                    <div class="buttons">
                                        <span class="submitButton"><g:actionSubmit action="update" class="save" value="${message(code:'edit.submit')}" /></span>
                                    </div>
                                </td>
                              </tr>
                        </g:if>

                    </tbody>
                </table>

            </div>

        </g:form>

        <g:if test="${eventList}">
            <!-- is not always set, e.g. after error -->
            <div class="colspanlist">

              <br />
              <h2><a name="history"><g:message code='edit.latest.changes' args="${[eventListCount]}"/></a></h2>

              <table>
                  <tr>
                      <th><g:message code='edit.changelog.date'/></th>
                      <th><g:message code='edit.changelog.user'/></th>
                      <th><g:message code='edit.changelog.change'/></th>
                      <th><g:message code='edit.changelog.comment'/></th>
                  </tr>
                  <g:each var='event' in='${eventList}' status='i'>
                      <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                          <td valign="top"><g:formatDate format="yyyy-MM-dd'&nbsp;'HH:mm" date="${event.creationDate}"/></td>
                          <td valign="top">${event.byUser.realName?.encodeAsHTML()}</td>
                          <td valign="top">${diffs.get(event)}</td>
                          <td valign="top">${event.changeDesc?.encodeAsHTML()}</td>
                      </tr>
                  </g:each>
              </table>
              
              <div class="paginateButtons">
                  <g:paginate fragment="history" total="${eventListCount}" id="${params.id}" />
              </div>
              
            </div>
        </g:if>

        <g:render template="/ads/edit_bottom"/>

    </body>
</html>
