grails.servlet.version = "2.5" // Change depending on target container compliance (2.5 or 3.0)
grails.project.class.dir = "target/classes"
grails.project.test.class.dir = "target/test-classes"
grails.project.test.reports.dir = "target/test-reports"
grails.project.target.level = 1.7
grails.project.source.level = 1.7
grails.project.dependency.resolver = "maven"

grails.project.dependency.resolution = {
    // inherit Grails' default dependencies
    inherits("global") {
        // uncomment to disable ehcache
        // excludes 'ehcache'
    }
    log "error" // log level of Ivy resolver, either 'error', 'warn', 'info', 'debug' or 'verbose'
    checksums true // Whether to verify checksums on resolve

    repositories {
        inherits true // Whether to inherit repository definitions from plugins
        grailsPlugins()
        grailsHome()
        grailsCentral()
        mavenCentral()

        // uncomment these to enable remote dependency resolution from public Maven repositories
        //mavenCentral()
        //mavenLocal()
        //mavenRepo "http://snapshots.repository.codehaus.org"
        //mavenRepo "http://repository.codehaus.org"
        //mavenRepo "http://download.java.net/maven/2/"
        //mavenRepo "http://repository.jboss.com/maven2/"
    }
    dependencies {
        // specify dependencies here under either 'build', 'compile', 'runtime', 'test' or 'provided' scopes eg.

        compile 'org.apache.commons:commons-compress:1.9'
        runtime 'com.google.guava:guava:21.0'
        runtime 'mysql:mysql-connector-java:5.1.30'
        runtime 'commons-codec:commons-codec:1.10'
        test "net.sourceforge.htmlunit:htmlunit:2.10"  // 2.11 didn't work...
    }

    plugins {
        runtime ":hibernate:3.6.10.16"
        runtime ":jquery:1.7.1"
        runtime ":resources:1.2.8"
        compile ":feeds:1.6"
        compile ':scaffolding:1.0.0'
        compile ":mail:1.0.7"

        // Uncomment these (or add new ones) to enable additional resources capabilities
        //runtime ":zipped-resources:1.0"
        //runtime ":cached-resources:1.0"
        //runtime ":yui-minify-resources:0.1.4"

        build ":tomcat:7.0.54"
        
        test(":webtest:3.0.1") {
            excludes 'htmlunit'
        }
    }
}
