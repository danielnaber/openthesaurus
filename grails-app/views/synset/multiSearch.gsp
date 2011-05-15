<%@page import="com.vionto.vithesaurus.*" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <g:set var="cleanTermList" value="${[]}"/>
        <%
        searchTerms.each{ cleanTermList.add(it.encodeAsHTML()) }
        %>
        <g:set var="simpleDelim" value=" &middot; "/>
        <title><g:message code="create.search.title" args="${[cleanTermList.join(simpleDelim)]}"/></title>
    </head>
    <body>

        <hr />

        <h2><g:message code="create.search.headline" args="${[cleanTermList.join(simpleDelim)]}"/></h2>

        <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
        </g:if>

        <g:if test="${synsetList}">
            <p class="warning"><g:message code="create.search.duplicate.warning"/></p>
        </g:if>

        <g:if test="${synsetList && synsetList.size() > 0}">
            <table>
               <g:each in="${synsetList}" status="i" var="synset">
                    <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        <td><g:link action="edit" id="${synset.id}">${synset?.toString()?.encodeAsHTML()}</g:link></td>
                    </tr>
               </g:each>
            </table>
        </g:if>

        <hr />

        <h2><g:message code="create.headline"/></h2>

        <g:hasErrors bean="${synset}">
            <div class="errors">
                <g:renderErrors bean="${synset}" as="list" />
            </div>
        </g:hasErrors>

        <g:form controller="synset" method="post" >

        <input type="hidden" name="numTerms" value="${searchTerms.size()}"/>
        <table class="dialog">

           <%--
           <tr class='prop'>
               <td valign='top' class='name'>
                   <label for='section'>Thesaurus:</label>
               </td>
               <td valign='top' class='value ${hasErrors(bean:synset,field:'section','errors')}'>
                  <g:select name='section.id' optionKey="id" from="${Section.list().sort()}" value="${synset?.section?.id}" />
               </td>
           </tr>
           --%>

           <%--
           <tr class='prop'>
               <td valign='top' class='name'>
                   <label for='source'>Source:</label>
               </td>
               <!-- default to 'other': TODO: find a cleaner solution... -->
               <g:set var="sourceValue" value="${synset?.source?.id}"/>
               <g:if test="${!synset?.source?.id}">
                <g:set var="sourceValue" value="${Source.findBySourceName('other')?.id}"/>
               </g:if>
               <td valign='top' class='value ${hasErrors(bean:synset,field:'source','errors')}'>
                   <g:select name='source.id' optionKey="id" from="${Source.list()}"
                    value="${sourceValue}" />
               </td>
           </tr>
           --%>

           <%--
           <tr class='prop'>
               <td valign='top' class='name'>
                   <label for='source'><g:message code="create.search.category"/></label>
               </td>
               <td valign='top' class='value ${hasErrors(bean:synset,field:'categoryLinks','errors')}'>
                   <select name="category.id" id="category.id" >
                      <option value="null">[select one category]</option>
                      <g:each var="category" in="${Category.findAllByIsDisabled(false).sort()}">
                          <option value="${category.id}">${category.toString()?.encodeAsHTML()}
                              <g:if test="${category.categoryType}">
                                  [${category.categoryType}]
                              </g:if>
                          </option>
                      </g:each>
                   </select>
               </td>
           </tr>
           --%>

           <g:each in="${searchTerms}" status="i" var="term">
              <tr class='prop'>
                  <td valign='top' class='name'>
                      <g:if test="${i == 0}">
                          <label><g:message code="create.search.terms"/></label>
                      </g:if>
                  </td>
                  <td valign='top' class='value ${hasErrors(bean:newTerm,'errors')}'>

                      <g:if test="${synset && synset.hasErrors()}">
                          <input type="text" class="termInput" name="word_${i}" value="${term.encodeAsHTML()}" />
                      </g:if>
                      <g:else>
                          <strong>${term.encodeAsHTML()}</strong><br />
                          <input type="hidden" class="termInput" name="word_${i}" value="${term.encodeAsHTML()}" />
                      </g:else>

                      <g:if test="${Language.findAllByIsDisabled(false)?.size() == 1}">
                        <g:hiddenField name="language.id_${i}" value="${Language.findByIsDisabled(false).id}"/>
                      </g:if>
                      <g:else>
                          <g:select name="language.id_${i}" optionKey="id" from="${Language.list()}" />&nbsp;
                      </g:else>

                      <%--
                      <g:select name="wordGrammar.id_${i}" optionKey="id" from="${WordGrammar.list()}" />&nbsp;
                      <g:set var="wordForm" value="wordForm_${i}"/>
                      <g:if test="${params[wordForm] && params[wordForm] != 'common'}">
                        <g:set var="commonChecked" value="${false}"/>
                      </g:if>
                      <g:else>
                        <g:set var="commonChecked" value="${true}"/>
                      </g:else>

                      <g:if test="${params[wordForm] == 'acronym'}">
                        <g:set var="acronymChecked" value="${true}"/>
                      </g:if>
                      <g:else>
                        <g:set var="acronymChecked" value="${false}"/>
                      </g:else>

                      <g:if test="${params[wordForm] == 'abbreviation'}">
                        <g:set var="abbreviationChecked" value="${true}"/>
                      </g:if>
                      <g:else>
                        <g:set var="abbreviationChecked" value="${false}"/>
                      </g:else>
                      <label><g:radio name="wordForm_${i}" value="common" checked="${commonChecked}" /> common word</label>&nbsp;
                      <label><g:radio name="wordForm_${i}" value="acronym" checked="${acronymChecked}" /> acronym</label>&nbsp;
                      <label><g:radio name="wordForm_${i}" value="abbreviation" checked="${abbreviationChecked}" /> abbreviation</label>
                      <g:if test="${i == 0}">
                        <br /><span class="hintText">This will be the preferred term</span>
                      </g:if>
                      --%>

                  </td>
              </tr>

           </g:each>

           <tr>
            <td></td>
            <td>
                <div class="buttons">
                <span class="button"><g:actionSubmit class="save" value="${message(code:'create.search.submit')}" action="save" /></span>
                </div>
            </td>
           </tr>

        </table>

        </g:form>

    </body>
</html>
