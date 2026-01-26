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
    unzip \
    gzip \
    wget \
    git \
    tar \
    locales \
    tree \
    # FORTRAN
    gfortran \
    # For Python
    python3 \
    python3-pip \
    pipx \
    # for clang-formatter
    python3.12-venv \
    npm \
    # Python lib
    # python3-sympy \
    # for C++
    gcc \
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
    wget https://github.com/neovim/neovim/releases/download/v0.11.3/nvim-linux-x86_64.tar.gz && \
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

# Setup wxWidgets (mingw)
RUN apt install mingw-w64 -y &&\
    cd /opt &&\
    git clone https://github.com/wxWidgets/wxWidgets.git &&\
    cd wxWidgets &&\
    mkdir build-mingw &&\
    cd build-mingw &&\
    cd /opt/wxWidgets &&\
    git submodule update --init --recursive && \
    cd /opt/wxWidgets/build-mingw &&\
    ../configure --host=x86_64-w64-mingw32 --with-msw --disable-shared &&\
    cd /opt/wxWidgets/build-mingw &&\
    make -j$(nproc) && \
    #make install は、Linux 版 wxWidgets と干渉する可能性があるため、実行していない

