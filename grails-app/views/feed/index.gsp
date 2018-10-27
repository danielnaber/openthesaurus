<rss version="2.0">
    <channel>
        <title>Letzte Änderungen in OpenThesaurus</title>
        <link>${grailsApplication.config.thesaurus.serverURL}/feed</link>
        <description>Letzte Änderungen in OpenThesaurus</description>
        <image>
            <url>${assetPath(absolute:"true", src:"${message(code:'favicon.name')}")}/></url>
            <title>OpenThesaurus</title>
            <link>${grailsApplication.config.thesaurus.serverURL}</link>
        </image>
        <g:each in="${events}" var="event">
            <item>
              <title>${event.title}</title>
            <link>${event.link}</link>
            <pubDate>${event.pubDate}</pubDate>
            <description><![CDATA[ ${event.description} ]]></description>
            </item>
        </g:each>
    </channel>
</rss>