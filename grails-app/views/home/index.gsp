<!doctype html>
<%@page import="com.vionto.vithesaurus.*" %>
<html>
<head>
  <title><g:message code="homepage.title"/></title>
  <meta name="layout" content="homepage" />
</head>
<body>

  <div id="body" style="padding:130px 0 120px 0;">

    <div id="content">

      <g:render template="/searchform" model="${[homepage: true]}"/>

      <g:render template="/loggedin"/>

      <g:if test="${flash.message}">
          <div class="message">${flash.message}</div>
      </g:if>

    </div>

  </div>

  <g:render template="/footer" model="${[homepage:true]}"/>

</body>
</html>
