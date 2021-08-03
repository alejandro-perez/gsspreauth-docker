FROM ubuntu:18.04

# Build Kerberos
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

# Build Moonshot
RUN apt-get install -y wget git
RUN wget https://repository.project-moonshot.org/debian-moonshot/moonshot-repository.ubuntu18.deb
RUN dpkg -i moonshot-repository.ubuntu18.deb
RUN apt-get -y update
RUN apt-get -y install moonshot-ui-dev
WORKDIR /code
RUN git clone https://github.com/janetuk/mech_eap.git
WORKDIR /code/mech_eap
RUN apt-get -y install libssl1.0-dev libshibresolver-dev libsaml2-dev libshibsp-dev libradsec-dev libjansson-dev libxml2-dev libboost-dev
RUN set -x \
    && mkdir -p /usr/local/include/et/ \
    && ln -s /usr/local/include/com_err.h /usr/local/include/et/
RUN set -x \
    && autoreconf -fi \
    && ./configure \
    && make -j10
RUN make install
RUN mkdir -p /usr/local/etc/gss/
RUN cp mech_eap/mech /usr/local/etc/gss/
COPY radsec.conf /usr/local/etc/
RUN apt-get -y install moonshot-ui
CMD krb5kdc -n
