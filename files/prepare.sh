#!/usr/bin/env bash
set -x
if [ -d /usr/bin/yum ]; then
  echo "Yum is detected installing required packages for the platform."
  yum install git wget curl
elif [ -d /usr/bin/apt ]; then
  echo "Apt is detected installing required packages for the platform."
  apt-get install git wget curl -y
else 
  echo "No supported Package Management"
fi
