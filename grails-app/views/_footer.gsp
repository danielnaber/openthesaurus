<div id="foot">
  <table width="800">
    <tr>
      <td width="370" height="145" colspan="2" class="claim">
        <div style="margin-bottom: 20px">
          OpenThesaurus ist ein freies deutsches Synonymwörterbuch, bei dem jeder mitmachen kann.
        </div>
      </td>
      <td width="60"></td>
      <td width="370">
        <g:render template="/ads/newhomepage"/>
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
          <li><g:link controller="about" action="api"><g:message code="homepage.api"/></g:link></li>
          <li><g:link controller="about" action="download"><g:message code="homepage.download"/></g:link></li>
          <li><g:link controller="about" action="newsarchive"><g:message code="homepage.news_archive"/></g:link></li>

          <li><g:link controller="synset" action="variation" id="at"><g:message code="austrian.words"/></g:link></li>
          <li><g:link controller="synset" action="variation" id="ch"><g:message code="swiss.words"/></g:link></li>
          <li><g:link controller="tree" action="index"><g:message code="tree.headline"/></g:link></li>
          <li><g:link controller="synset" action="statistics"><g:message code="statistics"/></g:link></li>
          <li><g:link controller="userEvent" action="list"><g:message code="changelog"/></g:link></li>
          <li style="margin-top:15px"><g:link controller="about" action="imprint"><g:message code="homepage.imprint"/></g:link></li>
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
                  ${session.user.userId.toString()?.encodeAsHTML()}
                  <g:link controller="user" action="logout">Logout</g:link>
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
                    <g:link controller="user" action="login"
                       params="${linkParams}">Anmelden</g:link> und mitmachen
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
              <td>Folge uns auf <a href="http://twitter.com/openthesaurus">twitter</a></td>
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
                document.write(" Schreibe uns eine " + "<a href='mail" + "to:" + firstPart + "@" + lastPart + "'>E-Mail<" + "/a>");
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
              <td>OpenThesaurus für <a href="http://www.androidpit.de/de/android/market/apps/app/com.fc.ot/OpenThesaurus-fuer-Android">Android</a></td>
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
