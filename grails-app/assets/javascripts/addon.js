$(function() {
    if (!location.search.match(/lt-test/)) {
        return;
    }
    function openLayer(url) {
        var shadow = $("<div />", { "class": "addon-layer__shadow" }).click(function() {
            shadow.remove();
        }).appendTo("body");
        var layer = $("<div />", { "class": "addon-layer" }).appendTo(shadow).click(function(e) {
            e.stopPropagation();
        });
        var header = $("<div />", { "class": "addon-layer__header" }).appendTo(layer);
        var close = $("<div />", { "class": "addon-layer__close" }).appendTo(layer).click(function() {
            shadow.remove();
        });
        var headline1 = $("<div />", { "class": "addon-layer__headline1" }).appendTo(header);
        var logo1 = $("<div />", { "class": "addon-layer__logo-ot" }).appendTo(headline1);
        var seperator = $("<div />", { "class": "addon-layer__logo-seperator", text: "+" }).appendTo(headline1);
        var logo2 = $("<div />", { "class": "addon-layer__logo-lt" }).appendTo(headline1);
        var video = $("<video />", { "class": "addon-layer__video", muted: "muted", loop: true, autoplay: true, width: 480, src: $("meta[name='addon:video']").attr("content") }).appendTo(header);
        var headline2 = $("<div />", { "class": "addon-layer__headline2", text: "Professioneller schreiben mit OpenThesaurus und LanguageTool" }).appendTo(layer);
        var text = $("<div />", { "class": "addon-layer__text", html: "Mit diesem kostenlosen Plugin können Sie nicht nur überall im Web (z.&nbsp;B. in Gmail, WordPress oder Google Docs) Synonyme abrufen, sondern bekommen auch intelligente Vorschläge zur Verbesserung der <strong>Grammatik und Zeichensetzung</strong> Ihrer Texte." }).appendTo(layer);
        var button = $("<a />", { "class": "addon-layer__button", text: "Kostenlos installieren", href: url, target: "_blank" }).appendTo(layer).click(function() {
            if (window._paq) {
                _paq.push(['trackEvent', "Addon", "GoToStore"]);
            }
        });
    }

    function createChromeLink() {
        return $("<a />", {
            href: "https://languagetoolplus.com/webextension/store?ref=ot",
            target: "_blank",
            "class": "addon-link addon-link--chrome",
            text: "Chrome Extension installieren"
        });
    }

    function createFirefoxLink() {
        return $("<a />", {
            href: "https://languagetoolplus.com/webextension/store?ref=ot",
            target: "_blank",
            "class": "addon-link addon-link--firefox",
            text: "Firefox Add-on installieren"
        });
    }

    function createEdgeLink() {
        return $("<a />", {
            href: "https://languagetoolplus.com/webextension/store?ref=ot",
            target: "_blank",
            "class": "addon-link addon-link--edge",
            text: "Edge Add-on installieren"
        });
    }

    function createOperaLink() {
        return $("<a />", {
            href: "https://languagetoolplus.com/webextension/store?ref=ot",
            target: "_blank",
            "class": "addon-link addon-link--opera",
            text: "Opera Add-on installieren"
        });
    }

    if (navigator.userAgent.indexOf("Android") > -1) {
        return;
    }

    if (document.documentElement.lang !== "de") {
        return;
    }

    var link = null;
    if (navigator.userAgent.indexOf("OPR/") > -1) {
        link = createOperaLink();
    } else if (navigator.userAgent.indexOf("Edg/") > -1) {
        link = createEdgeLink();
    } else if (navigator.userAgent.indexOf("Firefox/") > -1) {
        link = createFirefoxLink();
    } else if (navigator.userAgent.indexOf("Chrome/") > -1 || navigator.indexOf("Chromium/") > -1) {
        link = createChromeLink();
    }

    if (!link) {
        return;
    }

    link.click(function() {
        openLayer(this.href);
        if (window._paq) {
            _paq.push(['trackEvent', "Addon", "OpenLayer"]);
        }
        return false;
    });

    link.prependTo("#navibar td:last-child");
});