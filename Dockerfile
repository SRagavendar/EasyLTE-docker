FROM ubuntu:18.04
MAINTAINER SRagavendar
ENV DEBIAN_FRONTEND nointeractive
RUN apt-get update
RUN apt-get -yq dist-upgrade

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
        libmicrohttpd-dev \
        libcurl14-gnutls-dev \
        python3-pip \
        python3-setuptools \
        python3-wheel \
        ninja-build \
        build-essential \
        flex \
        bison \
        git \
        libsctp-dev \
        libgnutls28-dev \
        libgcrypt-dev \
        libssl-dev \
        libidn11-dev \
        libmongoc-dev \
        libbson-dev \
        libyaml-dev \
        iproute2 \
        ca-certificates \
        netbase \
        pkg-config && \
    apt-get clean
RUN python3 -m pip install meson
WORKDIR ~
RUN git clone https://github.com/open5gs/open5gs.git
WORKDIR ~/open5gs
RUN meson build && ninja -C build install
WORKDIR ~

RUN apt-get -y install curl gnupg
RUN curl - sL https://deb.nodesource/com/setup_10.x | bash -
RUN apt-get -y install nodejs

RUN cd ~/open5gs/webui && npm install && npm run build

ENV IN=India/Hyderabad
RUN ln -snf /usr/share/zoneinfo/$IN /etc/localtime && echo $IN > /etc/timezone
RUN apt-get --no-install-recommends -qy isntall tshark iptables net-tools
RUN apt-get --no-install-recommends -qy install mongodb-clients
WORKDIR ~