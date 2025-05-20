<script type="text/javascript">

    var onChangeInterval = null;
    var deferRequestMillis = 200;
    var minChars = 2;
    var currentValue = null;
    var openTooltip;

    function doSearchOnKeyUp(event) {
        // also see layout.css - if the transform is not applied (it's not in Opera because
        // it makes fonts fuzzy) we cannot use the popup as it will be misplaced, covering the
        // query box:
        var bodyDiv = $('#body');
        var isMozilla = bodyDiv.css('-moz-transform');
        var isWebkit = bodyDiv.css('-webkit-transform');
        var isMs = false;  // not yet enabled, layout problems with the skew
        var hasTransformEnabled = isMozilla || isWebkit || isMs;
        if ((event.keyCode == 45/*Insert*/ ||
             event.keyCode == 65/*A*/ ||
             event.keyCode == 67/*C*/
            ) && event.ctrlKey) {
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
                case 122:  // F12
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
    var resultPagePrefix = "";
    var firstSearch = true;

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
        if (searchString.length < minChars) {
            return;
        }
        if (searchString === '') {
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
                        $('#searchSpace').html(msg);
                        setUpHandlers();
                        if (firstSearch) {
                            if ($('#desktopAd')) {
                                $('#desktopAd').css('display', 'none');
                            }
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

    function toggle(divName) {
        var $div = $('#' + divName);
        if ($div.css('display') === 'block') {
            $div.css('display', 'none');
        } else {
            $div.css('display', 'block');
        }
    }

    function loadSynsetSearch() {
        $('#spinner').css({
            position: 'absolute',
            visibility: 'visible'
        });
    }

    function loadedSynsetSearch() {
        $('#spinner').css('visibility', 'hidden');
    }

    function setUpHandlers() {
        var markers = $('.antonymMarker, .commentMarker');
        markers.each(function(){
            $(this).data('title', $(this).attr('title'));
            $(this).removeAttr('title');
        });

        /*var hoverStart = 0;
        markers.mouseover(function() {
            hoverStart = new Date().getTime();
        });
        markers.mouseout(function() {
            var hoverTime = new Date().getTime() - hoverStart;
            plausible('comment icon hovered any time');
            if (hoverTime >= 100) {
                plausible('comment icon hovered at least 100ms');
                //console.log("hoverTime", hoverTime);
            }
        });*/

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
            $(this).next().css('top', elementOffset.top + 25);  // move down a bit so tooltip doesn't hide icon
            openTooltip = $(this);
            plausible('comment icon clicked');
            return false;
        });
    }

    $(document).ready(function() {

        setUpHandlers();

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

    });

</script>
