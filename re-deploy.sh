#/bin/sh
#dnaber, 2013-09-11
#helper script to deploy new version by overwriting the old one

echo "Files modified against git:"
LANG=C git status | grep "modified:"
read -p "Deploy now? (y/n)" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
    rm ./build/libs/openthesaurus-*.war
    grails war && \
      scp -i ~/.ssh/ot2017 ./build/libs/openthesaurus-*.war root@83.169.2.105:/home/openthesaurus/openthesaurus.war && \
      ssh -i ~/.ssh/ot2017 root@83.169.2.105 "unzip -d /home/openthesaurus/tomcat/webapps/ROOT/ /home/openthesaurus/openthesaurus.war && /etc/init.d/tomcat8 restart"
    echo "Deployed:"
    ls -l ./build/libs/openthesaurus-*.war
else
    echo "Stopped."
fi
