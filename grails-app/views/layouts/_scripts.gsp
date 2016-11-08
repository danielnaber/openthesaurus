<script type="text/javascript">
    <!--
    var onChangeInterval = null;
    var deferRequestMillis = 200;
    var minChars = 2;
    var currentValue = null;

    $(document).keyup(function(e) {
        if (e.keyCode == 27) {  // Escape key
            closePopup();
        }
    });

    function closePopup() {
        var searchResultAreaDiv = $('#searchResultArea');
        searchResultAreaDiv.hide();
        $('#body').css({backgroundColor: '#F7F7F7'});
        searchResultAreaDiv.html("");
    }

    function doSearchOnKeyUp(event) {
        // also see layout.css - if the transform is not applied (it's not in Opera because
        // it makes fonts fuzzy) we cannot use the popup as it will be misplaced, covering the
        // query box:
        var bodyDiv = $('#body');
        var isMozilla = bodyDiv.css('-moz-transform');
        var isWebkit = bodyDiv.css('-webkit-transform');
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
            var searchResultAreaDiv = $('#searchResultArea');
            searchResultAreaDiv.hide();
            $('#body').css({backgroundColor: '#F7F7F7'});
            searchResultAreaDiv.html("");
        } else {
            $('#searchResultArea').show();
            $('#body').css({backgroundColor: '#e6e6e6'});
            cursorPosition = -1;
            var timeStamp = new Date().getTime();
            loadSynsetSearch();
            runningRequests++;
            new jQuery.ajax(
                    '${createLinkTo(dir:"ajaxSearch/ajaxMainSearch",file:"")}',
                    {
                        method: 'get',
                        asynchronous: true,
                        data:{
                            q: searchString
                        }
                    }
            ).done(function(msg){
                if (timeStamp < lastUpdateTimeStamp) {
                    //console.warn("Ignoring outdated update: " + timeStamp + " < " + lastUpdateTimeStamp);
                } else {
                    $('#searchResultArea').html(msg);
                    lastUpdateTimeStamp = timeStamp;
                }
            }
            ).fail(function(jqXHR, textStatus, errorThrown){
                $('#searchResultArea').html(jqXHR.responseText);
            }
            ).always(function(e){
                if (runningRequests > 0) {
                    runningRequests--;
                }
                if (runningRequests <= 0) {
                    loadedSynsetSearch();
                }
            });
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
