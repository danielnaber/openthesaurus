class UrlMappings {

  static mappings = {
      "404"(view:"/errors/notFound")
      
      "/$controller/$action?/$id?" {
        constraints {
            // apply constraints here
        }
      }

      // better (= more readable) URLs:
      "/synonyme/search"(controller:'synset', action:'search')
      "/synonyme/edit"(controller:'synset', action:'edit')
      "/synset/search"(controller:'redirect', action:'synsetsearchredirect')
      "/synset/edit"(controller:'redirect', action:'synseteditredirect')


      // the search result page:
      "/overview.php"(controller:'redirect', action:'overview')

      // the synset page:
      "/synset.php"(controller:'redirect', action:'synset')
 
      // word detail page:
      "/word_detail.php"(controller:'redirect', action:'worddetail')

      // the RSS feed page:
      "/feed.xml"(controller:'redirect', action:'feed')

      // the other pages:
      "/background.php"(controller:'redirect', action:'gotoAbout')
      "/faq.php"(controller:'redirect', action:'faq')
      "/background.php"(controller:'redirect', action:'background')
      "/news_archive.php"(controller:'redirect', action:'newsarchive')
      "/statistics.php"(controller:'redirect', action:'statistics')
      "/top_users.php"(controller:'redirect', action:'statistics')
      "/a-z.php"(controller:'redirect', action:'az')
      "/imprint.php"(controller:'redirect', action:'imprint')
      "/variation.php"(controller:'redirect', action:'variation')
      "/tree.php"(controller:'redirect', action:'tree')
      "/login.php"(controller:'redirect', action:'login')
      "/register.php"(controller:'redirect', action:'register')
      "/substring_search.php"(controller:'redirect', action:'substringSearch')
  }

}
