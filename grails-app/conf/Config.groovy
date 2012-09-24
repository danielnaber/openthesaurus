
// Load the properties from classpath so they are not
// compiled to a *.class file by Grails:
//
// --WARNING--
// Due to bug https://svn.cargo.codehaus.org/browse/GRAILS-4761 this
// doesn't work after a "grails clean", so start "grails run-app" twice
// after a clean:
environments {
    test {
        grails.config.locations = [ "classpath:datasource-test.properties",
                "classpath:openthesaurus-dev.properties" ]
    }
    development {
        grails.config.locations = [ "classpath:datasource-dev.properties",
                "classpath:openthesaurus-dev.properties" ]
    }
    production {
        grails.config.locations = [ "classpath:datasource.properties",
                "classpath:openthesaurus.properties" ]
    }
}

grails.json.legacy.builder=false

/* comment in to locally test mail sending:
grails {
   mail {
     host = "smtprelaypool.ispgateway.de"
     username = "fixme"
     password = "fixme"
  }
}

// for the production system, see /etc/exim4/passwd.client

*/


if(System.properties["${appName}.config.location"]) {
    grails.config.locations << "file:" + System.properties["${appName}.config.location"]
}
// enabled native2ascii conversion of i18n properties files
grails.enable.native2ascii = true

// openthesaurus settings: see openthesaurus.properties

log4j = {
    appenders {
        console name:'stdout', layout:pattern(conversionPattern: '[%d{yyyy-MM-dd HH:mm:ss}] %-5p %c{2} - %m%n')
    }
    root {
        error 'stdout'
        additivity = true
    }
    info   'grails.app'			// logging output from my classes
    error  'org.codehaus.groovy.grails.web.servlet',  //  controllers
	       'org.codehaus.groovy.grails.web.pages', //  GSP
	       'org.codehaus.groovy.grails.web.sitemesh', //  layouts
	       'org.codehaus.groovy.grails.web.mapping.filter', // URL mapping
	       'org.codehaus.groovy.grails.web.mapping', // URL mapping
	       'org.codehaus.groovy.grails.commons', // core / classloading
	       'org.codehaus.groovy.grails.plugins', // plugins
	       'org.codehaus.groovy.grails.orm.hibernate', // hibernate integration
	       'org.springframework',
           'org.hibernate'
    warn   'org.mortbay.log'
    // Uncomment the following line to see hibernate's sql code
    // debug  'org.hibernate'  
}


// The following properties have been added by the Upgrade process...
grails.views.default.codec="none" // none, html, base64
grails.views.gsp.encoding="UTF-8"
