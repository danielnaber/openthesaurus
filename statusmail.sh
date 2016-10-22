#!/bin/sh
#dnaber, 2011-08-14

DATE=`date +"%Y-%m-%d"`
#DATE=2011-08-24
OUT=/tmp/statusmail.txt
LOG=/tmp/openthesaurus-log.txt

rm $OUT
rm $LOG

tail -n 250000 /home/dnaber/tomcat/logs/catalina.out.bak2 /home/dnaber/tomcat/logs/catalina.out.bak /home/dnaber/tomcat/logs/catalina.out | grep "$DATE" >$LOG

echo "From " >>$OUT
grep -h $DATE /home/dnaber/tomcat/logs/catalina.out.bak2 /home/dnaber/tomcat/logs/catalina.out.bak /home/dnaber/tomcat/logs/catalina.out | head -n1 >>$OUT
echo "To " >>$OUT
grep -h $DATE /home/dnaber/tomcat/logs/catalina.out.bak2 /home/dnaber/tomcat/logs/catalina.out.bak /home/dnaber/tomcat/logs/catalina.out | tail -n 1 >>$OUT

echo "" >>$OUT
echo -n "Web Searches: " >>$OUT
grep -c "Search(ms):htm" $LOG >>$OUT

echo -n "API Searches (XML): " >>$OUT
grep -c "Search(ms):xml" $LOG >>$OUT

echo -n "API Searches (JSON): " >>$OUT
grep -c "Search(ms):jso" $LOG >>$OUT

echo -n "Blocked API requests: " >>$OUT
grep -c "Too many requests from" $LOG >>$OUT

echo "" >>$OUT

echo -n "Errors: " >>$OUT
grep -c "ERR" $LOG >>$OUT

echo -n "Warnings (without empty queries): " >>$OUT
grep "WARN" $LOG | grep -c -v "No query specified for search" >>$OUT

echo -n "Empty query warnings: " >>$OUT
grep -c "No query specified for search" $LOG >>$OUT

echo "" >>$OUT

echo -n "Successful Logins: " >>$OUT
grep -c "login successful" $LOG >>$OUT

echo -n "Failed Logins: " >>$OUT
grep -c "login failed for user" $LOG >>$OUT

echo -n "Access denied: " >>$OUT
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
echo "Errors": >>$OUT
grep "ERROR" $LOG >>$OUT

echo "" >>$OUT
echo "Apache Errors (max. 10)": >>$OUT
tail -n 10 apache_errors.log >>$OUT

head -n 1000 $OUT | mail -a 'From: feedback@openthesaurus.de' -a 'Content-Type: text/plain; charset=utf-8' -s "OpenThesaurus Status Mail" feedback@openthesaurus.de
