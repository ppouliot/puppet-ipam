#!/usr/bin/env bash
set -x
YUM=`which yum`
APT=`which apt-get`
if [ $YUM ]; then
  echo "Yum is detected installing required packages for the platform."
  $YUM install git wget curl -y
elif [ $APT ]; then
  echo "Apt is detected installing required packages for the platform."
  $APT install git wget curl -y
else 
  echo "No supported Package Management"
fi

cat <<EOF >> /etc/hosts 
192.168.0.2 ipam1.contoso.ltd ipam1
192.168.0.3 ipam2.contoso.ltd ipam2

EOF
