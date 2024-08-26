
<g:set var="utf8Query" value="${URLEncoder.encode(q, 'utf8')}"/>
<g:set var="latin1Query" value="${URLEncoder.encode(q, 'latin1')}"/>

<%--
	<li><a href="http://de.wikipedia.org/wiki/Spezial:Search?search=${q.encodeAsURL()}&amp;go=Eintrag">Wikipedia</a>
		<span class="d">&middot;</span> <a href="http://de.wiktionary.org/wiki/Spezial:Search?search=${q.encodeAsURL()}&amp;go=Eintrag">Wiktionary</a></li>
--%>

<p style="line-height: 175%">

    <g:if test="${q.split(" ").length <= 2}">
        <a href="https://www.korrekturen.de/flexion/suche.php?q=${utf8Query}">Wortformen von korrekturen.de</a>
    </g:if>

    <!--
    <a href="http://dict.tu-chemnitz.de/dings.cgi?lang=de&amp;noframes=1&amp;service=&amp;query=${latin1Query}&amp;optword=1&amp;optcase=1&amp;opterrors=0&amp;optpro=0&amp;style=&amp;dlink=self"
     >Beolingus Deutsch-Englisch</a>
    -->

</p>