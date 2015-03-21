/**
 * OpenThesaurus - web-based thesaurus management tool
 * Copyright (C) 2012 Daniel Naber (www.danielnaber.de)
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as
 * published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
import com.vionto.vithesaurus.ThesaurusConfigurationEntry
import org.junit.Ignore
import org.springframework.mock.web.MockHttpServletRequest

@Ignore("doesn't work after Grails update")
class RequestLimiterServiceTest extends GroovyTestCase {

    def requestLimiterService

    void testRequestLimiterService() {
        init()
        def request1 = new MockHttpServletRequest()
        request1.addHeader("X-Forwarded-For", "1.1.1.1")

        def request2 = new MockHttpServletRequest()
        request2.addHeader("X-Forwarded-For", "1.1.1.2")

        for (int i = 0; i < 5; i++) {
            requestLimiterService.preventRequestFlooding(request1)
        }

        requestLimiterService.preventRequestFlooding(request2)  // different IP won't get blocked

        //noinspection GroovyUnusedCatchParameter
        try {
            requestLimiterService.preventRequestFlooding(request1)
            fail("request should have been blocked")
        } catch (Exception expected) {
        }

        Thread.sleep(4 * 1000)
        requestLimiterService.preventRequestFlooding(request1)  // requests possible again for this IP
    }

    private void init() {
        ThesaurusConfigurationEntry entry = new ThesaurusConfigurationEntry(key: 'requestLimitMaxAgeSeconds', value: 3)
        entry.save(flush: true, failOnError: true)
    }
}
