<script type="text/javascript" src="${createLinkTo(dir:'js/prototype',file:'prototype.js?20130609')}"></script>
<script type="text/javascript">
    <!--
    var onChangeInterval = null;
    var deferRequestMillis = 200;
    var minChars = 2;
    var currentValue = null;

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
            $('searchResultArea').update("");
        } else {
            //$('searchResultTable').setStyle({opacity: 0.4}); -- too slow in Firefox
            cursorPosition = -1;
            var timeStamp = new Date().getTime();
            loadSynsetSearch();
            runningRequests++;
            new Ajax.Request(
                    '${createLinkTo(dir:"synset/ajaxSearch",file:"")}',
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
                                loadedSynsetSearch(searchString);
                            }
                        },
                        parameters:'q=' + searchString + "&forumLink=false&ajaxTest=true"
                    }
            );
        }
    }

    function loadSynsetSearch() {
        document.getElementById('spinner').style.position='absolute';
        document.getElementById('spinner').style.visibility='visible';
    }

    function loadedSynsetSearch(searchString) {
        document.getElementById('spinner').style.visibility='hidden';
        //TODO: activate:
        //var stateObj = { term: searchString };
        //history.pushState(stateObj, searchString/*title*/, searchString);
    }

    // -->
</script>
