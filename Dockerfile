FROM alpine:latest

ENV GRAFANA_VERSION=4.4.3
ENV GLIBC_VERSION=2.25-r0

RUN apk add --no-cache openssl \
    && wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://raw.githubusercontent.com/sgerrand/alpine-pkg-glibc/master/sgerrand.rsa.pub \
    && wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/$GLIBC_VERSION/glibc-$GLIBC_VERSION.apk \
    && apk add glibc-$GLIBC_VERSION.apk \
    && wget https://grafanarel.s3.amazonaws.com/builds/grafana-$GRAFANA_VERSION.linux-x64.tar.gz \
    && tar -xzf grafana-$GRAFANA_VERSION.linux-x64.tar.gz \
    && mv grafana-$GRAFANA_VERSION/ grafana/ \
    && sed -i 's,data = data,data = data/db,g' grafana/conf/defaults.ini \
    && rm grafana-$GRAFANA_VERSION.linux-x64.tar.gz /etc/apk/keys/sgerrand.rsa.pub glibc-$GLIBC_VERSION.apk\
    && apk del openssl

VOLUME ["/grafana/conf", "/grafana/data/db", "/grafana/data/log", "/grafana/data/plugins"]

EXPOSE 3000

WORKDIR /grafana
CMD ["./bin/grafana-server"]
