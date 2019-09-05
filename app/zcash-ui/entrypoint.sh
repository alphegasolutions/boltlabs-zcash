#!/bin/bash


function create_conf() {
	
	echo "rpchost=${ZCASH_SERVICE}" > ${ZCASH_CONF}
	echo "rpcport=${ZCASH_RPC_PORT}" >> ${ZCASH_CONF}
	echo "rpcuser=${ZCASH_RPC_USER}" >> ${ZCASH_CONF}
	echo "rpcpassword=${ZCASH_RPC_PASS}" >> ${ZCASH_CONF}
	echo "zmqpubrawtx=tcp://${ZCASH_SERVICE}:${ZMQ_BLK_PORT}" >> ${ZCASH_CONF}
	echo "zmqpubhashblock=tcp://${ZCASH_SERVICE}:${ZMQ_BLK_PORT}" >> ${ZCASH_CONF}
	echo "zmqpubcheckedblock=tcp://${ZCASH_SERVICE}:${ZMQ_LWD_PORT}" >> ${ZCASH_CONF}
	echo "connect=${ZCASH_SERVICE}" >> ${ZCASH_CONF}

	if [ $ZCASH_NETWORK == "testnet" ]
	then
    	echo "testnet=1" >> ${ZCASH_CONF}
	else
    	echo "testnet=0" >> ${ZCASH_CONF}
	fi

	echo "txindex=1" >> ${ZCASH_CONF}
	echo "addressindex=1" >> ${ZCASH_CONF}
	echo "spentindex=1" >> ${ZCASH_CONF}
    echo "timestampindex=1" >> ${ZCASH_CONF}
    echo "server=1" >> ${ZCASH_CONF}
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

#cat bitcore-node.json
#cat /home/zcash/.zcash/zcash.conf
#cat /home/zcash/zc/entrypoint.sh

sed -i 's/$ZCASH_NETWORK/'"$ZCASH_NETWORK"'/g' bitcore-node.json

# start the node
echo "starting bitcore-node"
node_modules/bitcore-node-zcash/bin/bitcore-node start
