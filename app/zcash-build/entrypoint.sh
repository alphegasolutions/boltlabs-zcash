#!/bin/bash

function create_conf_file() {

    echo "server=1" > ${ZCASH_CONF}
    echo "whitelist=0.0.0.0" >> ${ZCASH_CONF}
    echo "rpcallowip=0.0.0.0/0" >> ${ZCASH_CONF}
	echo "rpcbind=0.0.0.0" >> ${ZCASH_CONF}
	echo "rpcport=18232" >> ${ZCASH_CONF}
    echo "rpcuser=${ZCASH_RPC_USER}" >> ${ZCASH_CONF}
    echo "rpcpassword=${ZCASH_RPC_PASS}" >> ${ZCASH_CONF}


	if [ $ZCASH_NETWORK == "testnet" ]
	then
    	echo "testnet=1" >> ${ZCASH_CONF}
    	if [ $ZCASH_NODE_TYPE == "NODE" ]
    	then
    		echo "addnode=testnet.z.cash" >> ${ZCASH_CONF}
		else [ $ZCASH_NODE_TYPE == "PEER" ]; then
  			echo "connect=${ZCASH_NODE_SERVICE}" >> ${ZCASH_CONF}
    	fi
	else
    	echo "testnet=0" >> ${ZCASH_CONF}
    	if [ $ZCASH_NODE_TYPE == "NODE" ]
    	then
    		echo "addnode=mainnet.z.cash" >> ${ZCASH_CONF}
		else [ $ZCASH_NODE_TYPE == "PEER" ]; then
  			echo "connect=${ZCASH_NODE_SERVICE}" >> ${ZCASH_CONF}
    	fi
	fi
	

    echo "zmqpubrawtx=tcp://0.0.0.0:9994" >> ${ZCASH_CONF}
    echo "zmqpubhashblock=tcp://0.0.0.0:9994" >> ${ZCASH_CONF}
    echo "zmqpubcheckedblock=tcp://0.0.0.0:28332" >> ${ZCASH_CONF}
    echo "reindex=1" >> ${ZCASH_CONF}
    echo "showmetrics=0" >> ${ZCASH_CONF}
    echo "txindex=1" >> ${ZCASH_CONF}
    echo "addressindex=1" >> ${ZCASH_CONF}
    echo "timestampindex=1" >> ${ZCASH_CONF}
    echo "spentindex=1" >> ${ZCASH_CONF}

}


if [ -z $ZCASH_HOME ]
then
  echo "setting ZCASH_HOME to /home/zcash"
  ZCASH_HOME=/home/zcash
fi

ZCASH_PARAMS=$ZCASH_HOME/.zcash-params

echo "checking for config file: $ZCASH_CONF"
if [ ! -f "$ZCASH_CONF" ]
then
	echo "creating zcash configuration file at $ZCASH_CONF"
	create_conf_file
fi

echo "verifying zcash parameters"
if [ ! -d "$ZCASH_PARAMS" ]
then
  mkdir -p $ZCASH_PARAMS
  echo "Fetching zcash parameter files"
  fetch-params.sh
elif [ -z "$(ls -A $ZCASH_PARAMS)" ]
then
  echo "$ZCASH_PARAMS is empty Fetching params"
  fetch-params.sh
fi

echo "starting zcash node"
/usr/bin/zcashd --conf=$ZCASH_CONF --printtoconsole
