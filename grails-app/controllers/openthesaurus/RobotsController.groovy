// grails-app/controllers/yourapp/RobotsController.groovy
package openthesaurus

class RobotsController {
    def index() {
        render(contentType: 'text/plain', text: """\
User-agent: meta-externalagent
Disallow: /random/
""")
    }
}
