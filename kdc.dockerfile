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
COPY krb5.conf kdc.conf /usr/local/etc/
RUN printf "test\ntest\n" | kdb5_util create -r ATHENA.MIT.EDU -s
RUN kadmin.local -q "addprinc -pw test alex"
CMD krb5kdc -n
