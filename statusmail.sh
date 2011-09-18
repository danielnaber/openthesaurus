#!/bin/sh
#dnaber, 2011-08-14

DATE=`date +"%Y-%m-%d"`
#DATE=2011-08-24
OUT=/tmp/statusmail.txt
LOG=/tmp/openthesaurus-log.txt

rm $OUT
rm $LOG

tail -n 250000 /home/dnaber/tomcat/logs/catalina.out | grep "$DATE" >$LOG

echo -n "Web Searches: " >>$OUT
grep -c "Search(ms):htm" $LOG >>$OUT

echo -n "API Searches (XML): " >>$OUT
grep -c "Search(ms):xml" $LOG >>$OUT

echo -n "API Searches (JSON): " >>$OUT
grep -c "Search(ms):jso" $LOG >>$OUT

echo -n "Warnings: " >>$OUT
grep -c "WARN" $LOG >>$OUT

echo -n "Errors: " >>$OUT    
grep -c "ERR" $LOG >>$OUT

echo -n "Succesful Logins: " >>$OUT
grep -c "login successful" $LOG >>$OUT

echo -n "Failed Logins: " >>$OUT
grep -c "login failed for user" $LOG >>$OUT

echo -n "Access denied: " >>$OUT
grep -c "Access denied" $LOG >>$OUT

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
echo "Registrations:" >>$OUT
grep -A 1 "Sent registration mail " $LOG >>$OUT

echo "" >>$OUT
echo "Warnings:" >>$OUT
grep "WARN" $LOG >>$OUT

echo "" >>$OUT
echo "Errors": >>$OUT
grep "ERROR" $LOG >>$OUT

head -n 1000 $OUT | mail -s "OpenThesaurus Status Mail" feedback@openthesaurus.de
