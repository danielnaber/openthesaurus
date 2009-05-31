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
      
      // the synset page:
      // name clash, must be handled in SynsetController
 
      // word detail page:
      "/word_detail"(controller:'redirect', action:'worddetail')
  }

}
