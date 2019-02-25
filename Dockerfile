#
# Dockerfile for shadowsocks-libev
#

FROM alpine

COPY config.json /

RUN set -ex \
 # Build environment setup
 && apk add --no-cache --virtual .build-deps \
      autoconf \
      automake \
      build-base \
      c-ares-dev \
      libev-dev \
      libtool \
      libsodium-dev \
      linux-headers \
      mbedtls-dev \
      git \
      pcre-dev \
 # Build & install
 && cd /tmp \
 && git clone https://github.com/shadowsocks/shadowsocks-libev.git \
 && cd shadowsocks-libev \
 && git submodule update --init --recursive \
 && ./autogen.sh \
 && ./configure --prefix=/usr --disable-documentation \
 && make install \
 && apk del .build-deps \
 # Runtime dependencies setup
 && apk add --no-cache \
      rng-tools \
      $(scanelf --needed --nobanner /usr/bin/ss-* \
      | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
      | sort -u) \
 && rm -rf /tmp/shadowsocks-libev

USER nobody

CMD exec ss-server \
      -c config.json \
      -p 8388 \
      -k ${PASSWORD}
