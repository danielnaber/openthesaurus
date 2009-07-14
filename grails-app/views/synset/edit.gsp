<%@page import="com.vionto.vithesaurus.*" %>
<g:javascript library="prototype" />
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title><g:message code='edit.title' args="${[synset.toShortString()?.encodeAsHTML()]}"/>	</title>
        <script type="text/javascript">
        <!--
          var appletIsVisible = true;
          function toggleApplet() {
            if (appletIsVisible) {
              document.getElementById('ontologyApplet').style.display='none';
              appletIsVisible = false;
            } else {
              document.getElementById('ontologyApplet').style.display='block';
              appletIsVisible = true;
            }
          }
          function loadSearch() {
            document.getElementById('addSynsetProgress').style.position='relative';
            document.getElementById('addSynsetProgress').style.visibility='visible';
          }
          function loadedSearch() {
            document.getElementById('addSynsetProgress').style.visibility='hidden';
          }
          function doSearchOnReturn(event) {
              if (event.keyCode == 13) {
                  // TODO: make a search on return click
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
          function showNewSynsetLink() {
            document.getElementById('addSynsetLink').style.display='none';
            document.getElementById('addSynset').style.display='block';
            document.editForm.q.focus();
            return false;
          }
          function showAddComment() {
            document.getElementById('addCommentLink').style.display='none';
            document.getElementById('addComment').style.display='block';
            document.editForm.userComment.focus();
            return false;
          }
        // -->
        </script>
    </head>
    <body>

        <div class="body">

			<h1><g:message code='edit.headline' args="${[synset.toShortString()?.encodeAsHTML()]}"/></h1>	

            <g:if test="${flash.message}">
                <div class="message">${flash.message}</div>
            </g:if>

            <g:hasErrors bean="${synset}">
            <div class="errors">
                <g:renderErrors bean="${synset}" as="list" />
            </div>
            </g:hasErrors>

            <g:hasErrors bean="${newTerm}">
            <div class="errors">
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
                                    <label for='terms'><g:message code='edit.terms'/></label>
                                </td>
                                <td valign='top' class='value ${hasErrors(bean:synset,field:'terms','errors')}'>

                                <img src="${createLinkTo(dir:'images',file:'delete.png')}" alt="Trashcan"
                                    title="Select to delete terms from concept"/>
                                &nbsp;
                                <img src="${createLinkTo(dir:'images',file:'preferred.png')}" alt="Preferred"
                                    title="Select one preferred term per language" />

                                <ul>
                                    <g:set var="previousLanguage" value=""/>
                                    <g:each var='t' in='${synset?.sortedTerms()?}'>
                                        <li class="checkboxList">
                                            <g:if test="${previousLanguage != '' && t.language != previousLanguage}">
                                                <br/>
                                            </g:if>
                                            <g:managedCheckBox checked="false" disabled="${!session.user}" name="delete" value="${t.id}" id="delete_${t.id}"/>
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
                                            <g:link class="${isPreferred ? 'preferredTerm' : ''}" controller='term' action='edit' id='${t.id}'>
                                                <g:set var="flagImg" value="flag_${t.language.shortForm}.png"/>
                                                <img src="${createLinkTo(dir:'images',file:flagImg)}" alt="[${t.language.longForm}]" border="0" />
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
                                            <g:if test="${termCount > 1}">
                                               <span class="termMetaInfo">[<g:link class="termMetaInfo" action="search"
                                               params="[q : t.word, 'section.id': t.synset.section.id]">${t.synset.section.sectionName}: ${termCountThisSection}</g:link>,
                                                <g:link class="termMetaInfo" action="search" params="[q : t.word]">all: ${termCount}</g:link>]</span>
                                            </g:if>

                                            <g:set var="previousLanguage" value="${t.language}"/>
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
                                            <input class="termInput" name="word_${i}" value="${params['word_'+i]}" />&nbsp;
                                            <g:select name="language.id_${i}" optionKey="id" from="${Language.list()}" />&nbsp;
                                            <g:select name="wordGrammar.id_${i}" optionKey="id" from="${WordGrammar.list()}" />&nbsp;
                                            <br />
                                            <label><g:radio id="wordFormCommon" name="wordForm_${i}" value="common" checked="${true}" />&nbsp;<g:message code='edit.common.word'/></label>&nbsp;
                                            <label><g:radio id="wordFormAcronym" name="wordForm_${i}" value="acronym" checked="${false}" />&nbsp;<g:message code='edit.acronym'/></label>&nbsp;
                                            <label><g:radio id="wordFormAbbreviation" name="wordForm_${i}" value="abbreviation" checked="${false}" />&nbsp;<g:message code='edit.shortform'/></label>
                                            <br />
                                            <% i++ %>
                                            <br />
                                        </g:while>
                                    </div>
                                  </g:if>

                                </td>
                            </tr>

                            <tr class='prop'>
                                <td valign='top' class='name'>
                                    <label for='synsetLinks'><g:message code='edit.categories'/></label>
                                </td>
                                <td valign='top' class='value ${hasErrors(bean:synset,field:'synsetLinks','errors')}'>

                                <img src="${createLinkTo(dir:'images',file:'delete.png')}" alt="Trashcan"
                                    title="${message(code:'edit.category.delete')}"/>
                                &nbsp;
                                <img src="${createLinkTo(dir:'images',file:'preferred.png')}" alt="Preferred"
                                    title="${message(code:'edit.category.prefer')}" />
                                <ul>
                                <g:each var='catLink' in='${synset.categoryLinks.sort()}'>
                                    <li class="checkboxList">
                                        <g:managedCheckBox checked="false" disabled="${!session.user}"
                                           name="delete_category" value="${catLink.id}" />
                                        &nbsp;
                                        <g:set var="isPreferred" value="${synset.preferredCategory.categoryName == catLink.category.categoryName}"/>
                                        <g:managedRadio disabled="${!session.user}" name="preferred_category" value="${catLink.category.id}"
                                            checked="${isPreferred}" />
                                        ${catLink.category}
                                        <g:if test="${catLink.category.categoryType}">
                                               <span class="termMetaInfo">[${catLink.category.categoryType}]</span>
                                        </g:if>
                                    </li>
                                </g:each>
                                </ul>
                                <g:if test="${synset.categoryLinks == null || synset.categoryLinks.size() == 0}">
                                	<g:message code='edit.none'/>
                                </g:if>

                                </td>
                            </tr>

                            <tr class='prop'>
                                <td valign='top' class='name'>
                                </td>
                                <td valign='top' class='value ${hasErrors(bean:synset,field:'synsetLinks','errors')}'>

                                 <g:if test="${session.user}">
                                     <%-- Change or add new category --%>
                                     <g:if test="${synset.preferredCategory.categoryName == 'Unknown'}">
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
                                                <g:each var="category" in="${Category.findAllByIsDisabled(false).sort()}">
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
                                <g:render template="link" model="[title:'Hypernyms', linkTypeName:'Oberbegriff',
                                    synset:synset, synsetLinks:synsetLinks, showAddLink:true, displayedSynsets: displayedSynsets]" />

                                <g:render template="suggestedLink" model="[title:'Suggested Hypernyms', linkTypeName:'Oberbegriff',
                                    synset:synset, synsetLinks:suggestedSynsetLinks, displayedSynsets: displayedSynsets]" />

                                <g:render template="link" model="[title:'Hyponyms', linkTypeName:'Unterbegriff',
                                    synset:synset, synsetLinks:synsetLinks, showAddLink:false, displayedSynsets: displayedSynsets,
                                    reverseLink:true]" />

                                <g:render template="suggestedLink" model="[title:'Suggested Hyponyms', linkTypeName:'Unterbegriff',
                                    synset:synset, synsetLinks:suggestedSynsetLinks, displayedSynsets: displayedSynsets,
                                    reverseLink:true]" />

                            </g:if>

                            <tr class='prop'>
                                <td class='name'>
                                    <label for='section'><g:message code='edit.thesaurus'/></label>
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


                            <tr class='prop'>
                                <td class='name'></td>
                                <td valign='top' class='value ${hasErrors(bean:synset,field:'isVisible','errors')}'>
                                    <label for='isVisible'><g:managedCheckBox id="isVisible" disabled="${!session.user}" name='isVisible'
                                        value="${synset?.isVisible}" checked="${synset?.isVisible}" />&nbsp;Concept is visible</label>
                                </td>
                            </tr>

                            <tr class='prop'>
                                <td valign='top' class='name'>
                                    <label for='userComment'><g:message code='edit.comment'/></label>
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
                                                <a href="#" onclick="javascript:showAddComment();return false;">Add comment</a>
                                            </div>
                                            <div id="addComment" style="display:none">
                                                <g:textArea id='userComment' name='userComment' value="${synset.userComment}"/>
                                            </div>
                                        </g:if>
                                    </g:else>

                                </td>
                            </tr>

                            <g:if test="${synset.source}">
	                            <tr class='prop'>
	                                <td valign='top' class='name'>
	                                    <label for='source'><g:message code='edit.source'/></label>
	                                </td>
	                                <td valign='top' class='lessImportantValue'>
	                                    ${synset.source?.encodeAsHTML()}
	                                </td>
	                            </tr>
                            </g:if>

                            <g:if test="${showOrigSource}">
                                <tr class='prop'>
                                    <td valign='top' class='name'>
                                        <label for='source'>Orig. Source:</label>
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
                        </tbody>

                    </table>

                    <g:if test="${session.user}">
                        <table style="margin-top:5px">

                                <tr class='prop'>
                                    <td valign='top' class='name'>
                                        <label for='changeComment'><g:message code='edit.comment.for.change'/></label>
                                    </td>
                                    <td valign='top' class='value'>
                                        <input ${disabled} size="40" id="changeComment" type="text" name="changeComment" value="" />
                                    </td>
                                </tr>

                        </table>
                    </g:if>

                </div>

                <g:if test="${session.user}">
                    <div class="buttons" style="padding-right: 6px;">
                        <span class="submitButton"><g:actionSubmit class="save" value="${message(code:'edit.submit')}" /></span>
                    </div>
                </g:if>
            </g:form>

            <g:if test="${eventList}">
                <!-- is not always set, e.g. after error -->
                <br />
                <h1><g:message code='edit.latest.changes' args="${[eventList.size()]}"/></h1>

                <table>
                    <tr>
                        <th><g:message code='edit.changelog.date'/></th>
                        <th><g:message code='edit.changelog.user'/></th>
                        <th><g:message code='edit.changelog.comment'/></th>
                        <th><g:message code='edit.changelog.change'/></th>
                    </tr>
                    <g:each var='event' in='${eventList}' status='i'>
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                            <td><g:formatDate format="yyyy-MM-dd'&nbsp;'HH:mm" date="${event.creationDate}"/></td>
                            <td>${event.byUser.toString()?.encodeAsHTML()}</td>
                            <td>${event.changeDesc?.encodeAsHTML()}</td>
                            <td>${diffs.get(event)}</td>
                        </tr>
                    </g:each>
                </table>
            </g:if>

        </div>
    </body>
</html>
