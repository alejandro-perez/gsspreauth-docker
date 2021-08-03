FROM ubuntu:18.04

RUN apt-get -y update \
    && apt-get -y install wget
RUN wget https://repository.project-moonshot.org/debian-moonshot/moonshot-repository.ubuntu18.deb
RUN dpkg -i moonshot-repository.ubuntu18.deb
RUN apt-get -y update
RUN apt-get -y install freeradius-abfab
RUN chown freerad /etc/freeradius -R
RUN echo 'alex@test.org   Cleartext-Password := "alex"' >> /etc/freeradius/users
COPY fr-client.conf /
RUN cat /fr-client.conf >> /etc/freeradius/clients.conf
CMD freeradius -fxx -lstdout
