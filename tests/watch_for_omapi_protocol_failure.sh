#!/usr/bin/env bash
exec &>> $HOME/omapi_watcher.log
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
echo "?????????? Watching for OMAPI Protocol failure ???????????????????????"
tail -f ${SYSLOG_PATH} | grep --line-buffered -Ei "Can't start OMAPI protocol: address not available" -m 1 &
