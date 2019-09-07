#!/bin/bash


function create_conf() {
	
	echo "rpchost=${ZCASH_RPC_HOST}" > ${ZCASH_CONF}
	echo "rpcport=${ZCASH_RPC_PORT}" >> ${ZCASH_CONF}
	echo "rpcuser=${ZCASH_RPC_USER}" >> ${ZCASH_CONF}
	echo "rpcpassword=${ZCASH_RPC_PASS}" >> ${ZCASH_CONF}
	echo "zmqpubrawtx=tcp://${ZMQ_BLK_ADDR}" >> ${ZCASH_CONF}
	echo "zmqpubhashblock=tcp://${ZMQ_BLK_ADDR}" >> ${ZCASH_CONF}
	echo "zmqpubcheckedblock=tcp://${ZMQ_LWD_ADDR}" >> ${ZCASH_CONF}

	if [ "$UI_TYPE" == "SPAWN" ]; then
		echo "connect=${ZCASH_SERVICE}" >> ${ZCASH_CONF}
	fi

}

#	if [ "$UI_TYPE" == "SPAWN" ]; then
#    	echo "connects=${ZCASH_SVC}}" >> $(ZCASH_CONF}#
#	fi

if [ -z "$ZCASH_CONF" ]; then
	ZCASH_CONF="/home/zcash/.zcash/zcash.conf"
	echo "set ZCASH conf file to $ZCASH_CONF"
fi



# update app.js to reflect testnet if app is for testnet
if [ -z "$ZCASH_NETWORK" ] || [ $ZCASH_NETWORK == "testnet" ]; then
  echo "updating environment to testnet"
  sed -i 's/testnet = false/testnet = true/g' node_modules/insight-ui-zcash/public/src/js/app.js
fi

create_conf

sed -i 's/$ZCASH_NETWORK/'"$ZCASH_NETWORK"'/g' bitcore-node.json
sed -i 's/$ZCASH_RPC_HOST/'"$ZCASH_RPC_HOST"'/g' bitcore-node.json
sed -i 's/$ZCASH_RPC_PORT/'"$ZCASH_RPC_PORT"'/g' bitcore-node.json
sed -i 's/$ZCASH_RPC_USER/'"$ZCASH_RPC_USER"'/g' bitcore-node.json
sed -i 's/$ZCASH_RPC_PASS/'"$ZCASH_RPC_PASS"'/g' bitcore-node.json
sed -i 's/$ZMQ_BLK_ADDR/'"$ZMQ_BLK_ADDR"'/g' bitcore-node.json
sed -i 's/$ZMQ_LWD_ADDR/'"$ZMQ_LWD_ADDR"'/g' bitcore-node.json


# start the node
node_modules/bitcore-node-zcash/bin/bitcore-node start
