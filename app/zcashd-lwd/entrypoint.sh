#!/bin/bash


function create_conf() {
	
	echo "rpchost=${ZCASH_RPC_HOST}" > ${ZCASH_CONF}
	echo "rpcconnect=${ZCASH_RPC_HOST}" >> ${ZCASH_CONF}
	echo "rpcport=${ZCASH_RPC_PORT}" >> ${ZCASH_CONF}
	echo "rpcuser=${ZCASH_RPC_USER}" >> ${ZCASH_CONF}
	echo "rpcpassword=${ZCASH_RPC_PASS}" >> ${ZCASH_CONF}
	echo "zmqpubrawtx=tcp://${ZMQ_BLK_ADDR}" >> ${ZCASH_CONF}
	echo "zmqpubhashblock=tcp://${ZMQ_BLK_ADDR}" >> ${ZCASH_CONF}
	echo "zmqpubcheckedblock=tcp://${ZMQ_LWD_ADDR}" >> ${ZCASH_CONF}

}


# update the zmq block address
#sed -i 's/$ZMQ_BLK_ADDR/'"$ZMQ_BLK_ADDR"'/g' /home/zcash/.zcash/zcash.conf

# update the zmq lwd address
#sed -i 's/$ZMQ_LWD_ADDR/'"$ZMQ_LWD_ADDR"'/g' /home/zcash/.zcash/zcash.conf

# update the zcash rpc host
#sed -i 's/$ZCASH_RPC_HOST/'"$ZCASH_RPC_HOST"'/g' /home/zcash/.zcash/zcash.conf

# update the zcash rpc port
#sed -i 's/$ZCASH_RPC_PORT/'"$ZCASH_RPC_PORT"'/g' /home/zcash/.zcash/zcash.conf

# update username and password
#sed -i 's/$ZCASH_RPC_USER/'"$ZCASH_RPC_USER"'/g' /home/zcash/.zcash/zcash.conf
#sed -i 's/$ZCASH_RPC_PASS/'"$ZCASH_RPC_PASS"'/g' /home/zcash/.zcash/zcash.conf

# create directory if not exists
[ -d /home/zcash/db ] || mkdir -p /home/zcash/db
#[ -d /home/zcash/log ] || mkdir -p /home/zcash/log
#[ -d /home/zcash/.zcash ] || mkdir -p /home/zcash/.zcash

if [ -z "$ZCASH_CONF" ]; then
	ZCASH_CONF="/home/zcash/.zcash/zcash.conf"
	echo "set ZCASH conf file to $ZCASH_CONF"
fi
	
create_conf

# start the lwd ZMQ ingester
if [ "$LWD_TYPE" == "ingester" ]; then
	echo "starting LWD ingester process"

	#go run cmd/ingest/main.go --db-path $LWD_DB --zmq-addr $ZMQ_LWD_ADDR >& /home/zcash/log/zmq_client.stdout.log &
	go run cmd/ingest/main.go --db-path $LWD_DB --zmq-addr $ZMQ_LWD_ADDR
else

	echo "starting LWD front-end process"
	
	# start the lwd front-end
	#go run cmd/server/main.go --db-path $LWD_DB --bind-addr 0.0.0.0:9067 --conf-file $ZCASH_CONF
	go run cmd/server/main.go --db-path $LWD_DB --bind-addr 0.0.0.0:$LWD_PORT --conf-file $ZCASH_CONF
fi
