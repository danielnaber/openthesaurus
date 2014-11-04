
<g:set var="latin1Query" value="${URLEncoder.encode(q, 'latin1')}"/>

<%--
	<li><a href="http://de.wikipedia.org/wiki/Spezial:Search?search=${q.encodeAsURL()}&amp;go=Eintrag">Wikipedia</a>
		<span class="d">&middot;</span> <a href="http://de.wiktionary.org/wiki/Spezial:Search?search=${q.encodeAsURL()}&amp;go=Eintrag">Wiktionary</a></li>
--%>

<p style="line-height: 175%">

    <a href="http://www.canoo.net/services/Controller?input=${latin1Query}&amp;service=inflection">Wortformen von Canoo.net</a>

    <span class="d">&middot;</span>
    <a href="http://dict.tu-chemnitz.de/dings.cgi?lang=de&amp;noframes=1&amp;service=&amp;query=${latin1Query}&amp;optword=1&amp;optcase=1&amp;opterrors=0&amp;optpro=0&amp;style=&amp;dlink=self"
     >Beolingus Deutsch-Englisch</a>

</p>