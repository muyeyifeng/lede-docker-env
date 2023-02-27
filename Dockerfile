#Version 0.0.2
FROM ubuntu:20.04
MAINTAINER muyeyifeng@gmail.com
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get upgrade -y && apt-get install -y git sudo tzdata
RUN adduser ubuntu
RUN echo 'ubuntu    ALL=(ALL:ALL) NOPASSWD:ALL' >>/etc/sudoers
USER ubuntu
WORKDIR /home/ubuntu
RUN git clone https://github.com/coolsnowwolf/lede && git clone https://github.com/muyeyifeng/Actions-Build-Lede-Public
RUN $(cat ~/lede/README.md |grep "sudo apt-get" | sed -n 2p)
RUN cp ~/Actions-Build-Lede-Public/feeds.conf.default ~/lede/feeds.conf.default && rm -rf Actions-Build-Lede-Public
WORKDIR /home/ubuntu/lede/scripts/config/
RUN make
WORKDIR /home/ubuntu/lede
RUN ./scripts/feeds update -a && ./scripts/feeds install -a
RUN make defconfig
RUN make download -j8
