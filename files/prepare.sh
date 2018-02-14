#!/usr/bin/env bash
set -x
if [ -d /usr/bin/yum ];
then
  yum install git
fi
