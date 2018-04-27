#!/usr/bin/env bash
./do-nsupdate.sh ./nsupdate-tester-1-fwd
sleep 3
./do-nsupdate.sh ./nsupdate-tester-1-rev
