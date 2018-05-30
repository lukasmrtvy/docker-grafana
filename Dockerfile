
FROM alpine:latest

ENV GRAFANA_VERSION=4.4.3
ENV GLIBC_VERSION=2.25-r0

ENV UID 1000
ENV GID 1000
ENV USER htpc
ENV GROUP htpc

COPY grafana_custom.conf /tmp/

RUN addgroup -S ${GROUP} -g ${GID} && adduser -D -S -u ${UID} ${USER} ${GROUP}  \
    && apk add --no-cache curl tzdata \
    && curl -sL https://raw.githubusercontent.com/sgerrand/alpine-pkg-glibc/master/sgerrand.rsa.pub -o /etc/apk/keys/sgerrand.rsa.pub  \
    && curl -sL https://github.com/sgerrand/alpine-pkg-glibc/releases/download/$GLIBC_VERSION/glibc-$GLIBC_VERSION.apk -o /tmp/glibc.apk \
    && apk add /tmp/glibc.apk \
    && mkdir -p /opt/grafana/data && curl -sL https://s3-us-west-2.amazonaws.com/grafana-releases/release/grafana-$GRAFANA_VERSION.linux-x64.tar.gz | tar xz -C /opt/grafana --strip-components=1 \
    && cp /tmp/grafana_custom.conf /opt/grafana/data/ \
    && chown -R ${USER}:${GROUP} /opt/grafana/ \
    && apk del curl  && rm -rf /tmp/*

EXPOSE 3000

LABEL version=${GRAFANA_VERSION}
LABEL url=https://github.com/grafana/grafana/

USER ${USER}

VOLUME ["/opt/grafana/data/"]

ENTRYPOINT /opt/grafana/bin/grafana-server -homepath /opt/grafana/ -config /opt/grafana/data/grafana_custom.conf

