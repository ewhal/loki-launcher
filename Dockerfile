FROM debian:buster


ENV USE_SINGLE_BUILDDIR=1
WORKDIR /usr/src/app
RUN apt update && \
    apt install -y  \
    build-essential \ 
    cmake \
    git \
    libcap-dev \
    curl \
    ninja-build \
    libssl-dev \
    libboost-dev \
    expat \
    unbound \
    libsodium-dev  \
    libpgm-dev \
    libzmq3-dev \
    pkg-config \
    libboost-all-dev \ 
    libunbound-dev \ 
    libunwind8-dev \ 
    liblzma-dev \ 
    libreadline6-dev \
    libldns-dev \ 
    libexpat1-dev \ 
    libgtest-dev \ 
    ca-certificates \
    g++ \
    make \
    pkg-config \
    graphviz \
    doxygen \
    git \
    libtool-bin \
    autoconf \
    automake \
    bzip2 \
    xsltproc \
    gperf \
    unzip

RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get install -y nodejs
RUN  curl -L https://github.com/zeromq/cppzmq/archive/v4.3.0.tar.gz > v4.3.0.tar.gz
RUN  tar zxf v4.3.0.tar.gz
RUN  cd cppzmq-4.3.0 &&  cmake . &&  make -j$physicalCpuCount &&  make install

# Bundle app source
RUN ls -la /usr/include/boost/
COPY . .  
RUN bash init.sh 

RUN cd src/loki-storage-server && make release-httpserver && cd /usr/src/app 


RUN cd src/loki/ && make release-static && cd /usr/src/app
RUN cd src/loki-network && make NINJA=ninja JSONRPC=ON && make install NINJA=ninja && cd /usr/src/app


CMD ["node", "index.js"]
EXPOSE 38157 28083 1090

