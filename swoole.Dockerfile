# syntax=docker/dockerfile:1.8

ARG ALPINE_VERSION

FROM alpine:${ALPINE_VERSION} AS Builder

ARG PHP7_SWOOLE_VERSION=4.6.7

RUN set -ex && \
    apk add --no-cache \
        php7 \
        php7-dev \
        php7-openssl \
        php7-pear \
        build-base \
        gcc \
        g++ \
        make \
        musl-dev && \
    pecl channel-update pecl.php.net && \
    echo yes | pecl install swoole-${PHP7_SWOOLE_VERSION} && \
    mkdir -p \
        /rootfs/usr/lib/php7/modules \
        /rootfs/usr/include/php7/ext/swoole \
        /rootfs/etc/php7/conf.d && \
    cp /usr/lib/php7/modules/swoole.so /rootfs/usr/lib/php7/modules/swoole.so && \
    cp /usr/include/php7/ext/swoole/config.h /rootfs/usr/include/php7/ext/swoole/config.h && \
    echo "extension=swoole.so" > /rootfs/etc/php7/conf.d/00_swoole.ini

FROM scratch

COPY --from=Builder /rootfs /