#/usr/bin/env bash
echo "*** Checking A records ***"
dig @192.168.0.2 ipam1.contoso.ltd +short
dig @192.168.0.2 ipam2.contoso.ltd +short
echo "*** Checking PTR records ***"
dig @192.168.0.2 -x 192.168.0.2 +short
dig @192.168.0.2 -x 192.168.0.3 +short
