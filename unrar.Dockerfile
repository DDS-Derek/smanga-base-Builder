# syntax=docker/dockerfile:1.4

ARG ALPINE_VERSION

FROM alpine:${ALPINE_VERSION} AS Builder

ARG UNRAR_VERSION=6.2.10

RUN set -ex && \
    apk add --no-cache \
        curl \
        tar \
        build-base \
        gcc \
        g++ \
        make \
        musl-dev && \
  mkdir /tmp/unrar && \
  curl -o \
    /tmp/unrar.tar.gz -L \
    "https://www.rarlab.com/rar/unrarsrc-${UNRAR_VERSION}.tar.gz" && \
  tar xf \
    /tmp/unrar.tar.gz -C \
    /tmp/unrar --strip-components=1 && \
  cd /tmp/unrar && \
  sed -i 's|LDFLAGS=-pthread|LDFLAGS=-pthread -static|' makefile && \
  make && \
  install -v -m755 unrar /usr/bin

FROM scratch

COPY --from=Builder /usr/bin/unrar /usr/bin/unrar