function loadSearch(linkType) {
  document.getElementById('addSynsetProgress' + linkType).style.position='relative';
  document.getElementById('addSynsetProgress' + linkType).style.visibility='visible';
}

function loadedSearch(linkType) {
  document.getElementById('addSynsetProgress' + linkType).style.visibility='hidden';
}

// We have two submit buttons in the page and we cannot guarantee that
// the correct one is used, so disable submit-by-return:
function avoidSubmitOnReturn(event) {
    if (event.keyCode == 13) {
        return false;
    }
}

function doNotSubmitOnReturn(event) {
    if (event.keyCode == 13) {
        return false;
    }
}
          
var onChangeInterval = null;
var deferRequestMillis = 200;
var minChars = 2;
var linkType = null;
var currentValue = null;
var cursorPosition = -1;

function doSynsetSearchOnKeyUp(event, tmpLinkType, ajaxUrl) {
    switch (event.keyCode) {
        case 38:  // KEY_UP
            if (cursorPosition > 0) {
                cursorPosition--;
                $('#radioButton' + tmpLinkType + cursorPosition).prop("checked", "checked");
            }
            return;
        case 40:  // KEY_DOWN:
            if ($('#radioButton' + tmpLinkType + (cursorPosition + 1)).length !== 0) {
                cursorPosition++;
                $('#radioButton' + tmpLinkType + cursorPosition).prop("checked", "checked");
            }
            return;
        case 37:  // KEY_LEFT:
        case 39:  // KEY_RIGHT:
            return;
    }
    linkType = tmpLinkType;
    clearInterval(onChangeInterval);
    var searchString = document.editForm["q" + linkType].value;
    // keyCode 13 (Return) allows user to force reload, i.e. if they added a term in a different tab:
    if (currentValue != searchString || event.keyCode == 13) {
        onChangeInterval = setInterval("onValueChange('" + ajaxUrl + "')", deferRequestMillis);
    }
    if (event.keyCode == 13) {
        return;
    }
}

function onValueChange(ajaxUrl) {
    clearInterval(onChangeInterval);
    var searchString = document.editForm["q" + linkType].value;
    currentValue = searchString;
    if (searchString === '' || searchString.length < minChars) {
        $('#synsetLink' + linkType).html("");
    } else {
        cursorPosition = -1;
        loadSearch(linkType);
        new jQuery.ajax(
          ajaxUrl,
          {
           data: {
            q: searchString,
            linkTypeName: linkType
           }
          }
        ).fail(function(jqXHR, textStatus, errorThrown) {
            loadedSearch(linkType);
            $('#synsetLink' + linkType).html(jqXHR.responseText);
          }
        ).done(function(msg) {
            loadedSearch(linkType);
            $('#synsetLink' + linkType).html(msg);
          });
    }
}
