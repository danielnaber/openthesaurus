<div id="foot">
    
  <div class="footerColumn" style="margin-top: 44px; margin-right: 37px;">
      <div class="claim" style="margin-bottom: 23px">
          <g:message code="homepage.tagline"/>
      </div>

      <img style="width:100%;height:2px;margin-bottom:23px" src="${createLinkTo(dir:'images',file:'hr.png')}" alt="Separator"/>

      <ul style="float: left; margin-right: 60px">
          <li><g:link controller="search" action="index"><g:message code="powersearch.headline"/></g:link></li>
          <li><g:link controller="about" action="faq"><g:message code="homepage.faq"/></g:link></li>
          <li><g:link controller="about" action="api"><g:message code="homepage.api.short"/></g:link></li>
          <li><g:link controller="tag" action="list"><g:message code="homepage.tags"/></g:link></li>
          <li><g:link controller="about" action="download"><g:message code="homepage.download"/></g:link></li>
          <li><g:link controller="userEvent" action="list"><g:message code="changelog"/></g:link></li>
          <!--<li><g:link controller="about" action="newsarchive"><g:message code="homepage.news_archive"/></g:link></li>-->
          <li><g:link controller="statistics"><g:message code="statistics"/></g:link></li>
          <li><g:link controller="about" action="imprint"><g:message code="homepage.imprint"/></g:link></li>
          <li><a href="https://languagetool.org/de">Rechtschreibprüfung</a></li>
      </ul>

      <div>
          
          <div class="iconLink">
              <table>
                  <tr>
                      <td>
                          <script type="text/javascript">
                              var firstPart = "<g:message code="footer.email.beforeAt"/>";
                              var lastPart = "<g:message code="footer.email.afterAt"/>";
                              document.write("<a href='mail" + "to:" + firstPart + "@" + lastPart + "'><img class=\"socialMediaIcon\" src=\"${createLinkTo(dir:'images',file:'icon-mail.png')}\" width=\"36\" height=\"36\" alt=\"Contact-Icon\"/><" + "/a>");
                          </script>
                      </td>
                      <td>&nbsp;</td>
                      <td>
                          <g:render template="/email" model="${['message': message(code: 'footer.email')]}"/>
                      </td>
                  </tr>
              </table>
          </div>

      </div>

  </div>
    
</div>
