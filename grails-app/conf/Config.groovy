
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
                "classpath:vithesaurus.properties" ]
    }
    development {
        grails.config.locations = [ "classpath:datasource-dev.properties",
                "classpath:vithesaurus.properties" ]
    }
    production {
        grails.config.locations = [ "classpath:datasource.properties",
                "classpath:vithesaurus.properties" ]
    }
}

// locations to search for config files that get merged into the main config
// config files can either be Java properties files or ConfigSlurper scripts

// grails.config.locations = [ "classpath:${appName}-config.properties",
//                             "classpath:${appName}-config.groovy",
//                             "file:${userHome}/.grails/${appName}-config.properties",
//                             "file:${userHome}/.grails/${appName}-config.groovy"]

if(System.properties["${appName}.config.location"]) {
    grails.config.locations << "file:" + System.properties["${appName}.config.location"]
}
// enabled native2ascii conversion of i18n properties files
grails.enable.native2ascii = true

// vithesaurus settings: see vithesaurus.properties

// log4j configuration
log4j {
    appender.file = "org.apache.log4j.FileAppender"
    appender.'file.file' = "vithesaurus.log"
    appender.stdout = "org.apache.log4j.ConsoleAppender"
	appender.'stdout.layout'="org.apache.log4j.PatternLayout"
 	appender.'stdout.layout.ConversionPattern'='[%d{yyyy-MM-dd HH:mm:ss}] %-5p %c{2} %m%n'
    appender.'file.layout'="org.apache.log4j.PatternLayout"
    appender.'file.layout.ConversionPattern'='[%d{yyyy-MM-dd HH:mm:ss}] %-5p %c{2} %m%n'
    rootLogger="error,stdout,file"
    logger {
        grails="info,stdout,file"
        org {
            codehaus.groovy.grails.web.servlet="error,stdout"  //  controllers
            codehaus.groovy.grails.web.errors="error,stdout"  //  web layer errors            
			codehaus.groovy.grails.web.pages="error,stdout" //  GSP
        	codehaus.groovy.grails.web.sitemesh="error,stdout" //  layouts
        	codehaus.groovy.grails."web.mapping.filter"="error,stdout" // URL mapping
        	codehaus.groovy.grails."web.mapping"="error,stdout" // URL mapping
            codehaus.groovy.grails.commons="info,stdout" // core / classloading
            codehaus.groovy.grails.plugins="error,stdout" // plugins
            codehaus.groovy.grails.orm.hibernate="error,stdout" // hibernate integration
            springframework="off,stdout"
            hibernate="off,stdout"
            // SQL debugging:
            //hibernate="debug,stdout,file"
            //hibernate="trace,stdout,file"   // also show SQL parameters
        }
    }
    additivity.'default' = false
    additivity {
		grails=false
		org {
           codehaus.groovy.grails=false
           springframework=false
		   hibernate=false
		}
    }
}


// The following properties have been added by the Upgrade process...
grails.views.default.codec="none" // none, html, base64
grails.views.gsp.encoding="UTF-8"
