FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update &&\
    apt-get install -y --no-install-recommends \
            adduser sudo \
            build-essential libssl-dev zlib1g-dev \
            git make bison perl  \
            curl ca-certificates &&\
    apt-get -y clean &&\
    rm -rf /var/lib/apt/lists/*

RUN adduser --disabled-password --gecos '' user
RUN echo 'user ALL=(root) NOPASSWD:ALL' > /etc/sudoers.d/user

WORKDIR /home/user
USER user
