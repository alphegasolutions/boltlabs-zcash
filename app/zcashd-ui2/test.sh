#!/bin/bash

docker run \
	-e ZCASH_NETWORK=testnet \
	-e ZCASH_SERVICE=0.0.0.0 \
	-e ZCASH_RPC_PORT=18232 \
	-e ZCASH_RPC_USER=zcash \
	-e ZCASH_RPC_PASS=password \
	-e ZMQ_BLK_PORT=9994 \
	-e ZMQ_LWD_PORT=28332 \
	--name zcash-ui alphegasolutions/zcash-ui:v0.1
