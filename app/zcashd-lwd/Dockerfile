ARG REPOSITORY_URI=boltlabs
ARG ZCASH_VERSION=latest
FROM $REPOSITORY_URI/zcashd:$ZCASH_VERSION AS builder

FROM golang:1.11

ENV GOPATH=/home/zcash/go
ENV TMPDIR=/home/zcash/go/tmp

RUN apt-get update

RUN apt-get install -y sudo libgomp1 wget curl libzmq3-dev git less nano vim

RUN apt-get clean all -y

COPY --from=builder /usr/bin/zcash-cli /usr/bin/

# install grpcurl and add zcash user
#RUN go get github.com/fullstorydev/grpcurl && \
#    go install github.com/fullstorydev/grpcurl/cmd/grpcurl

RUN addgroup --gid 1000 --system zcash && adduser --uid 1000 --home /home/zcash --ingroup zcash --system zcash && \
	mkdir -p /home/zcash/.zcash && \
	mkdir -p /home/zcash/go/tmp
	
#    chown -R zcash:zcash /go

WORKDIR /home/zcash/

#RUN mkdir -p /home/zcash/.zcash/

ADD ./lightwalletd ./lightwalletd

# copy zcash.conf and entrypoint.sh
COPY entrypoint.sh /home/zcash/entrypoint.sh
#COPY zcash.conf /home/zcash/.zcash/zcash.conf

RUN chmod u+x /home/zcash/entrypoint.sh && \
	chown -R zcash:zcash /home/zcash

WORKDIR /home/zcash/lightwalletd

USER zcash

# download resources
RUN go run cmd/ingest/main.go || echo $?

ENTRYPOINT ["/home/zcash/entrypoint.sh"]
