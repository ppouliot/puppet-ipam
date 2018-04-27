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

echo "??????????? Watching for TSIG    ???????????????????????????????" 
tail -f ${SYSLOG_PATH} | grep --line-buffered -Ei "TSIG" -m 1
wait
echo "!!!!!!!!!!! TSIG Found           !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
exit
