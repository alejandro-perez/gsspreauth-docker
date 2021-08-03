FROM ubuntu:18.04

# Build Kerberos
RUN apt-get -y update \
    && apt-get -y install build-essential automake autoconf libtool bison git
WORKDIR /code
RUN set -x \
    && git clone https://github.com/alejandro-perez/krb5.git -b gsspreauth \
    && cd krb5/src \
    && autoreconf -fi \
    && ./configure \
    && make -j10 \
    && make install
COPY krb5.conf /usr/local/etc/
COPY kdc.conf /usr/local/var/krb5kdc/
RUN set -x \
    && printf "test\ntest\n" | kdb5_util create -r ATHENA.MIT.EDU -s \
    && kadmin.local -q "addprinc -pw randomsecretstring WELLKNOWN/FEDERATED" \
    && kadmin.local -q "addprinc -pw test alex"

# Build Moonshot
RUN set -x \
    && apt-get install -y wget \
    && wget https://repository.project-moonshot.org/debian-moonshot/moonshot-repository.ubuntu18.deb \
    && dpkg -i moonshot-repository.ubuntu18.deb \
    && apt-get -y update \
    && apt-get -y install moonshot-ui-dev moonshot-ui
WORKDIR /code
RUN set -x \
    && apt-get install -y libssl1.0-dev libshibresolver-dev libsaml2-dev libshibsp-dev libradsec-dev libjansson-dev libxml2-dev libboost-dev \
    && mkdir -p /usr/local/include/et/ \
    && ln -s /usr/local/include/com_err.h /usr/local/include/et/ \
    && git clone https://github.com/janetuk/mech_eap.git \
    && cd mech_eap \
    && autoreconf -fi \
    && ./configure \
    && make -j10 \
    && make install \
    && mkdir -p /usr/local/etc/gss/ \
    && cp mech_eap/mech /usr/local/etc/gss/
COPY radsec.conf /usr/local/etc/
CMD krb5kdc -n

