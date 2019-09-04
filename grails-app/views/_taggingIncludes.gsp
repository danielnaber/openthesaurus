<%@ page import="com.vionto.vithesaurus.Tag" %>
<asset:javascript src="application"/>
<asset:stylesheet src="application"/>
<asset:stylesheet src="jquery.tagit.css" />
<script type="text/javascript">
<!--
    $(document).ready(function() {
        $(".tags").tagit(
            {
                readOnly: ${readOnly},
                tagLimit: ${tagLimit ? tagLimit : 10},
                singleField: true,
                removeConfirmation: true,
                autocomplete: {delay: 0, minLength: 1},
                availableTags: [
                    <g:set var="allTags" value="${Tag.findAll().sort()}"/>
                    <g:each in="${allTags}" var="tag" status="i">
                        <g:if test="${tag.isVisible()}">
                            <g:if test="${i < allTags.size()-1}">
                                "${tag.name.encodeAsHTML()}",
                            </g:if>
                            <g:else>
                                "${tag.name.encodeAsHTML()}"
                            </g:else>
                        </g:if>
                    </g:each>
                ],
                caseSensitive: false,
                placeholderText: "${placeholderText ? placeholderText : message(code:'tag.add.tags.here')}",
                allowSpaces: true
            }
        );
    });
//-->
</script>
