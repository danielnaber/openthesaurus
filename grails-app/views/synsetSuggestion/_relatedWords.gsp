<%@page import="com.vionto.vithesaurus.*" %>

<br />
<div style="margin-left:15px">

    <div id="successMessage${i}">

    <g:if test="${similarWords.size() > 0}">
        Similar words:
        <ul class="listindent">
            <g:each in="${similarWords}" var="similarWord">
                <li><g:link controller="synset" action="edit"
                    id="${similarWord.synsetId}"
                    >${similarWord.suggestedWord} (${similarWord.sectionName})</g:link>

                    <g:formRemote class="inlineForm" name="addSynonym"
                           url="[controller:'synset',action:'addSynonym']"
                           update="[success: 'successMessage'+i, failure: 'creationErrorMessage'+i]"
                           before="showProgress(${suggestionId})"
                           onComplete="hideProgress(${suggestionId})">
                        <input type="hidden" name="id" value="${similarWord.synsetId.encodeAsHTML()}" />
                        <input type="hidden" name="word" value="${term.encodeAsHTML()}" />
                        <input class="addAsSynonymButton" type="submit" value="Add to this concept" />
                    </g:formRemote>

                </li>
            </g:each>
        </ul>
    </g:if>
    <g:else>
        Similar words: -<br />
    </g:else>

    <g:if test="${startsWithWords.size() > 0}">
        Words with this word as their beginning:
        <ul class="listindent">
            <g:each in="${startsWithWords}" var="startsWithWord">
                <li><g:link controller="synset" action="search"
                    params="${[q: startsWithWord]}"
                    >${startsWithWord}</g:link></li>
            </g:each>
            <g:if test="${startsWithWords.size() == startsWithMax}">
                <li><g:link controller="synset" action="search"
                        params="${[q: suggestedWord + '%']}"
                        >more...</g:link></li>
            </g:if>
        </ul>
    </g:if>
    <g:else>
        Words with this word as their beginning: -<br />
    </g:else>

    <g:if test="${endsWithWords.size() > 0}">
        Words that end with this word:
        <ul class="listindent">
            <g:each in="${endsWithWords}" var="endsWithWord">
                <li><g:link controller="synset" action="search"
                    params="${[q: endsWithWord]}"
                    >${endsWithWord}</g:link></li>
            </g:each>
            <g:if test="${endsWithWords.size() == endsWithMax}">
                <li><g:link controller="synset" action="search"
                        params="${[q: suggestedWord + '%']}"
                        >more...</g:link></li>
            </g:if>
        </ul>
    </g:if>
    <g:else>
        Words that end with this word: -<br />
    </g:else>

    <div class="createNewSynset" id="creationMessage${i}">

        <g:formRemote name="createSynset" url="[controller:'synset',action:'createSynset']"
               update="[success: 'successMessage'+i, failure: 'creationErrorMessage'+i]"
               onSuccess="approved(${suggestionId})"
               before="showProgress(${suggestionId})"
               onComplete="hideProgress(${suggestionId})">
        <table class="middlealigntable" style="border:0px">
            <tr>
                <td>Language:</td>
                <td><g:select name='language.id' optionKey="id" from="${Language.list().sort()}"
                        value="${suggestedLanguageId}" />
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Thesaurus:
                    <g:select name='section.id' optionKey="id" from="${Section.list().sort()}"
                        value="${suggestedSectionId}" />
                </td>
            </tr>
            <tr>
                <td>Category Type:</td>
                <td valign="middle">
                    <select name="category.id" id="category.id">
                        <option value="null">[select a category]</option>
                        <g:each var="category" in="${Category.findAllByIsDisabled(false).sort()}">
                            <g:if test="${category.id == suggestedCategoryId}">
                                <g:set var="selection" value="selected='selected'" />
                            </g:if>
                            <g:else>
                                <g:set var="selection" value="" />
                            </g:else>
                            <option value="${category.id}" ${selection}>
                                ${category.toString()?.encodeAsHTML()}
                                <g:if test="${category.categoryType}">[${category.categoryType}]</g:if>
                            </option>
                        </g:each>
                    </select>
                </td>
            </tr>
            <tr>
                <td>Preferred Term:</td>
                <td><g:textField name="term" value="${term}" />
                    <input class="submit" type="submit" value="Create Concept" />
                </td>
            </tr>
            <g:if test="${suggestedLanguageId != -1 || suggestedCategoryId != -1 || suggestedSectionId != -1}">
                <tr>
                    <td colspan="2">NOTE: the values have been pre-selected to match those of the most similar term</td>
                </tr>
            </g:if>
        </table>
        </g:formRemote >

    </div>

    <div class="error" id="creationErrorMessage${i}"></div>

    </div>

</div>
