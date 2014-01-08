<g:if test="${matches.size() == 0}">
    No matches
</g:if>
<g:else>
    <ul style="margin-left: 15px">
        <g:each in="${matches}" var="match">
            <li>
                <g:each in="${match.synset.sortedTerms()}" var="term">
                    <g:if test="${term.word == match.highlightTerm}">
                        ${match.highlightTermWithSpan
                                .replaceAll("<span class='synsetmatchDirect'>", "___START")
                                .replaceAll("</span>", "___END")
                                .encodeAsHTML()
                                .replaceAll("___START", "<span class='synsetmatchDirect'>")
                                .replaceAll("___END", "</span>")
                        } 
                        <!--<span style="color:#ccc">${match.score}</span>-->
                        &middot;
                    </g:if>
                    <g:else>
                        ${term.word.encodeAsHTML()} &middot;
                    </g:else>
                </g:each>
            </li>
        </g:each>
    </ul>
</g:else>

<p style="margin-top: 8px;color:#888">ES time: ${esTime}ms, rest time: ${restTime}ms, total hits: ${totalHits}</p>
