<%@page import="com.vionto.vithesaurus.*" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title><g:message code="faq.title" /></title>
    </head>
    <body>

        <hr />

		<h2><g:message code="faq.title" /></h2>

        <%--
        <table style="border:0px;width:100%">
        <tr>
        	<td>
        		<ul>
        			<li><a href="#was">Was ist ein Synonym?</a></li>
        			<li><a href="#textverarbeitungen">In welche Textverarbeitungen kann ich OpenThesaurus direkt integrieren? </a></li>
        			<li><a href="#aenderungen">Was soll ich bei meinen Änderungen an OpenThesaurus beachten?</a></li>
        			<li><a href="#english">I'm looking for an English thesaurus. </a></li>
        		</ul>
        	</td>
        	<td>
		        <g:render template="/ads/faq_right"/>
        	</td>
        </tr>
        </table>
        --%>
        
		<div class="faqitem">
			<div class="question">
				<a name="was">Was ist ein Synonym?</a>
			</div>
			<div class="answer">
				<p>Wenn zwei oder mehr Wörter in einem bestimmten Kontext
					die gleiche Bedeutung haben, sind sie Synonyme. Beispiele:</p>
					
					<ul>
						<li><span class="bsp">Adresse</span>, <span class="bsp">Anschrift</span></li>
				
						<li><span class="bsp">gelingen</span>, <span class="bsp">glücken</span>, <span class="bsp">klappen</span></li>
						<li><span class="bsp">oft</span>, <span class="bsp">häufig</span></li>
					</ul>
					
					<p>Ob Wörter Synonyme sind, lässt sich einfach durch einen
					ausgedachten Satz wie <span class="bsp">Ich gehe <em>oft</em> ins Kino</span> überprüfen.
					Hier lässt sich <span class="bsp">oft</span> durch <span class="bsp">häufig</span> ersetzen, ohne dass
					der Satz dadurch eine andere Bedeutung bekommt. Also sind
					<span class="bsp">oft</span> und <span class="bsp">häufig</span> Synonyme.</p>
				
					
					<p>Folgende Wortpaare sind dagegen <em>keine</em> Synonyme:</p>
					
					<ul>
						<li><span class="bsp">warm</span>, <span class="bsp">heiß</span> (die Bedeutung unterscheidet sich zu sehr)</li>
						<li><span class="bsp">Haus</span>, <span class="bsp">Gebäude</span> (Haus ist ein Unterbegriff von Gebäude, kein Synonym)</li>
				
					</ul>
					
					<p>Die Synonyme einer Bedeutung bilden eine <em>Synonymgruppe</em>.
					Ein Wort mit verschiedenen Bedeutungen  -- wie z.B. <span class="bsp">Bank</span> --
					taucht in so vielen Synonymgruppen auf, wie es verschiedene Bedeutungen
					hat, z.B.:</p>
					
					<p>Synonymgruppe 1: <span class="bsp">Bank, Kreditinstitut</span><br />
					Synonymgruppe 2: <span class="bsp">Bank, Sitzbank</span></p>				
			</div>
		</div>

		<div class="faqitem">
			<div class="question">
				<a name="textverarbeitungen">In welche Textverarbeitungen kann ich OpenThesaurus direkt integrieren?</a>
			</div>
			<div class="answer">
			OpenThesaurus funktioniert mit <a href="http://www.openoffice.org">OpenOffice.org</a> /
                <a href="http://www.documentfoundation.org/download/">LibreOffice</a>,
				<a href="http://www.oracle.com/us/products/applications/open-office/index.html">Oracle Open Office (StarOffice)</a>,
				<a href="http://www.koffice.org/kword/">KWord</a> und 
				<a href="http://www.papyrus.de">Papyrus</a>.
			</div>
		</div>

		<div class="faqitem">
			<div class="question">
				<a name="aenderungen">Was soll ich bei meinen Änderungen an OpenThesaurus beachten?</a>
			</div>
			<div class="answer">
				<ul>
					<li>Keine Einträge von anderen Wörterbuch/Thesaurus-Seiten systematisch übernehmen</li>
					<li>Die neue Rechtschreibung benutzen. Sind zwei Schreibweisen
						erlaubt, sollen auch beide eingegeben werden.</li>
					<li>Keine extrem seltenen Begriffe oder "Privatsynonyme" einfügen</li>
					<li>Nur Grundformen einfügen, keine Beugungen.
						Beispiele:<br />
						okay: <span class="bsp">laufen</span>, aber nicht: <span class="bsp">lief</span>, <span class="bsp">läufst</span>, ...<br />
						okay: <span class="bsp">Haus</span>, aber nicht: <span class="bsp">Häuser</span>
					</li>
					<li>Veraltete Wörter bitte entsprechend kennzeichnen, d.h.
						<span class="bsp">(veraltet)</span> dahinter schreiben.</li>
					<li>Regionale Wörter bitte mit <span class="bsp">(regional)</span> kennzeichnen.
						Österreichische Wörter mit <span class="bsp">(österr.)</span>,
						schweizerische mit <span class="bsp">(schweiz.)</span> kennzeichnen.</li>
					<li>Fremdwörter können durchaus hinzugefügt werden.
						Beispiel: <span class="bsp">Appendix, Blinddarm</span></li>
				</ul>
			</div>
		</div>

		<!-- 
		<div class="faqitem">
			<div class="question">
			Wie funktioniert die Sache mit den Ober- und Unterbegriffen?
			</div>
			<div class="answer">
			</div>
		</div>
		 -->

		<div class="faqitem">
			<div class="question">
				<a name="english">I'm looking for an English thesaurus.</a>
			</div>
			<div class="answer">
			<p>Please have a look at
			<a href="http://wordnetweb.princeton.edu/perl/webwn">WordNet</a> or
			<a href="http://www.thesaurus.com/">thesaurus.com</a>.</p>
			</div>
		</div>

		<%--
		<div class="faqitem">
			<div class="question">
			I want to start a thesaurus project like OpenThesaurus, but for a new language. What should I do?
			</div>
			<div class="answer">
			<p>Please download <a href="https://sourceforge.net/projects/vithesaurus">vithesaurus</a>
			and <a href="imprint.php">contact me</a> if you have any questions.
			</div>
		</div>
		--%>

		<%--
		<div class="faqitem">
			<div class="question">
			</div>
			<div class="answer">
			</div>
		</div>
		 --%>
		 
	<g:render template="/ads/faq_bottom"/>

    </body>
</html>
