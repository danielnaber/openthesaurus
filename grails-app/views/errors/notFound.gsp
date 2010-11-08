<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <title><g:message code="notfound.title" /></title>
    </head>
    <body>

      <div style="text-align: center;margin-top: 40px">

        <h1 style="text-align:center;margin-bottom:20px"><g:message code="notfound.headline" /></h1>

        <g:if test="${flash.message}">
          <div class="message">${flash.message}</div>
        </g:if>
        
        <g:form name="searchform" class="mainpage" action="search" controller="synset" method="get">

            <input name="q" value="${params?.q?.encodeAsHTML()}" />&nbsp;

            <input class="submit" type="submit" value="<g:message code="search.button"/>" />

            <br/>
            <br/>

            <a href="${createLinkTo(dir:'/',file:'')}"><g:message code="notfound.homepage.link"/></a>

        </g:form>
      </div>

      <script type="text/javascript">
      <!--
          document.searchform.q.focus();
      // -->
      </script>

    </body>
</html>
