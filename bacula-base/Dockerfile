FROM debian:bullseye

ARG B_VERSION=13.0.2

ENV BACULA_KEY=654b09f35d0a4

ENV BACULA_VERSION=${B_VERSION}

ENV TZ="Asia/Ho_Chi_Minh"

RUN export DEBIAN_FRONTEND=noninteractive && apt update \
    && apt-get install -y --no-install-recommends \
        curl \
        gnupg \
        wget \
        ca-certificates

RUN wget -qO - https://www.bacula.org/downloads/Bacula-4096-Distribution-Verification-key.asc | apt-key add -

COPY Bacula-Community.list /etc/apt/sources.list.d/Bacula-Community.list

RUN sed -e s/BACULA_KEY/$BACULA_KEY/g -e s/BACULA_VERSION/$BACULA_VERSION/g -i /etc/apt/sources.list.d/Bacula-Community.list

RUN export DEBIAN_FRONTEND=noninteractive && apt update \
    && apt-get install -y \
        bacula-postgresql 

RUN apt-get clean autoclean && rm -rf /var/lib/cache

RUN ls /opt/bacula/bin | xargs -I{} ln -s /opt/bacula/bin/{} /usr/sbin/{}
