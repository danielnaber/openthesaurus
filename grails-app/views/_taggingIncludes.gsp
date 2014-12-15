<script type="text/javascript" src="${createLinkTo(dir:'js',file:'jquery-ui.min.js')}"></script>
<script type="text/javascript" src="${createLinkTo(dir:'js',file:'tag-it.min.js')}"></script>
<link type="text/css" rel="stylesheet" href="${createLinkTo(dir:'css',file:'jquery-ui.css')}" />
<link type="text/css" rel="stylesheet" href="${createLinkTo(dir:'css',file:'jquery.tagit.css')}" />
<script type="text/javascript">
<!--
    $(document).ready(function() {
        $("#tags").tagit(
            {
                readOnly: ${!session.user || readOnlyMode},
                        singleField: true,
                        removeConfirmation: true,
                        autocomplete: {delay: 0, minLength: 1},
                        availableTags: [
                            <g:each in="${allTags}" var="tag" status="i">
                                <g:if test="${i < allTags.size()-1}">
                                    "${tag.name}",
                                </g:if>
                                <g:else>
                                    "${tag.name}"
                                </g:else>
                            </g:each>
                        ],
                        caseSensitive: false,
                        placeholderText: "${message(code:'tag.add.tags.here')}",
                        allowSpaces: true
            }
        );
    });
//-->
</script>
