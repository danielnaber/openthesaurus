#!/bin/sh
#dnaber, 2016-11-08

FIRSTPART=naber
LASTPART=danielnaber.de

tail -n 100000 tomcat2/logs/catalina.out | grep "`date +"%Y-%m-%d %H:"`" tomcat2/logs/catalina.out | \
        egrep "ERROR|SEVERE" | tail -n 100 | \
        ifne mail -a 'Content-Type: text/plain; charset=utf-8' -s "Hourly OpenThesaurus Error Report" ${FIRSTPART}@${LASTPART}
