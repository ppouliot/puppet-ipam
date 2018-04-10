#!/usr/bin/env bash
if [ -e /var/log/messages ]; then
  echo "!!!!!!!!!! /var/log/messages detected !!!!!!!!!!"
  echo "!!!!!!!!!!  waiting for dns named xfer !!!!!!!!!!!"
  tail -f /var/log/messages | grep --line-buffered -Ei 'AXFR started' -m 2
  echo "!!!!!!!!!!  named xfer successfully detected !!!!!!!!!!!"
  echo "!!!!!!!!!! waiting for dhcp cluster recovery !!!!!!!!!!!"
  tail -f /var/log/messages | grep --line-buffered -Ei 'Both servers have entered recover-done!' -m 1
  echo "!!!!!!!!!!  Cluster recovery successfully detected !!!!!!!!!!"
fi

if [ -e /var/log/syslog ]; then
  echo "!!!!!!!!!! /var/log/syslog detected !!!!!!!!!!!!"
  echo "!!!!!!!!!!  waiting for dns named xfer !!!!!!!!!!!"
  tail -f /var/log/syslog | grep --line-buffered -Ei 'AXFR started' -m 2
  echo "!!!!!!!!!!  named xfer successfully detected !!!!!!!!!!!"
  echo "!!!!!!!!!! waiting for dhcp cluster recovery !!!!!!!!!!!"
  tail -f /var/log/syslog | grep --line-buffered -Ei 'Both servers have entered recover-done!' -m 1
  echo "!!!!!!!!!!  Cluster recovery successfully detected !!!!!!!!!!!!"
fi



