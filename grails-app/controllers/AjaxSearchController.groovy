import java.sql.Connection

class AjaxSearchController extends BaseController {

    def dataSource       // will be injected

    /**
     * Return a simplified search result (exact and substring matches) to be fetched
     * via Ajax.
     * 
     * TODO: duplicate matches, e.g. for "Saxofon"
     * TODO: grüß matches gruß and vice versa
     */
    def ajaxMainSearch = {
        long startTime = System.currentTimeMillis()
        SynsetController synsetController = new SynsetController()
        String query = params.q.trim()
        def directMatches = synsetController.doSearch(query, null, null, null, 10, 0)
        def synsetList = directMatches.synsetList
        def substringSynsetList = []
        def minLengthForSubstringQuery = 3
        if (query.length() >= minLengthForSubstringQuery) {
            Connection conn = dataSource.getConnection()
            try {
                def substringTermMatches = synsetController.searchPartialResult(query, conn, 0, 5)
                for (substringMatch in substringTermMatches) {
                    def substringMatches = synsetController.doSearch(substringMatch.term, null, null, null, 10, 0)
                    substringSynsetList.addAll(substringMatches.synsetList) 
                }
            } finally {
                conn.close()
            }
        }
        long runTime = System.currentTimeMillis() - startTime
        log.info("ajaxSearch: ${runTime}ms for '${query}'")
        [synsetList: synsetList, substringSynsetList: substringSynsetList,
         minLengthForSubstringQuery: minLengthForSubstringQuery]
    }

}