#ARG DOCKER_REPO=alphegasolutions
#ARG ZCASH_VERSION=v2.0.6
#FROM $DOCKER_REPO/zcashd:$ZCASH_VERSION AS builder

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


#COPY --from=builder /usr/bin/zcashd /usr/bin/zcash-cli /usr/bin/fetch-params.sh /usr/bin/



RUN addgroup --gid 1000 --system zcash && adduser --uid 1000 --home /home/zcash --ingroup zcash --system zcash &&\
    mkdir -p /home/zcash/.npm-global &&\
    mkdir -p /home/zcash/.zcash && \
    mkdir -p /home/zcash/.zcash-params && \
    chown -R zcash:zcash /home/zcash

ENV PATH=$PATH:/home/zcash/.npm-global/bin
ENV NPM_CONFIG_PREFIX=/home/zcash/.npm-global

USER zcash

WORKDIR /home/zcash

RUN git clone https://github.com/zcash-hackworks/zcash-patched-for-explorer.git
WORKDIR /home/zcash/zcash-patched-for-explorer
RUN git checkout v2.0.4-insight-explorer

RUN zcutil/build.sh -j$(nproc)


WORKDIR /home/zcash

RUN npm install -g npm@latest && \
	npm -g install zcash-hackworks/bitcore-node-zcash && \
	bitcore-node create zc

#WORKDIR /home/zcash/

#RUN bitcore-node create zc

WORKDIR /home/zcash/zc

RUN bitcore-node install zcash-hackworks/insight-api-zcash zcash-hackworks/insight-ui-zcash

COPY --chown=zcash:zcash ./bitcore-node.json ./entrypoint.sh /home/zcash/zc/
RUN chmod u+x entrypoint.sh

ENTRYPOINT ["./entrypoint.sh"]
