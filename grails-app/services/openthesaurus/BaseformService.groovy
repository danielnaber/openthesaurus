package openthesaurus

import com.vionto.vithesaurus.BaseformFinder
import java.sql.Connection
import java.sql.SQLSyntaxErrorException

class BaseformService {

    static transactional = false

    BaseformFinder baseformFinder

    BaseformService() {
        baseformFinder = new BaseformFinder()
    }

    List<String> getBaseForms(Connection conn, String query) {
        try {
            return baseformFinder.getBaseForms(conn, query)
        } catch (SQLSyntaxErrorException e) {
            // as the word_mapping table is not part of the dump by default because of its size, don't fail here
            log.info("Could not get baseform for query '${query}' - maybe no word_mapping table exists? " + e.toString())
            return []
        }
    }
}
