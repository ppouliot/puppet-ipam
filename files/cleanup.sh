#!/usr/bin/env bash
rm -rf files/hiera/groups/common.yaml
rm -rf files/hiera/groups/omapi_key.tgz
rm -rf ubuntu-*.log
vagrant destroy -f
