#/bin/sh
#dnaber, 2013-09-11
#helper script to deploy new version by overwriting the old one

rm target/openthesaurus-*.war
grails war && \
  scp -i ~/.ssh/ot2017 ./build/libs/openthesaurus-*.war root@83.169.2.105:/home/openthesaurus/openthesaurus.war && \
  ssh -i ~/.ssh/ot2017 root@83.169.2.105 "unzip -d /home/openthesaurus/tomcat/webapps/ROOT/ /home/openthesaurus/openthesaurus.war && /etc/init.d/tomcat8 restart"
echo "Deployed:"
ls -l ./build/libs/openthesaurus-*.war
