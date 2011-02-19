<div id="foot">
  <table width="800">
    <tr>
      <td height="120" width="370" class="claim" colspan="2">
        <div style="margin-bottom: 20px">
          OpenThesaurus ist ein freies deutsches Synonymwörterbuch, bei dem jeder mitmachen kann.
        </div>
      </td>
      <td width="60"></td>
      <td width="370" class="visualads">
        <g:if test="${homepage}">
          <g:render template="/ads/newhomepage"/>
        </g:if>
      </td>
    </tr>
    <tr>
      <td colspan="2">
        <img style="width:100%;height:2px;margin-bottom:20px" src="${createLinkTo(dir:'images',file:message(code:'hr.png'))}" alt="Trennlinie"/>
      </td>
      <td></td>
      <td>
        <img style="width:100%;height:2px;margin-bottom:20px" src="${createLinkTo(dir:'images',file:message(code:'hr.png'))}" alt="Trennlinie"/>
      </td>
    </tr>
    <tr>
      <td width="270">
        <ul>
          <li><g:link controller="about"><g:message code="homepage.about"/></g:link></li>
          <li><g:link controller="about" action="faq"><g:message code="homepage.faq"/></g:link></li>
          <li><g:link url="http://lists.berlios.de/mailman/listinfo/openthesaurus-discuss"><g:message code="homepage.mailing_list"/></g:link></li>
          <li><g:link controller="about" action="newsarchive"><g:message code="homepage.news_archive"/></g:link></li>
          <li><g:link controller="userEvent" action="list"><g:message code="changelog"/></g:link></li>
          <li><g:link controller="synset" action="statistics"><g:message code="statistics"/></g:link></li>

          <li style="margin-top:16px"><g:link controller="woerter" action="listen"><g:message code="homepage.wordlists"/></g:link></li>
          <li><g:link controller="about" action="api"><g:message code="homepage.api"/></g:link></li>
          <li><g:link controller="about" action="download"><g:message code="homepage.download"/></g:link></li>

          <li style="margin-top:16px"><g:link controller="about" action="imprint"><g:message code="homepage.imprint"/></g:link></li>
        </ul>
      </td>
      <td width="130">
        <div class="iconLink">
          <table>
            <tr>
            <g:if test="${session.user}">
                <td>
                  <img src="${createLinkTo(dir:'images',file:'icon-login.png')}" alt="Login-Icon"/>
                </td>
                <td>&nbsp;</td>
                <td>
                  <g:link controller="user" action="logout">Logout ${session.user.userId.toString()?.encodeAsHTML()}</g:link>
                </td>
            </g:if>
            <g:else>
                <td>
                  <g:if test="${params.q}">
                    <g:set var="linkParams" value="${[q: params.q, controllerName: webRequest.getControllerName(),
                               actionName:webRequest.getActionName(), origId: params.id]}" />
                  </g:if>
                  <g:elseif test="${params.id}">
                    <g:set var="linkParams" value="${[controllerName: webRequest.getControllerName(),
                             actionName:webRequest.getActionName(), origId: params.id]}" />
                  </g:elseif>
                  <g:else>
                    <g:set var="linkParams" value="${[controllerName: webRequest.getControllerName(),
                                actionName:webRequest.getActionName()]}" />
                  </g:else>
                  <g:link controller="user" action="login"
                     params="${linkParams}"><img src="${createLinkTo(dir:'images',file:'icon-login.png')}" alt="Login-Icon"/></g:link>
                </td>
                <td>&nbsp;</td>
                <td>
                    <g:link controller="user" action="login" class="lightlink"
                       params="${linkParams}"><strong>Anmelden</strong> und mitmachen</g:link>
                </td>
            </g:else>
            </tr>
          </table>
        </div>
        <div class="iconLink">
          <table>
            <tr>
              <td><a href="http://twitter.com/openthesaurus"><img src="${createLinkTo(dir:'images',file:'icon-twitter.png')}" alt="Twitter-Icon"/></a></td>
              <td>&nbsp;</td>
              <td><a class="lightlink" href="http://twitter.com/openthesaurus">Folge uns auf <strong>twitter</strong></a></td>
            </tr>
          </table>
        </div>
        <div class="iconLink">
          <table>
            <tr>
              <td>
                <script type="text/javascript">
                <!--
                var firstPart = "feedback";
                var lastPart = "openthesaurus.de";
                document.write("<a href='mail" + "to:" + firstPart + "@" + lastPart + "'><img src=\"${createLinkTo(dir:'images',file:'icon-mail.png')}\" alt=\"Kontakt-Icon\"/><" + "/a>");
                // -->
                </script>
              </td>
              <td>&nbsp;</td>
              <td>
                <script type="text/javascript">
                <!--
                var firstPart = "feedback";
                var lastPart = "openthesaurus.de";
                document.write("<a class=\"lightlink\" href='mail" + "to:" + firstPart + "@" + lastPart + "'>Schreibe uns eine <strong>E-Mail<" + "/strong><" + "/a>");
                // -->
                </script>
              </td>
            </tr>
          </table>
        </div>
        <div class="iconLink">
          <table>
            <tr>
              <td><a href="http://www.androidpit.de/de/android/market/apps/app/com.fc.ot/OpenThesaurus-fuer-Android"><img src="${createLinkTo(dir:'images',file:'icon-android.png')}" alt="Android-Icon"/></a></td>
              <td>&nbsp;</td>
              <td><a class="lightlink" href="http://www.androidpit.de/de/android/market/apps/app/com.fc.ot/OpenThesaurus-fuer-Android">OpenThesaurus für <strong>Android</strong></a></td>
            </tr>
          </table>
        </div>
      </td>
      <td>
      </td>
      <td>
        <g:if test="${homepage}">
            <g:render template="/ads/homepage_bottom"/>
        </g:if>
      </td>
    </tr>
  </table>
</div>
