<%@page import="com.vionto.vithesaurus.*" %>
<%@page import="com.vionto.vithesaurus.tools.*" %>
<div id="search">

  <g:if test="${homepage}">
    <div class="logo"><img
        src="${createLinkTo(dir:'images',file:message(code:'logo'))}"
        alt="<g:message code='logo.alt.text'/>" width="341" height="93" /></div>
  </g:if>
  <g:else>
    <div class="logo"><a href="${createLinkTo(dir:'/',file:'')}"><img
        src="${createLinkTo(dir:'images',file:message(code:'logo'))}"
        alt="<g:message code='logo.alt.text'/>" width="341" height="93" /></a></div>
  </g:else>

  <p class="claim"><g:message code="homepage.claim"/></p>

  <form action="${createLinkTo(dir:'synonyme')}" onsubmit="window.location='${createLinkTo(dir:'synonyme')}/' + encodeURIComponent(document.searchform.q.value.replace('/', '___'));return false;" name="searchform">

    <g:if test="${isDirectSearch}">
      <g:set var="directSearchAttributes" value='onkeyup=\"return doSearchOnKeyUp(event);\" autocomplete=\"off\"'/>
      <span id="spinner" style="visibility:hidden;position:absolute;left:257px;top:99px">
        <img src="${createLinkTo(dir:'images',file:'spinner-big.gif')}" width="32" height="32" alt="Loading" />
      </span>
    </g:if>

    <g:if test="${params && params.q}">
      <input ${directSearchAttributes} style="outline: none" onclick="selectSearchField()" onblur="leaveSearchField()" accesskey="s" type="text" id="search-field" name="q" value="${StringTools.slashUnescape(params.q.encodeAsHTML())}" /><input style="border-width:0px" type="image" title="${message(code:'homepage.search.button.title')}" src="${createLinkTo(dir:'images',file:'search-submit.png')}" />
    </g:if>
    <g:else>
      <input ${directSearchAttributes} style="outline: none" onclick="selectSearchField()" onblur="leaveSearchField()" accesskey="s" type="text" id="search-field" name="q" placeholder="${message(code:'homepage.search.default.term')}" /><input style="border-width:0px" type="image" title="${message(code:'homepage.search.button.title')}" src="${createLinkTo(dir:'images',file:'search-submit.png')}" />
    </g:else>
    <g:if test="${isDirectSearch}">
    </g:if>
  </form>
</div>

<g:if test="${preventSearchFocus != 'true'}">
    <script type="text/javascript">
    <!--
    document.observe('dom:loaded', function() {
        var touchOS = ('ontouchstart' in document.documentElement) ? true : false;
        if (!touchOS) {
          document.searchform.q.focus();
          document.searchform.q.select();
        }    
    });
    // -->
    </script>
</g:if>
