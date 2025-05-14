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
                case 13:   // Return
                case 37:   // cursor left
                case 38:   // cursor up
                case 39:   // cursor right
                case 40:   // cursor down
                case 9:    // Tab
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
    var isRealResultPage = true;
    //var resultPagePrefix = "/openthesaurus";   // local testing
    var resultPagePrefix = "";
    var firstSearch = true;

    <g:if test="${request.forwardURI.toLowerCase().endsWith('/index2')}">

        if (window.history && window.history.pushState) {
            window.onpopstate = function(event) {
                if (event.state && event.state.q) {
                    onSynsetSearchValueChangeInternal(event.state.q, false);
                } else {
                    onSynsetSearchValueChangeInternal("", false);
                }
            };
        }

        function onSynsetSearchValueChange() {
            onSynsetSearchValueChangeInternal(document.searchform.q.value, true);
        }

        function onSynsetSearchValueChangeInternal(searchString, changeHistory) {
            clearInterval(onChangeInterval);
            currentValue = searchString;
            if (searchString === '' || searchString.length < minChars) {
                $('#defaultSpace').show();
                $('#searchSpace').hide();
            } else {
                $('#defaultSpace').hide();
                $('#searchSpace').show();
                cursorPosition = -1;
                var timeStamp = new Date().getTime();
                loadSynsetSearch();
                runningRequests++;
                var stateObj = {q: searchString};
                new jQuery.ajax(
                    '/synset/newSearch',
                    {
                        method: 'get',
                        asynchronous: true,
                        data: {
                            q: searchString,
                            withAd: false
                        }
                    }
                ).done(function (msg) {
                        if (timeStamp < lastUpdateTimeStamp) {
                            //console.warn("Ignoring outdated update: " + timeStamp + " < " + lastUpdateTimeStamp);
                        } else {
                            //console.log("DONE: " + firstSearch);
                            $('#searchSpace').html(msg);
                            if (firstSearch) {
                                //$('#moreSpace').html(". . . . my ad test .. .. ");
                            }
                            lastUpdateTimeStamp = timeStamp;
                        }
                        if (changeHistory) {
                            if (isRealResultPage) {
                                // 'back' button will go back to this state
                                history.pushState(stateObj, "", resultPagePrefix + "/synonyme/" + searchString);
                            } else {
                                history.replaceState(stateObj, "", resultPagePrefix + "/synonyme/" + searchString);
                            }
                        }
                        if (msg.indexOf("--REALMATCHES--") !== -1) {
                            isRealResultPage = true;
                        } else {
                            isRealResultPage = false;
                        }
                    }
                ).fail(function (jqXHR, textStatus, errorThrown) {
                        $('#searchSpace').html(jqXHR.responseText);
                        if (changeHistory) {
                            history.replaceState(stateObj, "", resultPagePrefix + "/synonyme/" + searchString);
                        }
                    }
                ).always(function (e) {
                    if (runningRequests > 0) {
                        runningRequests--;
                    }
                    if (runningRequests <= 0) {
                        loadedSynsetSearch();
                    }
                    if (firstSearch) {
                        firstSearch = false;
                    }
                });
            }
        }

    </g:if>
    <g:else>

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
                    '/ajaxSearch/ajaxMainSearch',
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

    </g:else>

    function loadSynsetSearch() {
        document.getElementById('spinner').style.position='absolute';
        document.getElementById('spinner').style.visibility='visible';
    }

    function loadedSynsetSearch() {
        document.getElementById('spinner').style.visibility='hidden';
    }

    $(document).ready(function() {

        var markers = $('.antonymMarker, .commentMarker');
        var openTooltip;
        markers.each(function(){
            $(this).data('title', $(this).attr('title'));
            $(this).removeAttr('title');
        });

        // when user clicks somewhere else, remove the tooltip:
        $(document).click(function(e) {
            if (openTooltip && !$(e.target).is('.tooltip') && !$(e.target).is('.antonymMarker') && !$(e.target).is('.commentMarker')) {
                openTooltip.next('.tooltip').remove();
                openTooltip = null;
            }
        });

        // also remove the tooltip when user presses ESC:
        $(document).keyup(function(e) {
            if (e.keyCode == 27) {  // Escape key
                if (openTooltip) {
                    openTooltip.next('.tooltip').remove();
                    openTooltip = null;
                }
            }
        });

        markers.click(function() {
            if (openTooltip && openTooltip.is($(this))) {
                // If the same marker is clicked again, remove the tooltip
                $(this).next('.tooltip').remove();
                openTooltip = null;
                return false;
            }
            if (openTooltip) {
                openTooltip.next('.tooltip').remove();
            }
            if ($(this).data('title') != "") {
                $(this).after('<span class="tooltip">' + $(this).data('title') + '</span>');
            }
            var viewportWidth = $(window).width();
            var tooltipWidth = 310; // Approximate width of the tooltip
            var elementOffset = $(this).offset();
            var left = elementOffset.left + $(this).width() + 4;
            // Adjust left position if tooltip overflows viewport:
            if (left + tooltipWidth > viewportWidth + $(window).scrollLeft()) {
                left = viewportWidth + $(window).scrollLeft() - tooltipWidth - 5; // Add some padding
            }
            if (left < $(window).scrollLeft()) {
                left = $(window).scrollLeft() + 10; // Add some padding
            }
            $(this).next().css('left', left);
            openTooltip = $(this);
            return false;
        });

    });

    var lastErrorLogToServer = null;
    window.onerror = function (msg, url, line) {
        // don't report more than once a minute:
        if (lastErrorLogToServer && new Date() - lastErrorLogToServer < 1000 * 60) {
            return;
        }
        var message = "Error in " + url + " on line " + line + ": " + msg;
        //$.post("/about/logMessage", { "msg": message });
        lastErrorLogToServer = new Date();
    };

// -->
</script>
