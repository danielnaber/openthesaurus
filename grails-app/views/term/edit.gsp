<%@page import="com.vionto.vithesaurus.*" %>  
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title><g:message code="edit.term.title" args="${[term.toString()]}"/></title>
        <g:render template="/taggingIncludes" model="${[readOnly: !session.user || readOnlyMode]}"/>
        <g:set var="tagStr" value=""/>
        <g:each in="${term.tags?.sort()}" var="tag" status="i">
            <g:if test="${i == 0}">
                <g:set var="tagStr" value="${tag.name}"/>
            </g:if>
            <g:else>
                <g:set var="tagStr" value="${tagStr + "," + tag.name}"/>
            </g:else>
        </g:each>
        <script type="text/javascript">
        <!--

            $( document ).ready(function() {
                updateRemainingChars();
                $('#userComment').on("propertychange input textInput", function () {
                    updateRemainingChars();
                });
            });
        
            function updateRemainingChars() {
                var left = 400 - $('#userComment').val().length;
                if (left < 0) {
                    left = 0;
                }
                $('#userCommentCharCounter').text(left);
            }
        
            function deleteItem(id, termLinkId) {
                var hiddenFieldName = 'deleteExistingTermLink_' + id + '_' + termLinkId;
                var deleted = document.getElementById(hiddenFieldName).value != "";
                var divName = id + '_' + termLinkId;
                if (deleted) {
                    document.getElementById(hiddenFieldName).value = '';
                    document.getElementById(divName).style.textDecoration = '';
                } else {
                    document.getElementById(hiddenFieldName).value = termLinkId;
                    document.getElementById(divName).style.textDecoration = 'line-through';
                }
                return false;
            }

            function showNewTermLink() {
                document.getElementById('addTermLinkLink').style.display='none';
                document.getElementById('addTermLink').style.display='block';
                document.editForm.qAntonym.focus();
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

            <g:render template="/synset/completion"/>

        // -->
        </script>
    </head>
    <body>

        <div class="body">
        
            <hr />
        
            <h1 style="margin-bottom:12px"><g:message code="edit.term.headline" args="${[term.toString()]}"/></h1>
    
            <g:if test="${flash.message}">
                <div class="message">${flash.message}</div>
            </g:if>
    
            <g:hasErrors bean="${term}">
            <div class="errors">
                <g:renderErrors bean="${term}" as="list" />
            </div>
            </g:hasErrors>
            
            <g:if test="${!session.user || readOnlyMode}">
                <g:set var="disabled" value="disabled='true'"/>
                <g:set var="editable" value="${false}"/>
            </g:if>
            <g:else>
                <g:set var="editable" value="${true}"/>
            </g:else>

            <div style="float:right"><g:render template="/ads/termedit_right"/></div>
			 
            <g:form controller="term" method="post" name="editForm">
                <input type="hidden" name="id" value="${id}" />
                <div class="dialog">
                    <table style="width:85%">
                        <tbody>
                        
                            <tr class='prop'>
                                <td valign='top' class='name'>
                                    <h2 class="noTopMargin"><g:message code="edit.term.term"/></h2>
                                </td>
                                <td valign='top' class='value ${hasErrors(bean:term,field:'word','errors')}'>
                                    <input style="max-width:300px" ${disabled} type="text" id='word' name='word' spellcheck="true" value="${fieldValue(bean:term,field:'word')}"/>
                                </td>
                            </tr> 

                            <tr class='prop'>
                                <td valign='top' class='name'>
                                    <h2 class="noTopMargin"><g:message code="edit.term.synset"/></h2>
                                </td>
                                <td valign='top' class='value'>
                                    <g:link controller="synset" action="edit" id="${term.synset.id}">${term.synset.toString()?.encodeAsHTML()}</g:link>
                                </td>
                            </tr> 

						    <g:if test="${Language.findAllByIsDisabled(false)?.size() == 1}">
						    	<tr style="display:none">
						    		<td></td>
						    		<td>
						    			<%-- the HTML around the hidden field is for syntax correctness only --%>
									  	<g:hiddenField name="language.id_${i}" value="${Language.findByIsDisabled(false).id}"/>
						    		</td>
						    	</tr>
						    </g:if>
						    <g:else>
	                            <tr class='prop'>
	                                <td valign='top' class='name'>
	                                    <h2 class="noTopMargin"><g:message code="edit.term.language"/></h2>
	                                </td>
	                                <td valign='top' class='value ${hasErrors(bean:term,field:'language','errors')}'>
	                                    <g:if test="${editable}">
	                                        <g:select value="${term.language.id}" name="language.id"
	                                            optionKey="id" from="${Language.list()}" />
	                                    </g:if>
	                                    <g:else>
	                                        ${term.language.longForm.toString()?.encodeAsHTML()}
	                                    </g:else>
	                                </td>
	                            </tr> 
						    </g:else>

                            <tr class='prop'>
                                <td valign='top' class='name'>
                                    <h2 class="noTopMargin"><g:message code="edit.term.tags"/></h2>
                                </td>
                                <td valign='top' class='value' style="max-width:380px">
                                    <input class="tags" name="tags" type="text" value="${tagStr.encodeAsHTML()}"/>
                                </td>
                            </tr>

                            <tr class='prop'>
                                <td valign='top' class='name'>
                                    <h2 class="noTopMargin"><g:message code="edit.term.level"/> <a style="font-weight:normal" href="#" onclick="toggleLanguageLevelHelp();return false;">[?]</a></h2>
                                </td>
                                <td valign='top' class='value ${hasErrors(bean:term,field:'level','errors')}'>
                                    <g:if test="${term.level == null}">
                                      <label><input ${disabled} type="radio" name="level.id" value="null" checked="checked" /> <span class="noMatches"><g:message code="edit.term.level.none"/></span></label><br />
                                    </g:if>
                                    <g:else>
                                      <label><input ${disabled} type="radio" name="level.id" value="null" /> <span class="noMatches"><g:message code="edit.term.level.none"/></span></label><br />
                                    </g:else>
                                    <g:each in="${TermLevel.list()}" var="level">
                                      <g:if test="${term.level?.id == level.id}">
                                        <g:set var="checked" value="checked='checked'"/>
                                      </g:if>
                                      <g:else>
                                        <g:set var="checked" value=""/>
                                      </g:else>
                                      <label><input ${disabled} type="radio" name="level.id" value="${level.id}" ${checked} /> ${level.levelName}</label><br />
                                    </g:each>
                                    <div id="languageLevelHelp" style="display: none">
                                        <g:render template="/synset/languageLevelHelp" />
                                    </div>
                                </td>
                            </tr>

                          <tr class='prop'>
                            <td valign="top"><h2 class="noTopMargin"><g:message code="edit.term.antonym"/></h2></td>
                            <td valign="top">

                              <g:if test="${termLinkInfos && termLinkInfos.size() > 0}">
                                  
                                <g:each in="${termLinkInfos}" var="termLinkInfo">
                                    <div id="Antonym_${termLinkInfo.id}" style="margin-bottom: 5px">
                                        <g:if test="${editable}">
                                            <input type="hidden" id="deleteExistingTermLink_Antonym_${termLinkInfo.id}" name="deleteExistingTermLink_Antonym_${termLinkInfo.id}" value=""/>
                                            <a href="#" onclick="deleteItem('Antonym', '${termLinkInfo.id}');return false;"><img
                                                    align="top" src="${resource(dir:'images',file:'delete2.png')}" alt="delete icon" title="${message(code:'edit.select.to.delete.link')}"/></a>
                                        </g:if>
                                        <g:else>
                                            <img align="top" src="${resource(dir:'images',file:'delete2_inactive.png')}" alt="delete icon"/>
                                        </g:else>
                                        <g:link controller="term" action="edit"
                                                id="${termLinkInfo.getTerm2().id}">${termLinkInfo.getTerm2()}</g:link>
                                        (<g:link controller="synset" action="edit"
                                                 id="${termLinkInfo.getTerm2().synset.id}">${termLinkInfo.getTerm2().synset.toShortString(3).encodeAsHTML()}</g:link>)
                                    </div>

                                </g:each>
                              </g:if>
                              <g:else>
                                <span class="metaInfo"><g:message code="edit.term.antonyms.none"/></span>
                              </g:else>
                                  
                              <g:if test="${editable}">
                                  <div id="addTermLinkLink" style="margin-top:5px">
                                      <a href="#" onclick="showNewTermLink();return false;"><g:message code="edit.add.antonym"/></a>
                                  </div>
                                  <div id="addTermLink" style="display:none;margin-top:5px">
                                      <g:textField name="qAntonym" value="" onkeypress="return doNotSubmitOnReturn(event);" onkeyup="return doSynsetSearchOnKeyUp(event, 'Antonym', '/term/ajaxSearch');" autocomplete="off"/>
                                      <span id="addSynsetProgressAntonym" style="visibility:hidden;position:absolute">
                                          <img src="${createLinkTo(dir:'images',file:'spinner.gif')}" alt="Spinner image"
                                             title="Searching..."/>
                                      </span>
                                      <!-- term link, the name is a bit misleading... -->
                                      <div id="synsetLinkAntonym" style="min-height:200px;width:450px">
                                      </div>
                                  </div>
                              </g:if>
                            </td>
                          </tr>

                            <tr class='prop'>
                                <td valign='top' class='name'>
                                    <h2 class="noTopMargin" style="margin-bottom: 0px;"><g:message code="edit.term.comment"/></h2>
                                    <g:message code="edit.term.comment2"/>
                                </td>
                                <td valign='top' class='value ${hasErrors(bean:term,field:'userComment','errors')}'>
                                    <g:if test="${editable}">
                                        <g:textArea maxlength="400" style="width:100%" rows="5" id='userComment' name='userComment' spellcheck="true" value="${term.userComment}"/>
                                        <p class="metaInfo"><g:message code="edit.term.remaining" /> <span id="userCommentCharCounter"></span></p>
                                    </g:if>
                                    <g:else>
										<g:if test="${term.userComment}">
	                                        ${term.userComment?.toString()?.encodeAsHTML()}
										</g:if>
										<g:else>
											<span class="noMatches"><g:message code="edit.no.comment"/></span>
										</g:else>
                                    </g:else>
                                </td>
                            </tr>

                            <g:if test="${editable}">
                                <tr class='prop'>
                                    <td valign='top' class='name'>
                                        <h2 class="noTopMargin" style="margin-bottom: 0;"><g:message code="edit.comment.for.change"/></h2>
                                        <g:message code="edit.comment.for.change.detail"/>
                                    </td>
                                    <td valign='top' class='value ${hasErrors(bean:term,field:'changeComment','errors')}'>
                                        <textarea style="width:100%" rows="2" maxlength="400" id='changeComment' name='changeComment' spellcheck="true"></textarea>
                                    </td>
                                </tr>
                            </g:if>
                            
                            <tr>
                            	<td></td>
                            	<td>
					                <g:if test="${editable}">
						                <div class="buttons">
						                    <g:actionSubmit class="save submitButton" 
						                    	action="update" value="${message(code:'edit.term.submit')}" />
						                </div>
						            </g:if>
                            	</td>
                            </tr>

                        </tbody>
                    </table>
                </div>
            </g:form>
            
        </div>
    </body>
</html>
