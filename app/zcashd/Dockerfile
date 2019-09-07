#FROM zcash:build AS builder

#Temporarily disabled for dev build
FROM debian:jessie AS builder

ENV ZCASH_CONF=/home/zcash/.zcash/zcash.conf

RUN echo "deb [check-valid-until=no] http://cdn-fastly.deb.debian.org/debian jessie main" > /etc/apt/sources.list.d/jessie.list
RUN echo "deb [check-valid-until=no] http://archive.debian.org/debian jessie-backports main" > /etc/apt/sources.list.d/jessie-backports.list
RUN sed -i '/deb http:\/\/deb.debian.org\/debian jessie-updates main/d' /etc/apt/sources.list
RUN apt-get -o Acquire::Check-Valid-Until=false update


RUN apt-get -qqy install --no-install-recommends build-essential \
    automake ncurses-dev libcurl4-openssl-dev libssl-dev libgtest-dev \
    make autoconf automake libtool git apt-utils pkg-config libc6-dev \
    libcurl3-dev libudev-dev m4 g++-multilib unzip git zlib1g-dev \
    wget ca-certificates pwgen bsdmainutils curl

#Temporarily disabled for dev build
#**********************************
WORKDIR /zcash

ADD ./zcash/ /zcash/

WORKDIR /zcash
RUN ./zcutil/build.sh -j$(nproc)
#**********************************

WORKDIR /zcash/src
RUN /usr/bin/install -c zcash-tx zcashd zcash-cli zcash-gtest ../zcutil/fetch-params.sh -t /usr/bin

FROM debian:jessie

ENV ZCASH_CONF=/home/zcash/.zcash/zcash.conf

RUN echo "deb [check-valid-until=no] http://cdn-fastly.deb.debian.org/debian jessie main" > /etc/apt/sources.list.d/jessie.list
RUN echo "deb [check-valid-until=no] http://archive.debian.org/debian jessie-backports main" > /etc/apt/sources.list.d/jessie-backports.list
RUN sed -i '/deb http:\/\/deb.debian.org\/debian jessie-updates main/d' /etc/apt/sources.list
RUN apt-get -o Acquire::Check-Valid-Until=false update

RUN apt-get install -y libgomp1 wget curl vim

RUN apt-get clean all -y

COPY --from=builder /usr/bin/zcash-cli /usr/bin/zcashd /usr/bin/fetch-params.sh /usr/bin/
COPY entrypoint.sh /usr/bin/
RUN chmod a+x /usr/bin/entrypoint.sh

RUN addgroup --gid 1000 --system zcash && adduser --uid 1000 --home /home/zcash --ingroup zcash --system zcash && \
	mkdir /home/zcash/.zcash && \
    chown -R zcash:zcash /home/zcash

USER zcash

WORKDIR /home/zcash

CMD [ "/usr/bin/entrypoint.sh" ]
