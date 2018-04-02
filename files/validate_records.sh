#!/usr/bin/env bash
echo "*** Checking Zone record ***"
dig @192.168.0.2 contoso.ltd  +short

echo "*** Checking Athorative DNS records ***"
dig @192.168.0.2 +short NS contoso.ltd
# dig @192.168.0.2 +nssearch contoso.ltd
dig @192.168.0.2 +short contoso.ltd | cut -d' ' -f1

echo "*** Checking A records ***"
dig @192.168.0.2 ipam1.contoso.ltd +short
dig @192.168.0.2 ipam2.contoso.ltd +short
echo "*** Checking PTR records ***"
dig @192.168.0.2 -x 192.168.0.2 +short
dig @192.168.0.2 -x 192.168.0.3 +short

echo "*** Checking Roundrobin records ***"
for ((i=1;i<=3;i++)); do
  echo $i
  dig @192.168.0.2 roundrobin.contoso.ltd  +short
done