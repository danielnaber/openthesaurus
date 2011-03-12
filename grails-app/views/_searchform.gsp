<%@page import="com.vionto.vithesaurus.*" %>

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

  <p class="claim">Synonyme und Assoziationen</p>
  <form action="${createLinkTo(dir:'synonyme')}" onsubmit="window.location='${createLinkTo(dir:'synonyme')}/' + encodeURIComponent(document.searchform.q.value);return false;" name="searchform">
    <g:if test="${params && params.q}">
      <input accesskey="s" type="text" id="search-field" name="q" value="${params.q.encodeAsHTML()}" /><input type="image" title="Synonym finden" src="${createLinkTo(dir:'images',file:'search-submit.png')}" />
    </g:if>
    <g:else>
      <input onclick="document.searchform.q.select()" accesskey="s" type="text" id="search-field" name="q" value="Suchwort" /><input type="image" title="Synonym finden" src="${createLinkTo(dir:'images',file:'search-submit.png')}" />
    </g:else>
  </form>
</div>

<script type="text/javascript">
<!--
    document.searchform.q.focus();
	document.searchform.q.select();
// -->
</script>
