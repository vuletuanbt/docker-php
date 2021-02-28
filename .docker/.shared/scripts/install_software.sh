#!/bin/sh

COMPOSE_ENVIRONMENT=$1

# develop mode defaults
if [ -z "${COMPOSE_ENVIRONMENT}" ]; then
    echo "Running on production do not need to install develop software";
    exit;
fi

apk update -yqq && apk add -yqq \
    curl \
    dnsutils \
    gdb \
    git \
    htop \
    iproute2 \
    iputils-ping \
    ltrace \
    make \
    procps \
    strace \
    sudo \
    sysstat \
    unzip \
    vim \
    wget \
;
