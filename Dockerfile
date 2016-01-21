FROM alpine:3.2

RUN apk add --update make git go && \
    export GOPATH=/go && \
    export DISTRIBUTION_DIR=/go/src/github.com/docker/distribution && \
    export GOPATH=$DISTRIBUTION_DIR/Godeps/_workspace:$GOPATH && \
    mkdir -p /go/src/github.com/docker && \
    cd /go/src/github.com/docker && \
    git clone https://github.com/docker/distribution && \
    cd $DISTRIBUTION_DIR && \
    git checkout v2.2.1 && \
    make PREFIX=/go clean binaries && \
    mv /go/bin/registry /bin/registry && \
    mkdir -p /etc/docker/registry/ && \
    cp cmd/registry/config-dev.yml /etc/docker/registry/config.yml && \
    apk del --purge make git go && \
    apk add ca-certificates apache2-utils && \
    rm -rf /var/cache/apk/* /tmp/* /var/tmp/* $GOPATH

ADD default_config.yml /etc/docker/registry/config.yml

ENTRYPOINT ["/bin/registry"]
CMD ["/etc/docker/registry/config.yml"]
