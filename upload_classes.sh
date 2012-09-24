#/bin/sh
#dnaber, 2008-09-22, 2009-08-02
#helper script to deploy new version by overwriting the old one

rm -rf temp-unzip
grails war
unzip -d temp-unzip target/openthesaurus-1.2.0.war

cd temp-unzip

scp -r WEB-INF/classes/ WEB-INF/grails-app/ WEB-INF/tld/ WEB-INF/*.xml openthesaurus.de:~/tomcat/webapps/ROOT/WEB-INF/
scp -r WEB-INF/grails-app/i18n/* openthesaurus.de:~/tomcat/webapps/ROOT/WEB-INF/grails-app/i18n/
scp -r css/ openthesaurus.de:~/tomcat/webapps/ROOT/
