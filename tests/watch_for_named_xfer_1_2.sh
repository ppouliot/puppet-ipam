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
echo "?????????? Waiting for BIND named XFER ???????????????????????"
tail -f ${SYSLOG_PATH} | grep --line-buffered -Ei 'AXFR started' -m 2 &
echo "!!!!!!!!!! Named XFER Successfully Detected !!!!!!!!!!!!!!!!!!"
