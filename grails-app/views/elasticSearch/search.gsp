<g:if test="${synsets.size() == 0}">
    No matches
</g:if>
<g:else>
    <ul style="margin-left: 15px">
        <g:each in="${synsets}" var="synset">
            <li>${synset}</li>
        </g:each>
    </ul>
</g:else>

<p style="margin-top: 8px;color:#888">ES time: ${esTime}ms, rest time: ${restTime}ms, total hits: ${totalHits}</p>
