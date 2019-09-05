ARG DOCKER_REPO=alphegasolutions
ARG ZCASH_VERSION=v2.0.6
FROM $DOCKER_REPO/zcashd:$ZCASH_VERSION AS builder

FROM debian:jessie

RUN apt-get update \
    && apt-get install -y gnupg2 wget libzmq3-dev git \
    && apt-get -qqy install \
        build-essential pkg-config libc6-dev m4 g++-multilib \
        autoconf libtool ncurses-dev unzip git python python-zmq \
        zlib1g-dev wget curl bsdmainutils automake vim \
    \
    && curl -sL https://deb.nodesource.com/setup_8.x | bash - \
    && apt-get install -y nodejs


COPY --from=builder /usr/bin/zcash-cli /usr/bin/

RUN addgroup --gid 1000 --system zcash && adduser --uid 1000 --home /home/zcash --ingroup zcash --system zcash &&\
    mkdir -p /home/zcash/.npm-global &&\
    mkdir -p /home/zcash/.zcash &&\
    chown -R zcash:zcash /home/zcash

ENV PATH=$PATH:/home/zcash/.npm-global/bin
ENV NPM_CONFIG_PREFIX=/home/zcash/.npm-global

USER zcash
RUN npm install -g npm@latest &&\
	npm -g install zcash-hackworks/bitcore-node-zcash

WORKDIR /home/zcash/

RUN bitcore-node create zc
COPY --chown=zcash:zcash ./bitcore-node.json ./entrypoint.sh /home/zcash/zc/

WORKDIR /home/zcash/zc
RUN chmod u+x entrypoint.sh

RUN bitcore-node install zcash-hackworks/insight-api-zcash zcash-hackworks/insight-ui-zcash
ENTRYPOINT ["./entrypoint.sh"]
