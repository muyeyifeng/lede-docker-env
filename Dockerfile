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
RUN sudo -E apt -y install ack antlr3 aria2 asciidoc autoconf automake autopoint binutils bison build-essential bzip2 ccache cmake cpio curl device-tree-compiler fastjar flex gawk gettext gcc-multilib g++-multilib git gperf haveged help2man intltool libc6-dev-i386 libelf-dev libglib2.0-dev libgmp3-dev libltdl-dev libmpc-dev libmpfr-dev libncurses5-dev libncursesw5-dev libreadline-dev libssl-dev libtool lrzsz mkisofs msmtp nano ninja-build p7zip p7zip-full patch pkgconf python3 python3-pip libpython3-dev qemu-utils rsync scons squashfs-tools subversion swig texinfo uglifyjs upx-ucl unzip vim wget xmlto xxd zlib1g-dev
RUN cp ~/Actions-Build-Lede-Public/feeds.conf.default ~/lede/feeds.conf.default && rm -rf Actions-Build-Lede-Public
WORKDIR /home/ubuntu/lede/scripts/config/
RUN make
WORKDIR /home/ubuntu/lede
RUN ./scripts/feeds update -a && ./scripts/feeds install -a
RUN make defconfig
RUN make download -j8
