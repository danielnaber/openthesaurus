#/bin/sh
#dnaber, 2013-09-11
#helper script to deploy new version by overwriting the old one

rm target/openthesaurus-*.war
grails war && \
  scp -i ~/.ssh/ot2014/openthesaurus2014 target/openthesaurus-*.war openthesaurus.de:openthesaurus.war && \
  ssh -i ~/.ssh/ot2014/openthesaurus2014 openthesaurus.de "unzip -d tomcat/webapps/ROOT/ openthesaurus.war && ./restart.sh"
