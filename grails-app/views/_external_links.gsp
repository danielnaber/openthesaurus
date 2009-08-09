
<g:set var="latin1Query" value="${URLEncoder.encode(q, 'latin1')}"/>

<ul class="compact">
	<li><a href="http://de.wikipedia.org/wiki/Spezial:Search?search=${q.encodeAsURL()}&amp;go=Eintrag">Wikipedia</a>
		&middot; <a href="http://de.wiktionary.org/wiki/Spezial:Search?search=${q.encodeAsURL()}&amp;go=Eintrag">Wiktionary</a></li>
	<li><a href="http://www.canoo.net/services/Controller?input=${latin1Query}&amp;service=inflection"
		>Flexion auf Canoo.net</a></li>
	<li><a href="http://de.search.yahoo.com/search?p=${q.encodeAsURL()}">Yahoo</a>
		&middot; <a href="http://www.google.de/search?q=${q.encodeAsURL()}&amp;lr=lang_de">Google</a></li>
	<li>Deutsch/Englisch:<br />
		<a href="http://dict.leo.org/ende?lang=de&amp;search=${q.encodeAsURL()}">LEO</a> &middot;
		<a href="http://www.vokabelsalat.de/search/index?word=${q.encodeAsURL()}">vokabelsalat.de</a> &middot;
		<a href="http://dict.tu-chemnitz.de/dings.cgi?lang=de&amp;noframes=1&amp;service=&amp;query=${latin1Query}&amp;optword=1&amp;optcase=1&amp;opterrors=0&amp;optpro=0&amp;style=&amp;dlink=self"
			>Beolingus</a> &middot;
		<a href="http://www.dict.cc/?s=${q.encodeAsURL()}">dict.cc</a></li>
</ul>
