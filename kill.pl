#!/usr/bin/perl
# Kill -9 and restart tomcat
# dnaber, 2011-01-14

$result = `ps ux | grep tomcat | grep -v grep`;
@parts = split(/\s+/, $result);
$pid = $parts[1];
if ($pid !~ m/[0-9]+/) {
  print "Invalid PID: $pid\n";
} else {
  print "Killing PID $pid\n";
  `kill -9 $pid`;
  sleep 1;
  `/home/dnaber/tomcat/bin/startup.sh`
}
