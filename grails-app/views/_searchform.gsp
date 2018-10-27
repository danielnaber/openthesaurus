<%@page import="com.vionto.vithesaurus.*" %>
<%@page import="com.vionto.vithesaurus.tools.*" %>
<div id="search">

  <%-- move the logo/search block a bit to the left, looks like as if it is better centered: --%>
  <div style="margin-right: 30px;">
    
  <g:if test="${homepage}">
    <div class="logo"><img
        src="${createLinkTo(dir:'images',file:message(code:'logo'))}"
        alt="${message(code:'logo.alt.text')}" width="341" height="93" /></div>
  </g:if>
  <g:else>
    <div class="logo"><a href="/"><img
        src="${createLinkTo(dir:'images',file:message(code:'logo'))}"
        alt="${message(code:'logo.alt.text')}" width="341" height="93" /></a></div>
  </g:else>

  <p class="claim"><g:message code="homepage.claim"/></p>
  <p class="mobileClaim"><a href="/"><g:message code="homepage.claim.mobile"/></a></p>

  <form action="/synonyme" onsubmit="window.location='/synonyme/' + encodeURIComponent(document.searchform.q.value.replace('/', '___'));return false;" name="searchform">

    <g:set var="directSearchAttributes" value='onkeyup=\"return doSearchOnKeyUp(event);\" autocomplete=\"off\"'/>
    <span id="spinner" style="visibility:hidden;position:absolute;left:227px;top:99px">
      <img src="${createLinkTo(dir:'images',file:'spinner-big.gif')}" width="32" height="32" alt="Loading" />
    </span>

    <g:set var="autofocus" value=''/>
    <g:if test="${homepage && preventSearchFocus != 'true'}">
        <g:set var="autofocus" value='autofocus'/>
    </g:if>
    <g:if test="${params && params.q}">
      <input ${autofocus} ${directSearchAttributes} style="outline: none" onclick="selectSearchField()" onblur="leaveSearchField()" accesskey="s" type="text" id="search-field" name="q" value="${StringTools.slashUnescape(params.q.encodeAsHTML())}" /><input style="border-width:0px" type="image" title="${message(code:'homepage.search.button.title')}" src="${createLinkTo(dir:'images',file:'search-submit.png')}" />
    </g:if>
    <g:else>
      <input ${autofocus} ${directSearchAttributes} style="outline: none" onclick="selectSearchField()" onblur="leaveSearchField()" accesskey="s" type="text" id="search-field" name="q" placeholder="${message(code:'homepage.search.default.term')}" /><input style="border-width:0px" type="image" title="${message(code:'homepage.search.button.title')}" src="${createLinkTo(dir:'images',file:'search-submit.png')}" />
    </g:else>

      <!--
      <div style="background-color: #1e7dff; text-align: center; margin-left: 75px; padding: 3px;">
          <a style="color: white" href="/about/vertrieb">Praktikum/Nebenjob: Wir suchen eine/n Mitarbeiter/in Vertrieb &amp; Marketing!</a>
      </div>
      -->

  </form>

  </div>
    
</div>

<g:if test="${preventSearchFocus != 'true'}">
    <script type="text/javascript">
    <!--
    $( document ).ready(function() {
        var touchOS = ('ontouchstart' in document.documentElement) ? true : false;
        if (!touchOS) {
          document.searchform.q.focus();
          document.searchform.q.select();
        }
    });
    // -->
    </script>
</g:if>
