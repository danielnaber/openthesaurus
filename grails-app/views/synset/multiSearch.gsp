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

        <g:if test="${searchTerms.size() == 1}">
            <p class="warning"><g:message code="create.search.single.term.warning"/></p>
        </g:if>

        <g:if test="${synsetList && synsetList.size() > 0}">
            <table>
               <g:each in="${synsetList}" status="i" var="synset">
                    <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        <td style="padding-bottom: 8px"><g:link action="edit" id="${synset.id}">${synset?.toShortStringWithShortLevel(Integer.MAX_VALUE, false)}</g:link></td>
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

                  </td>
              </tr>

           </g:each>

           <tr>
            <td></td>
            <td>
                <div class="buttons">
                    <span class="button"><g:actionSubmit class="submitButton" value="${message(code:'create.search.submit')}" action="save" /></span>
                    <g:message code="create.search.submit.description"/>
                </div>
            </td>
           </tr>

        </table>

        </g:form>

    </body>
</html>
