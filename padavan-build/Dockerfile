FROM debian:jessie-slim

RUN apt-get -y update && \
    apt-get -y upgrade && \
    apt-get -y install  build-essential \
                        gawk \
                        pkg-config \
                        gettext \
                        automake \
                        autogen \
                        texinfo \
                        autoconf \
                        libtool \
                        bison \
                        flex \
                        zlib1g-dev \
                        libgmp3-dev \
                        libmpfr-dev \
                        libmpc-dev \
                        git \
                        sudo \
                        vim && \
    apt-get -y purge manpages \
                     xauth \
                     debconf-i18n && \
    apt-get -y autoremove && \
    apt-get -y autoclean && \
    apt-get clean all

WORKDIR /opt/rt-n56u/trunk