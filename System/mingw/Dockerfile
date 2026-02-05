FROM ubuntu:24.04

# Setting TZ and Japanese Locale
ENV DEBIAN_FRONTEND=noninteractive \
    LANG=ja_JP.UTF-8 \
    LANGUAGE=ja_JP:ja \
    LC_ALL=ja_JP.UTF-8

# locales のインストールと日本語ロケール生成
RUN apt update && \
    apt-get upgrade -y && \
    apt install -y locales && \
    locale-gen ja_JP.UTF-8 && \
    update-locale LANG=ja_JP.UTF-8

# install
RUN apt update &&\
    apt-get upgrade -y &&\
    apt install -y \
    curl \
    wget \
    tar \
    make \
    cmake \
    git \
    gcc \
    g++ \
    gcc-mingw-w64 \
    g++-mingw-w64 \
    sqlite3 \
    libsqlite3-dev

# Setup wxWidgets (mingw)
WORKDIR /opt
RUN git clone https://github.com/wxWidgets/wxWidgets.git &&\
    cd wxWidgets &&\
    git checkout v3.2.8 &&\
    mkdir build-mingw

WORKDIR /opt/wxWidgets/build-mingw
RUN git submodule update --init --recursive && \
    cd /opt/wxWidgets/build-mingw &&\
    ../configure \
    --prefix=/usr/x86_64-w64-mingw32 \
    --host=x86_64-w64-mingw32 \
    --with-msw \
    --disable-shared \
    --enable-unicode &&\
    make -j$(nproc) &&\
    make install

    # SQLite3 for MinGW
RUN cd /opt && \
    wget https://www.sqlite.org/2026/sqlite-autoconf-3510200.tar.gz && \
    tar xvf sqlite-autoconf-3510200.tar.gz && \
    cd sqlite-autoconf-3510200 && \
    # --host で MinGW を指定し、インストール先をクロスコンパイラの標準パスに設定
    ./configure --host=x86_64-w64-mingw32 --prefix=/usr/x86_64-w64-mingw32 --enable-static --disable-shared && \
    make -j$(nproc) && \
    make install