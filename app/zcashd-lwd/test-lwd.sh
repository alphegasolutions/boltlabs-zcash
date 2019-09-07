

# test ingester
docker run -e LWD_TYPE=ingester -e ZMQ_LWD_ADDR=0.0.0.0:28332 -e LWD_DB=/home/zcash/db/testnet-lite.sqlite --name lwd-ing alphegasolutions/zcash-lwd:v0.1


# test rest
docker run -e LWD_TYPE=rest -e ZMQ_LWD_ADDR=0.0.0.0:28332 -e LWD_DB=/home/zcash/db/testnet-lite.sqlite -e LWD_PORT=3067 --name lwd-rest alphegasolutions/zcash-lwd:v0.1
