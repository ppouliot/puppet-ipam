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

echo "*** Scanning for available DHCP servers ***"
dhcping -v -r -s 192.168.0.255

echo "*** Attempting to get a dhcp lease for the All-Numeric Mac address via DHCPing from ipam1 ***"
dhcping -v -r -c 192.168.0.7 -h 00:07:43:14:15:30 -s 192.168.0.2
echo "*** Attempting to get a dhcp lease for the All-Numeric Mac address via DHCPing from ipam2 ***"
dhcping -v -r -c 192.168.0.7 -h 00:07:43:14:15:30 -s 192.168.0.3

./do-nsupdate.sh nsupdate-tester-1-fwd
./do-nsupdate.sh nsupdate-tester-1-rev
