#!/bin/bash

docker run -it \
	-e ZCASH_CONF=/home/zcash/.zcash/zcash.conf \
	-e ZCASH_RPC_USER=zcash \
	-e ZCASH_RPC_PASS=password \
	-e ZCASH_RPC_PORT=18232 \
	-e ZCASH_ZMQ1_PORT=9994 \
	-e ZCASH_ZMQ2_PORT=28332 \
	-e ZCASH_SERVICE=0.0.0.0 \
	-e ZCASH_NODE_TYPE=peer \
	--name zcashd-peer \
	alphegasolutions/zcashd:v2.0.6
	