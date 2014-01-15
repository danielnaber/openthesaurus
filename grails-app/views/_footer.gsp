<div id="foot">
    
  <div class="footerColumn" style="margin-top: 44px; margin-right: 37px;">
      <div class="claim" style="margin-bottom: 20px">
          <g:message code="homepage.tagline"/>
      </div>

      <img style="width:100%;height:2px;margin-bottom:20px" src="${createLinkTo(dir:'images',file:'hr.png')}" alt="Separator"/>

      <ul style="float: left; margin-right: 60px">
          <li><g:link controller="about"><g:message code="homepage.about"/></g:link></li>
          <li><a href="/jforum/forums/show/1.page">Forum</a></li>
          <li><g:link controller="about" action="faq"><g:message code="homepage.faq"/></g:link></li>
          <li><g:link controller="about" action="newsletter"><g:message code="homepage.mailing_list"/></g:link></li>
          <li><g:link controller="about" action="newsarchive"><g:message code="homepage.news_archive"/></g:link></li>
          <li><g:link controller="userEvent" action="list"><g:message code="changelog"/></g:link></li>
          <li><g:link controller="statistics"><g:message code="statistics"/></g:link></li>

          <li style="margin-top:16px"><g:link controller="woerter" action="listen"><g:message code="homepage.wordlists"/></g:link></li>
          <li><g:link controller="about" action="api"><g:message code="homepage.api"/></g:link></li>
          <li><g:link controller="about" action="download"><g:message code="homepage.download"/></g:link></li>

          <li style="margin-top:16px"><g:link controller="about" action="imprint"><g:message code="homepage.imprint"/></g:link></li>
      </ul>

      <div>
          
          <div class="iconLink">
              <table>
                  <tr>
                      <td>
                          <script type="text/javascript">
                              <!--
                              var firstPart = "<g:message code="footer.email.beforeAt"/>";
                              var lastPart = "<g:message code="footer.email.afterAt"/>";
                              document.write("<a href='mail" + "to:" + firstPart + "@" + lastPart + "'><img src=\"${createLinkTo(dir:'images',file:'icon-mail.png')}\" width=\"30\" height=\"30\" alt=\"Contact-Icon\"/><" + "/a>");
                              // -->
                          </script>
                      </td>
                      <td>&nbsp;</td>
                      <td>
                          <script type="text/javascript">
                              <!--
                              var firstPart = "<g:message code="footer.email.beforeAt"/>";
                              var lastPart = "<g:message code="footer.email.afterAt"/>";
                              document.write("<a class=\"lightlink\" href='mail" + "to:" + firstPart + "@" + lastPart + "'><g:message code="footer.email"/><" + "/a>");
                              // -->
                          </script>
                      </td>
                  </tr>
              </table>
          </div>
          <div class="iconLink">
              <table>
                  <tr>
                      <td><a href="http://twitter.com/openthesaurus"><img src="${createLinkTo(dir:'images',file:'icon-twitter.png')}" width="30" height="30" alt="Twitter-Icon"/></a></td>
                      <td>&nbsp;</td>
                      <td><g:message code="footer.twitter"/></td>
                  </tr>
              </table>
          </div>

      </div>

  </div>
    
  <div class="footerColumn">
      <div style="margin-bottom: 20px">
        <g:render template="/ads/footer"/>
      </div>

      <img style="width:100%;height:2px;margin-bottom:20px" src="${createLinkTo(dir:'images',file:'hr.png')}" alt="Separator"/>
  </div>

</div>
