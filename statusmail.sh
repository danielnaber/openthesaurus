#!/bin/sh
#dnaber, 2011-08-14

MJ_APIKEY_PUBLIC=
MJ_APIKEY_PRIVATE=
EMAIL=

DATE=`date +"%Y-%m-%d"`
#DATE="2018-12-28"
OUT=/tmp/statusmail.txt
LOG=/tmp/openthesaurus-log.txt

rm $OUT
rm $LOG

tail -n 2000000 /home/openthesaurus/tomcat/logs/catalina.out.bak2 /home/openthesaurus/tomcat/logs/catalina.out.bak /home/openthesaurus/tomcat/logs/catalina.out | grep --text "$DATE" >$LOG

echo "openthesaurus@hetzner" >>$OUT
echo "From " >>$OUT
#grep --text -h "^$DATE" /home/openthesaurus/tomcat/logs/catalina.out.bak2 /home/openthesaurus/tomcat/logs/catalina.out.bak /home/openthesaurus/tomcat/logs/catalina.out | head -n1 >>$OUT
grep --text -h "^$DATE" $LOG | head -n 1 >>$OUT
echo "To " >>$OUT
#grep --text -h "^$DATE" /home/openthesaurus/tomcat/logs/catalina.out.bak2 /home/openthesaurus/tomcat/logs/catalina.out.bak /home/openthesaurus/tomcat/logs/catalina.out | tail -n 1 >>$OUT
grep --text -h "^$DATE" $LOG | tail -n 1 >>$OUT

echo "" >>$OUT
echo -n "Web Searches:           " >>$OUT
grep -c "Search(ms):htm" $LOG >>$OUT

echo -n "API Searches (XML):     " >>$OUT
grep -c "Search(ms):xml" $LOG >>$OUT

echo -n "API Searches (JSON):    " >>$OUT
grep -c "Search(ms):jso" $LOG >>$OUT

echo -n "Blocked API requests:   " >>$OUT
grep -c "Too many API requests from" $LOG >>$OUT

echo -n "Pool exhausted:         " >>$OUT
grep -c "PoolExhaustedException" $LOG >>$OUT

echo -n "error.log entries:      " >>$OUT
grep -c "`date +"%Y/%m/%d"`" /var/log/nginx/error.log >>$OUT

echo -n "error.log entries (w/o access): " >>$OUT
grep -v "access forbidden by rule," /var/log/nginx/error.log | grep -c "`date +"%Y/%m/%d"`" >>$OUT


echo "" >>$OUT

echo "Top 5 limit abusers:" >>$OUT
grep "Too many " $LOG | cut -c 95-110 | sort | uniq -c | sort -r -n | head -n 5 >>$OUT

echo "" >>$OUT

echo -n "Errors:                       " >>$OUT
grep -v "Full Stack Trace" $LOG | grep -c "ERR" >>$OUT

echo -n "Warnings (w/o empty queries): " >>$OUT
grep "WARN" $LOG | grep -c -v "No query specified for search" >>$OUT

echo -n "Empty query warnings:         " >>$OUT
grep -c "No query specified for search" $LOG >>$OUT

echo "" >>$OUT

echo -n "Successful Logins: " >>$OUT
grep -c "login successful" $LOG >>$OUT

echo -n "Failed Logins:     " >>$OUT
grep -c "login failed for user" $LOG >>$OUT

echo -n "Access denied:     " >>$OUT
grep -c "Access denied" $LOG >>$OUT

echo "" >>$OUT

echo -n "User registrations: " >>$OUT
grep -c "Creating user:" $LOG >>$OUT

echo -n "User registration confirmations: " >>$OUT
grep -c "Confirming registration successful" $LOG >>$OUT

echo -n "Password reset requests: " >>$OUT
grep -c "Sent password reset mail" $LOG >>$OUT

echo -n "User events: " >>$OUT
grep -c "UserEvent: " $LOG >>$OUT


echo -n "OXT exports: " >>$OUT
grep -c "Writing data export for OXT" $LOG >>$OUT

echo -n "Memory database updates: " >>$OUT          
grep -c "Finished creating in-memory database" $LOG >>$OUT

echo "" >>$OUT
echo "Private messages sent: " >>$OUT
grep "Sending private email from" $LOG >>$OUT

echo "" >>$OUT
echo "Registrations:" >>$OUT
grep "Sent registration mail " $LOG >>$OUT

echo "" >>$OUT
echo "Top 5 Similarities:" >>$OUT
grep " Similar to " $LOG | sed 's/.*Similar to /Similar to /' | sort | uniq -c | sort -r -n | head -n 5 >>$OUT

#echo "" >>$OUT
#echo "Similarities (max. 100):" >>$OUT
#grep " Similar to " $LOG | head -n 100 >>$OUT

echo "" >>$OUT
echo "Warnings (without empty queries):" >>$OUT
grep "WARN" $LOG | grep -v "No query specified for search" >>$OUT

echo "" >>$OUT
echo -n "Client-side errors: " >>$OUT
grep -c "client message:" $LOG >>$OUT
echo "Client-side errors (max. 20):" >>$OUT
grep "client message:" $LOG | grep -v "Cannot read property 'length' of undefined" | head -n 20 >>$OUT

echo "" >>$OUT
echo "Top client-side errors: " >>$OUT
grep "client message:" tomcat/logs/catalina.out | sed 's/.*client message: //' | grep -v "Cannot read property 'length' of undefined" | sed 's/ - .*//' | sort | uniq -c | sort -r -n | head -n 10 >> $OUT

echo "" >>$OUT
echo -n "Total errors: " >>$OUT
grep -v "Full Stack Trace" $LOG | grep " ERROR " | wc -l >>$OUT
echo "Errors (max. 25):" >>$OUT
grep -v "Full Stack Trace" $LOG | grep " ERROR " | head -n 25 >>$OUT

#echo "" >>$OUT
#echo "Apache Errors (max. 25):" >>$OUT
#echo "Total Apache errors: `wc -l apache_errors.log`" >>$OUT
#tail -n 25 apache_errors.log >>$OUT

PART1=feedback
#head -n 1000 $OUT | mail -a "From: $PART1@openthesaurus.de" -a 'Content-Type: text/plain; charset=utf-8' -s "OpenThesaurus Status Mail" $PART1@openthesaurus.de

MAIL_TEXT=`cat $OUT | python -c 'import json,sys; print(json.dumps(sys.stdin.read()))'`
JSON="{\"Messages\":[{\"From\": {\"Email\": \"$EMAIL\"}, \"To\": [{\"Email\": \"$EMAIL\"} ],\"Subject\": \"OpenThesaurus Status Mail\", \"TextPart\": ${MAIL_TEXT}}]}"

curl -s \
    -X POST \
    --user "$MJ_APIKEY_PUBLIC:$MJ_APIKEY_PRIVATE" \
    https://api.mailjet.com/v3.1/send \
    -H "Content-Type: application/json" \
    -d "${JSON}"


