FROM ubuntu:18.04

RUN apt-get -y update \
    && apt-get -y install build-essential automake autoconf libtool bison
ADD krb5 /code/krb5
WORKDIR /code/krb5/src
RUN set -x \
    && autoreconf -fi \
    && ./configure \
    && make -j10 \
    && make install
COPY krb5.conf /usr/local/etc/
CMD while true; do sleep 1h; done
