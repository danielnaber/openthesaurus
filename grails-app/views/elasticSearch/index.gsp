<%@page import="com.vionto.vithesaurus.*" %>
<html>
<head>
    <meta name="layout" content="test" />
    <title>OpenThesaurus ElasticSearch Test</title>
    <g:render template="/script"/>
    <script type="text/javascript" src="${createLinkTo(dir:'js/prototype',file:'prototype.js?20130609')}"></script>
    <script type="text/javascript">
        <!--
        var onChangeInterval = null;
        var deferRequestMillis = 200;
        var minChars = 2;
        var currentValue = null;

        Event.observe(window.document, "keydown", function(e) {
            var key = (e.which) ? e.which : e.keyCode;
            if (key == Event.KEY_ESC) {
                closePopup();
            }
        });

        function closePopup() {
            $('searchResultArea').hide();
            $('body').setStyle({backgroundColor: '#F7F7F7'});
            $('searchResultArea').update("");
        }

        function doSearchOnKeyUp(event) {
            // also see layout.css - if the transform is not applied (it's not in Opera because
            // it makes fonts fuzzy) we cannot use the popup as it will be misplaced, covering the
            // query box:
            var isMozilla = $('body').getStyle('-moz-transform');
            var isWebkit = $('body').getStyle('-webkit-transform');
            //var isMs = $('body').getStyle('-ms-transform');
            var isMs = false;  // not yet enabled, layout problems with the skew
            var hasTransformEnabled = isMozilla || isWebkit || isMs;
            if ((event.keyCode == 45/*Insert*/ || event.keyCode == 65/*A*/ || event.keyCode == 67/*C*/) && event.ctrlKey) {
                // opening the popup makes no sense for these key combinations
                return;
            }
            if (hasTransformEnabled) {
                switch (event.keyCode) {
                    case Event.KEY_RETURN:
                    case Event.KEY_UP:
                    case Event.KEY_DOWN:
                    case Event.KEY_RIGHT:
                    case Event.KEY_LEFT:
                    case Event.KEY_TAB:
                    case 16:   // Shift
                    case 17:   // Ctrl
                    case 18:   // Alt
                    case 20:   // Caps Lock
                    case 35:   // End
                    case 36:   // Pos1
                    case 116:  // F5
                        return;
                }
                clearInterval(onChangeInterval);
                var searchString = document.searchform.q.value;
                if (currentValue != searchString) {
                    onChangeInterval = setInterval("onSynsetSearchValueChange()", deferRequestMillis);
                }
            }
        }

        var runningRequests = 0;
        var lastUpdateTimeStamp = 0;

        function onSynsetSearchValueChange() {
            clearInterval(onChangeInterval);
            var searchString = document.searchform.q.value;
            currentValue = searchString;
            if (searchString === '' || searchString.length < minChars) {
                $('searchResultArea').hide();
                $('body').setStyle({backgroundColor: '#F7F7F7'});
                $('searchResultArea').update("");
            } else {
                $('searchResultArea').show();
                $('body').setStyle({backgroundColor: '#e6e6e6'});
                //$('searchResultTable').setStyle({opacity: 0.4}); -- too slow in Firefox
                cursorPosition = -1;
                var timeStamp = new Date().getTime();
                loadSynsetSearch();
                runningRequests++;
                new Ajax.Request(
                        '${createLinkTo(dir:"elasticSearch",file:"search")}',
                        {
                            method: 'get',
                            asynchronous: true,
                            evalScripts: false,
                            onSuccess: function(response){
                                if (timeStamp < lastUpdateTimeStamp) {
                                    //console.warn("Ignoring outdated update: " + timeStamp + " < " + lastUpdateTimeStamp);
                                } else {
                                    $('searchResultArea').update(response.responseText);
                                    lastUpdateTimeStamp = timeStamp;
                                }
                            },
                            onFailure: function(response){$('searchResultArea').update(response.responseText)},
                            onComplete: function(e){
                                if (runningRequests > 0) {
                                    runningRequests--;
                                }
                                if (runningRequests <= 0) {
                                    loadedSynsetSearch();
                                }
                            },
                            parameters:'q=' + searchString + "&forumLink=false"
                        }
                );
            }
        }

        function loadSynsetSearch() {
            document.getElementById('spinner').style.position='absolute';
            document.getElementById('spinner').style.visibility='visible';
        }

        function loadedSynsetSearch() {
            document.getElementById('spinner').style.visibility='hidden';
        }

        // -->
    </script>
</head>
<body>

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

        <span id="spinner" style="visibility:hidden;position:absolute;left:257px;top:99px">
            <img src="${createLinkTo(dir:'images',file:'spinner-big.gif')}" width="32" height="32" alt="Loading" />
        </span>

        <input onkeyup="return doSearchOnKeyUp(event);" autocomplete="off" style="outline: none" onclick="selectSearchField()" onblur="leaveSearchField()" 
               accesskey="s" type="text" id="search-field" name="q"
               placeholder="${message(code:'homepage.search.default.term')}"
               /><input style="border-width:0" type="image" title="${message(code:'homepage.search.button.title')}" 
                        src="${createLinkTo(dir:'images',file:'search-submit.png')}" />
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

<hr/>

Auf dieser Seite kann man mit der Suche ElasticSearch testen.

</body>
</html>
