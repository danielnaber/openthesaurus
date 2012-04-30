<!doctype html>
<html>
    <head>
        <title><g:layoutTitle default="OpenThesaurus" /></title>
        <link type="text/css" rel="stylesheet" href="${createLinkTo(dir:'css',file:'reset-min.css')}" />
        <link type="text/css" rel="stylesheet" href="${createLinkTo(dir:'css',file:'layout.css')}" />
        <link rel="shortcut icon" href="${createLinkTo(dir:'images',file:message(code:'favicon.name'))}" />
        <link rel="search" type="application/opensearchdescription+xml" title="OpenThesaurus" href="${createLinkTo(dir:'openSearch',file:message(code:'index'))}" />
        <g:render template="/script"/>
        <g:layoutHead />

        <script type="text/javascript" src="${createLinkTo(dir:'js/prototype',file:'prototype.js')}"></script>
        <!-- Note: this partially duplicates code from directSearch.gsp -->
        <script type="text/javascript">
        <!--
            var onChangeInterval = null;
            var deferRequestMillis = 200;
            var minChars = 2;
            var currentValue = null;

            Event.observe(window.document, "keydown", function(e) {
                var key = (e.which) ? e.which : e.keyCode;
                if (key == 27) {  // Escape
                    $('searchResultArea').hide();
                    $('body').setStyle({backgroundColor: '#F7F7F7'});
                    $('searchResultArea').update("");
                }
              });

            function doSearchOnKeyUp(event) {
                switch (event.keyCode) {
                    case Event.KEY_UP:
                    case Event.KEY_DOWN:
                    case Event.KEY_RIGHT:
                    case Event.KEY_LEFT:
                        return;
                }
                clearInterval(onChangeInterval);
                var searchString = document.searchform.q.value;
                if (currentValue != searchString) {
                    onChangeInterval = setInterval("onValueChange()", deferRequestMillis);
                }
            }

            function onValueChange() {
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
                    new Ajax.Updater('searchResultArea',
                      '${createLinkTo(dir:"ajaxSearch/ajaxMainSearch",file:"")}',
                      {
                       asynchronous: true,
                       evalScripts: false,
                       onLoaded: function(e){loadedSearch()},
                       onLoading: function(e){loadSearch()},
                       parameters:'q=' + searchString + "&forumLink=false"
                      }
                    );
                }
            }

            function loadSearch() {
                document.getElementById('spinner').style.position='absolute';
                document.getElementById('spinner').style.visibility='visible';
            }

            function loadedSearch() {
                document.getElementById('spinner').style.visibility='hidden';
            }

        // -->
        </script>

    </head>
    <body>

    <div id="body">

      <div id="content">

        <g:render template="/searchform" model="${[homepage: false, isDirectSearch: true]}"/>

        <g:if test="${session.user}">
          <noscript>
              <div class="nojs">
                 <g:message code='no.javascript.warning'/>
              </div>
          </noscript>
        </g:if>

        <g:render template="/loggedin"/>
        
       	<g:layoutBody />

        <div id="searchResultArea" style="display:none;position:absolute;outline:3px solid white;padding:10px;margin:10px;border:solid 2px #aaaaaa;background-color:white;width:760px;min-height:100px;left:-10px;top:165px;">
        </div>

      </div>

    </div>

    <g:render template="/footer" model="${[homepage:false]}"/>

    <g:render template="/analytics"/>

    </body>
</html>