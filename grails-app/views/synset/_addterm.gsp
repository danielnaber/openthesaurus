<%@page import="com.vionto.vithesaurus.tools.*" %>
<table>
  <tr>
    <td valign="top">
      <g:link action="create" params="[term : term]">
           <img src="${createLinkTo(dir:'images',file:'icon-add.png')}" width="11" height="11" alt="Add icon" />
      </g:link>
    </td>
    <td>&nbsp;</td>
    <td>
      <g:link action="create" params="[term : term]">
           <g:message code="result.create.synset" args="${[StringTools.slashUnescape(term.encodeAsHTML())]}" />
      </g:link>
    </td>
  </tr>
</table>
