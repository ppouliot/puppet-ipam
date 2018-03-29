#!/usr/bin/env bash
dnssec-keygen -r /dev/urandom -a HMAC-MD5 -b 512 -n HOST omapi_key
cat Komapi_k.+*.private |grep ^Key| cut -d ' ' -f2-
