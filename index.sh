#!/bin/sh
# ?
while getopts e:o:f:h flag
do
    case "${flag}" in
        e) environment=${OPTARG};;
        o) os=${OPTARG};;
        f) fl=${OPTARG};;
        h) help=${OPTARG};;
    esac
done

echo "Environment: $environment";
echo "OS: $os";
echo "Flag: $fl";
echo "Help: $help";
#
#
#COMPOSE_ENVIRONMENT=$1
#
#echo "Environment: ${COMPOSE_ENVIRONMENT}"
#
#echo "Environment: ${COMPOSE_ENVIRONMENT}"
#
#if [ -z "${COMPOSE_ENVIRONMENT}" ]; then
#    echo "Running on production do not need to install develop software";
#    exit;
#fi

#
#if [ $string1 == $string2 ]; then
#    echo "Running on production do not need to install develop software";
#    exit;
#fi


#if [ ${COMPOSPE_ENVIRONMENT} == "production" ]; then
#    echo "Running on production do not need to install develop software";
#    exit;
#fi
#
#apk update -yqq && apk add -yqq \
#    curl \
#    dnsutils \
#    gdb \
#    git \
#    htop \
#    iproute2 \
#    iputils-ping \
#    ltrace \
#    make \
#    procps \
#    strace \
#    sudo \
#    sysstat \
#    unzip \
#    vim \
#    wget \
#;
