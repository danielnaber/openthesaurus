package openthesaurus

class UrlMappings {

  static mappings = {
      "404"(view:"/errors/notFound")
      "500"(view:"/errors/serverError")

      "/"(controller:'home', action:'index')
      "/ads.txt"(controller:'home', action:'adstxt')
      "/googleTODO.html"(controller:'home', action:'google')
      "/direct"(controller:'redirect', action:'homepage') 
      "/home/directSearch"(controller:'redirect', action:'homepage') 
      "/home/"(controller:'redirect', action:'homepage') 
      
      "/woerter/listen"(controller:'wordList', action:'index')

//      "/tag/index"(controller: 'tag', action: 'list')
      
      "/$controller/$action?/$id?" {
        constraints {
            // apply constraints here
        }
      }

      // better (= more readable) URLs:
      "/synonyme/edit/$id"(controller:'synset', action:'edit')
      "/synonyme/edit"(controller:'synset', action:'edit')
      "/synonyme/search"(controller:'synset', action:'oldSearch')
      "/synonyme/$q"(controller:'synset', action:'search')
      // URLs like http://localhost:8080/openthesaurus/synonyme?q=Blechb%C3%BCchse&x=16&y=16 caused by
      // clicking the submit button with Javascript disabled:
      "/synonyme"(controller:'redirect', action:'searchwithoutjavascript')

      "/synset/search"(controller:'redirect', action:'synsetsearchredirect')
      "/synset/edit/$id"(controller:'redirect', action:'synseteditredirect')
      "/synset/edit"(controller:'redirect', action:'synseteditredirect')

      "/robots.txt"(controller: 'robots', action: 'index')

      // the RSS feed page:
      "/feed.xml"(controller:'redirect', action:'feed')

  }

}
