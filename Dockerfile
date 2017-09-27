FROM alpine:latest

ENV GRAFANA_VERSION=4.4.3
ENV GLIBC_VERSION=2.25-r0

ENV UID 1000
ENV USER htpc
ENV GROUP htpc

RUN addgroup -S ${GROUP} && adduser -D -S -u ${UID} ${USER} ${GROUP} && \
    apk add --no-cache curl \
    && curl -sL https://raw.githubusercontent.com/sgerrand/alpine-pkg-glibc/master/sgerrand.rsa.pub -o /etc/apk/keys/sgerrand.rsa.pub  \
    && curl -sL https://github.com/sgerrand/alpine-pkg-glibc/releases/download/$GLIBC_VERSION/glibc-$GLIBC_VERSION.apk -o /tmp/glibc.apk \
    && apk add /tmp/glibc.apk \
    && mkdir -p /opt/grafana && curl -sL https://s3-us-west-2.amazonaws.com/grafana-releases/release/grafana-$GRAFANA_VERSION.linux-x64.tar.gz | tar xz -C /opt/grafana --strip-components=1 \
    && chown -R ${USER}:${GROUP} /opt/grafana/ \
    && apk del curl  && rm -rf /tmp/*

EXPOSE 3000

WORKDIR /opt/grafana

VOLUME ["/opt/grafana/conf", "/opt/grafana/data/db", "/opt/grafana/data/log", "/opt/grafana/data/plugins"]

LABEL version=${GRAFANA_VERSION}
LABEL name=grafana
LABEL url=https://api.github.com/repos/grafana/grafana/releases/latest

USER ${USER}

CMD ./bin/grafana-server


