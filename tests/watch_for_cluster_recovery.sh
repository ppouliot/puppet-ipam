#!/usr/bin/env bash
if [ -e /var/log/messages ]; then
  SYSLOG_PATH=/var/log/messages
  NAMED_PATH=/etc/named
elif [ -e /var/log/syslog ]
then
  SYSLOG_PATH=/var/log/syslog
  NAMED_PATH=/etc/bind
else
  echo "!!!!!!!!!! No Logfiles Detected !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
  exit
fi

echo "!!!!!!!!!! Detected /var/log/messages !!!!!!!!!!!!!!!!!!!!!!!!"
echo "?????????? Waiting for DHCP Cluster Recovery ?????????????????"
tail -f ${SYSLOG_PATH} | grep --line-buffered -Ei 'Both servers have entered recover-done!' -m 1 &
wait
echo "!!!!!!!!!! Cluster recovery successfully detected !!!!!!!!!!!!"
exit
