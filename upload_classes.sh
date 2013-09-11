#/bin/sh
#dnaber, 2013-09-11
#helper script to deploy new version by overwriting the old one

rm target/openthesaurus-*.war
grails war
scp target/openthesaurus-*.war openthesaurus.de:openthesaurus.war
echo "Now login to the server and call:"
echo "  unzip -d tomcat/webapps/ROOT/ openthesaurus.war"
echo "  ./restart.sh"
