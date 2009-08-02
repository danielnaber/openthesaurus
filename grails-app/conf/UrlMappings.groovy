class UrlMappings {

  static mappings = {
      "404"(view:"/errors/notFound")
      
      "/$controller/$action?/$id?" {
        constraints {
            // apply constraints here
        }
      }
      
      // the search result page:
      "/overview"(controller:'redirect', action:'overview')

      // the "about" page:
      "/background"(controller:'redirect', action:'gotoAbout')

      // the synset page:
      // name clash, must be handled in SynsetController
 
      // word detail page:
      "/word_detail"(controller:'redirect', action:'worddetail')
      
      "/faq.php"(controller:'redirect', action:'faq')
      "/background.php"(controller:'redirect', action:'background')
      "/news_archive.php"(controller:'redirect', action:'newsarchive')
      "/statistics.php"(controller:'redirect', action:'statistics')
      "/top_users.php"(controller:'redirect', action:'statistics')
      "/a-z.php"(controller:'redirect', action:'az')
      "/imprint.php"(controller:'redirect', action:'imprint')
  }

}
