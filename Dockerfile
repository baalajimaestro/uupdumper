#
# Copyright © 2020 Maestro Creativescape
#
# SPDX-License-Identifier: GPL-3.0
#
# Docker Image Builder for building the latest windows ISO

FROM debian:bullseye-slim

RUN apt update > /dev/null

RUN apt install git \
                python3 \
                moreutils \
                apt-utils \
                openssh-client \
                openssh-server \
                gawk \
                curl \
                wget \
                python3-pip \
                aria2 \
                zip \
                unzip \
                cabextract \
                wimtools \
                chntpw \
                genisoimage \
                grep \
                bash \
                openssl \
                ca-certificates -y > /dev/null

RUN curl https://rclone.org/install.sh | bash -s beta

RUN pip3 install requests bs4 urllib3 > /dev/null

RUN git config --global user.name baalajimaestro
RUN git config --global user.email baalajimaestro@pixelexperience.org

RUN mkdir /app
WORKDIR /app
COPY . /app

CMD bash runner.sh | ts '[%Y-%m-%d %H:%M:%S]'