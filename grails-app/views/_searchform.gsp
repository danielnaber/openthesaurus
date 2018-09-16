<%@page import="com.vionto.vithesaurus.*" %>
<%@page import="com.vionto.vithesaurus.tools.*" %>

<div class="search-form">

        <g:set var="directSearchAttributes" value='onkeyup=\"return doSearchOnKeyUp(event);\" autocomplete=\"off\"'/>
        
        <div class="container">
            <div class="main-logo">
                <g:if test="${homepage}">
                    <img src="${createLinkTo(dir:'images',file:'logo.png')}?2018" alt="OpenThesaurus - Synonyme und Assoziationen">
                </g:if>
                <g:else>
                    <div class="logo"><a href="${createLinkTo(dir:'/',file:'')}"><img src="${createLinkTo(dir:'images',file:'logo.png')}?2018" alt="OpenThesaurus - Synonyme und Assoziationen"></a></div>
                </g:else>
            </div>
            <form action="${createLinkTo(dir:'synonyme')}" onsubmit="window.location='${createLinkTo(dir:'synonyme')}/' + encodeURIComponent(document.searchform.q.value.replace('/', '___'));return false;"
                  name="searchform" class="main-search">
                <span 
                    id="spinner" 
                    class="spinner" 
                    style="display: none;"
                >
                    <img 
                        src="${createLinkTo(dir:'images',file:'spinner-big.gif')}" 
                        width="32" 
                        height="32" 
                        alt="Loading"
                    />
                </span>
                <button id="clear-search" type="button" class="button button-clearsearch"><i class="fa fa-close"></i></button>

                <g:set var="autofocus" value=''/>
                <g:if test="${homepage && preventSearchFocus != 'true'}">
                    <g:set var="autofocus" value='autofocus'/>
                </g:if>
                <g:if test="${params && params.q}">
                    <input ${autofocus} ${directSearchAttributes} onclick="selectSearchField()" onblur="leaveSearchField()" accesskey="s" type="text" id="search-field" name="q" value="${StringTools.slashUnescape(params.q.encodeAsHTML())}" class="main-search-input">
                </g:if>
                <g:else>
                    <input ${autofocus} ${directSearchAttributes} onclick="selectSearchField()" onblur="leaveSearchField()" accesskey="s" type="text" id="search-field" name="q" placeholder="${message(code:'homepage.search.default.term')}" class="main-search-input">
                </g:else>

                <button class="main-search-button" type="submit">
                    <i class="fa fa-arrow-right"></i>
                </button>
            </form>
        </div>

        <div id="searchResultArea" class="searchResultPopup"></div>

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
        $('#clear-search').click(function() {
            document.searchform.q.value = "";
            document.searchform.q.focus();
            $('#searchResultArea').hide();
        });
    });
    // -->
    </script>
</g:if>
