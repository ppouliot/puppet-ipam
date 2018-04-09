#!/usr/bin/env bash
echo "**** Verifying that the ISC-DHCP-SERVER Configuration ****"
/usr/sbin/dhcpd -t
echo "**** Verifying that the BIND Configuration ****"
/usr/sbin/named-checkconf
