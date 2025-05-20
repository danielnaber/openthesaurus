<%@page import="com.vionto.vithesaurus.*" %>
<%@page import="com.vionto.vithesaurus.tools.*" %>
<div id="search">

  <%-- move the logo/search block a bit to the left, looks like as if it is better centered: --%>
  <div style="margin-right: 30px;">
    
  <div class="logo"><a href="/"><img
      src="${createLinkTo(dir:'images',file:message(code:'logo'))}"
      alt="${message(code:'logo.alt.text')}" width="341" height="93" /></a></div>

  <p class="claim"><g:message code="homepage.claim"/></p>
  <p class="mobileClaim"><a href="/"><g:message code="homepage.claim.mobile"/></a></p>

  <form style="position: relative" action="/synonyme" onsubmit="window.location='/synonyme/' + encodeURIComponent(document.searchform.q.value.replace('/', '___'));return false;" name="searchform">

    <g:set var="directSearchAttributes" value='onkeyup=\"return doSearchOnKeyUp(event);\" autocomplete=\"off\"'/>
    <span id="spinner">
      <img src="${createLinkTo(dir:'images',file:'spinner-big.gif')}" width="32" height="32" alt="Loading" />
    </span>

    <g:set var="autofocus" value=''/>
    <g:if test="${homepage && preventSearchFocus != 'true'}">
        <g:set var="autofocus" value='autofocus'/>
    </g:if>
    <g:if test="${params && params.q}">
      <input ${autofocus} ${directSearchAttributes} style="outline: none" onclick="selectSearchField()" onblur="leaveSearchField()" accesskey="s" type="text" id="search-field" name="q" value="${StringTools.slashUnescape(params.q.encodeAsHTML())}"
    </g:if>
    <g:else>
      <input ${autofocus} ${directSearchAttributes} style="outline: none" onclick="selectSearchField()" onblur="leaveSearchField()" accesskey="s" type="text" id="search-field" name="q" placeholder="${message(code:'homepage.search.default.term')}"
    </g:else>
    /><input class="searchSubmitButton" type="image" title="${message(code:'homepage.search.button.title')}" src="${createLinkTo(dir:'images',file:'search-submit.png')}" />

    <%--
    <g:if test="${request.forwardURI == "/"}">
        <br>
        Beispiele:
            <a href="synonyme/schön">schön</a>
            &middot; <a href="synonyme/wichtig">wichtig</a>
            &middot; <a href="synonyme/Herausforderung">Herausforderung</a>
            &middot; <a href="synonyme/auch">auch</a>
    </g:if>
    --%>

  </form>

  </div>
    
</div>


<g:if test="${preventSearchFocus != 'true'}">
    <script type="text/javascript">
    $( document ).ready(function() {
        var touchOS = ('ontouchstart' in document.documentElement) ? true : false;
        if (!touchOS && window.location.hash !== "#history") {
          document.searchform.q.focus();
          document.searchform.q.select();
        }
    });
    </script>
</g:if>
