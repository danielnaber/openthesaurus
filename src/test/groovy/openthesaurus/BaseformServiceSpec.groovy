package openthesaurus

import com.mysql.jdbc.exceptions.jdbc4.MySQLSyntaxErrorException
import com.vionto.vithesaurus.BaseformFinder
import spock.lang.Specification
import spock.lang.Unroll

import java.sql.Connection
import java.sql.SQLException
import java.sql.SQLSyntaxErrorException

class BaseformServiceSpec extends Specification {

    @Unroll
    void "missing optional word_mapping table is tolerated for #exception.class.simpleName"() {
        given:
        def connection = Stub(Connection)
        def service = new BaseformService()
        service.baseformFinder = Stub(BaseformFinder) {
            getBaseForms(connection, 'sample beacon') >> { throw exception }
        }

        expect:
        service.getBaseForms(connection, 'sample beacon') == []

        where:
        exception << [new SQLSyntaxErrorException('Table word_mapping does not exist', '42S02', 1146),
                      new MySQLSyntaxErrorException('Table word_mapping does not exist', '42S02', 1146)]
    }

    void "other database failures still propagate"() {
        given:
        def connection = Stub(Connection)
        def failure = new SQLException('Connection lost', '08006')
        def service = new BaseformService()
        service.baseformFinder = Stub(BaseformFinder) {
            getBaseForms(connection, 'sample beacon') >> { throw failure }
        }

        when:
        service.getBaseForms(connection, 'sample beacon')

        then:
        SQLException exception = thrown()
        exception.is(failure)
    }
}
