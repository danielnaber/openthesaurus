package vithesaurus

import com.vionto.vithesaurus.BaseformFinder
import java.sql.Connection

class BaseformService {

    static transactional = false

    BaseformFinder baseformFinder

    BaseformService() {
        baseformFinder = new BaseformFinder()
    }

    Set<String> getBaseForms(Connection conn, String query) {
        return baseformFinder.getBaseForms(conn, query)
    }
}
