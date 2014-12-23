
<h2><g:message code="powersearch.results.headline" args="${[totalMatches]}" /></h2>

<div id="powerSearchResult">
    <ul>
      <g:each in="${result}" var="term">
        <li>
            <g:link controller="synset" action="edit" id="${term.synset.id}">${term.word}</g:link>
            <g:if test="${term.level}"><span class="termMetaInfo" title="${term.level.levelName.encodeAsHTML()}">${term.level.shortLevelName.encodeAsHTML()}</span></g:if>
            <g:render template="/tag/termTags" model="${[term: term]}"/>
        </li>
      </g:each>
    </ul>

    <div class="paginateButtons">
      <g:paginate prev="&lt;" next="&gt;" maxsteps="4" max="20" total="${totalMatches}"
                  params="${[contains:params.contains, startsWith:params.startsWith, endsWith:params.endsWith,
                             level:params.level, category:params.category, tags:params.tags, noLevel:params.noLevel]}" />
    </div>
</div>

<script type="text/javascript">
  /* make the pagination links write the result only to the div */
  $(document).ready(function() {
    $(".paginateButtons a").click(function(ev) {
      new jQuery.ajax(ev.target.href).
          done(function(msg){ $('#powerSearchResult').html(msg); }).
          fail(function(jqXHR, textStatus, errorThrown){ $('#powerSearchResult').html(jqXHR.responseText); });
      return false;
    });
  });
</script>
