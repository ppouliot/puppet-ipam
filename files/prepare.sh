#!/usr/bin/env bash
set -x
YUM=`which yum`
APT=`which apt-get`
if [ $YUM ]; then
  echo "Yum is detected installing required packages for the platform."
  $YUM install git wget curl
elif [ $APT ]; then
  echo "Apt is detected installing required packages for the platform."
  $APT install git wget curl -y
else 
  echo "No supported Package Management"
fi
