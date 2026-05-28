FROM ubuntu:26.04

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
    unzip \
    gzip \
    wget \
    git \
    tar \
    locales \
    tree \
    gettext \
    # FORTRAN
    gfortran \
    # For Python
    python3 \
    python3-pip \
    pipx \
    # for clang-formatter
    python3-venv \
    npm \
    # Python lib
    # python3-sympy \
    # for C++
    gcc \
    gcc-mingw-w64 \
    g++-mingw-w64 \
    cmake \
    clang \
    clangd \
    clang-format \
    clang-tidy \
    # wxWidgets Cross-platform C++ GUI toolkit
    # Run "apt-cache search libwxgt*" to get the following information.
    # 開発するときは，"wx-config --cxxflags" を実行し，出力内容を"compile_flags.txt"に保存する．
    # 保存先は，プロジェクトルートディレクトリ
    libwxgtk-gl3.2-1t64 \
    libwxgtk-media3.2-1t64 \
    libwxgtk-media3.2-dev \
    libwxgtk-webview3.2-1t64 \
    libwxgtk-webview3.2-dev \
    libwxgtk3.2-1t64 \
    libwxgtk3.2-dev \
    # Add SQLite3 (Linux)
    sqlite3 \
    libsqlite3-dev \
    # SOCI
    libsoci-dev \
    pkg-config \
    # Japanese fonts for matplotlib
    fonts-ipafont-gothic && \
    apt-get clean

# python3 = python
RUN ln -s $(which python3) /usr/local/bin/python

# setup pyenv and poetry 
RUN curl https://pyenv.run | bash
ENV PATH="/root/.pyenv/bin:$PATH"
RUN curl -sSL https://install.python-poetry.org | python3 -
ENV PATH="/root/.local/bin:$PATH"
# 
RUN poetry config virtualenvs.in-project false
RUN poetry config virtualenvs.path /root/.venv

# Setup for wxPython
RUN apt-get install -y build-essential libgtk-3-dev

# coc-nvim Dockerfile
RUN npm install -g dockerfile-language-server-nodejs && \
    # coc-nvim Docker Compose
    npm install -g @microsoft/compose-language-service && \
    # resolve the nvim-treesitter's error
    # 0.26 系統は，nvim-treesitter の latex において --no-bindings が使えないため，エラーとなる．従って，--no-bindings が利用できる 0.25.10 を選択し，エラーを防止する．
    npm install -g tree-sitter-cli@0.25.10

# Install RUST
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y 
    
# For Lazyvim
RUN apt update && \
    apt-get upgrade -y &&\
    apt install -y \
    fzf \
    ripgrep \
    fd-find && \
    apt-get clean

# Build Neovim
RUN apt update && \
    apt-get upgrade -y && \
    apt install -y \
    ninja-build \
    gettext \
    build-essential 

# Install Neovim
RUN apt update && \
    apt-get upgrade -y &&\
    wget https://github.com/neovim/neovim/releases/download/v0.12.2/nvim-linux-x86_64.tar.gz && \
    tar -zxvf nvim-linux-x86_64.tar.gz && \
    mv nvim-linux-x86_64/bin/nvim /usr/bin/nvim && \
    mv nvim-linux-x86_64/lib/nvim /usr/lib/nvim && \
    mv nvim-linux-x86_64/share/nvim/ /usr/share/nvim && \
    rm -rf nvim-linux-x86_64 && \
    rm nvim-linux-x86_64.tar.gz
# install Lazygit https://qiita.com/hkuno/items/b3c8396b1463d65f23b9

# Install nodejs https://github.com/neoclide/coc.nvim?tab=readme-ov-file#quick-start

# Install Node.js (LTS)
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - \
    && apt-get install -y nodejs \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# fd cmd link 
RUN ln -s $(which fdfind) /usr/local/bin/

# Copy Settings File
COPY /dotfiles /root/dotfiles
RUN cp -r /root/dotfiles/config/. ~/.config/

# Install TeXlive
RUN apt update && \
    apt-get upgrade -y && \
    apt install -y \
    texlive-full

# wxWidgets (mingw)
WORKDIR /opt
RUN git clone https://github.com/wxWidgets/wxWidgets.git &&\
    cd wxWidgets &&\
    git checkout v3.2.10 &&\
    git submodule update --init --recursive

RUN mkdir -p /opt/wxWidgets/build-release
WORKDIR /opt/wxWidgets/build-release
RUN ../configure \
    --prefix=/usr/x86_64-w64-mingw32/release \
    --host=x86_64-w64-mingw32 \
    --with-msw \
    --disable-shared \
    --enable-unicode \
    --disable-debug \
    --enable-optimise \
    && make -j$(nproc) && make install

WORKDIR /opt

RUN git clone https://github.com/opencv/opencv.git -b 4.12.0 --depth 1

RUN git clone https://github.com/opencv/opencv_contrib.git -b 4.12.0 --depth 1

# Build
RUN mkdir -p /opt/opencv/build-linux
WORKDIR /opt/opencv/build-linux
RUN cmake .. \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=/usr/local \
    -DBUILD_SHARED_LIBS=OFF \
    -DBUILD_PERF_TESTS=OFF  \
    -DBUILD_TESTS=OFF \
    -DWITH_ADE=OFF \
    -DWITH_OPENJPEG=OFF \
    -DWITH_WEBP=OFF \
    -DWITH_TIFF=OFF \
    -DWITH_QUIRC=OFF \
    -DWITH_OPENEXR=OFF \
    -DWITH_JPEG=OFF \
    -DWITH_LAPACK=OFF \
    -DWITH_JASPER=OFF \
    -DWITH_PNG=OFF \
    -DWITH_GSTREAMER=OFF \
    -DWITH_FFMPEG=OFF \
    -DWITH_EIGEN=OFF \
    -DWITH_DSHOW=OFF \
    -DWITH_DIRECTX=OFF \
    -DWITH_ARITH_DEC=OFF \
    -DWITH_ARITH_ENC=OFF \
    -DWITH_1394=OFF \
    -DWITH_IMGCODEC_HDR=OFF \
    -DWITH_IMGCODEC_PFM=OFF \
    -DWITH_IMGCODEC_PXM=OFF \
    -DWITH_IMGCODEC_SUNRASTER=OFF \
    -DBUILD_OPENJPEG=OFF \
    -DBUILD_JASPER=OFF \
    -DBUILD_JAVA=OFF \
    -DBUILD_JPEG=OFF \
    -DBUILD_OPENEXR=OFF \
    -DBUILD_PNG=OFF \
    -DBUILD_TBB=OFF \
    -DBUILD_opencv_python3=OFF \
    -DOPENCV_EXTRA_MODULES_PATH=/opt/opencv_contrib/modules \
    && make -j$(nproc) \
    && make install

RUN apt update && apt install -y gdb-multiarch && apt-get clean

# Install dotnet
# https://learn.microsoft.com/ja-jp/dotnet/core/install/linux-ubuntu-install?tabs=dotnet10&pivots=os-linux-ubuntu-2604
RUN apt-get install -y dotnet-sdk-10.0
RUN apt-get install -y aspnetcore-runtime-10.0

RUN nvim --headless -c "CocInstall -sync @tcx4c70/coc-csharp" -c "qa!"