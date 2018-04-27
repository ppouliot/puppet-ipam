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
echo "?????????? Checking for DyN DNS ??????????????????????????????"
tail -f  ${SYSLOG_PATH} | grep --line-buffered -Ei 'generating session key for dynamic DNS' -m 2 &
wait
echo "!!!!!!!!!! DyN DNS FOUND   !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
exit
