#!/bin/bash


# update app.js to reflect testnet if app is for testnet
if [ -z ${ZCASH_NETWORK} ] || [ $ZCASH_NETWORK == "testnet" ]; then
  echo "updating environment to testnet"
else
  echo "doing nothing ...."
fi