#!/usr/bin/env bash

./watch_for_cluster_recovery.sh &
./watch_for_dyndns.sh &
./watch_for_key_access.sh &
./watch_for_named_xfer_1_2.sh &
./watch_for_omapi_signer.sh &
./watch_for_omapi_protocol_failure.sh &
./watch_for_tsig.sh &
