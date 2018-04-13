#!/usr/bin/env bash
set -x
YUM=`which yum`
APT=`which apt-get`
if [ $YUM ]; then
  echo "**** Yum is detected installing required packages for the platform. ****"
  $YUM install git wget curl -y
  echo "**** Policy Kit needs to be disabled for DyNDNS to work properly. ****"
  systemctl disable polkit.service
  echo "**** Stopping policy kit from running. ****"
  systemctl stop polkit.service
elif [ $APT ]; then
  echo "**** Apt is detected installing required packages for the platform. ****"
  $APT install git wget curl -y
else 
  echo "**** No supported Package Management ****"
fi
echo "**** Populating /etc/hosts with Reousrce names ****"
cat <<EOF >> /etc/hosts 
192.168.0.2 ipam1.contoso.ltd ipam1
192.168.0.3 ipam2.contoso.ltd ipam2
EOF
