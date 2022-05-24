FROM rust:buster AS file-locker

WORKDIR /src

RUN git clone --depth 1 -b v0.1.1 https://github.com/xJonathanLEI/file-locker

RUN cd file-locker && \
    cargo build --release

FROM ubuntu:20.04

ARG TZ="Etc/GMT"
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone && \
    apt-get update && \
    apt-get install -y sudo nano vim tmux curl software-properties-common build-essential openssh-server libssl-dev libudev-dev unzip apt-transport-https ca-certificates ufw clang zlib1g-dev libkrb5-dev libtinfo5 bash-completion jq autossh screen uuid-runtime dnsutils python3 python3-pip python3-dev libgmp3-dev && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - && \
    curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add - && \
    add-apt-repository -y ppa:git-core/ppa && \
    add-apt-repository -y ppa:longsleep/golang-backports && \
    add-apt-repository -y ppa:jonathonf/vim && \
    add-apt-repository -y "deb [arch=$(dpkg --print-architecture)] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" && \
    sudo apt-add-repository "deb [arch=$(dpkg --print-architecture)] https://apt.releases.hashicorp.com $(lsb_release -cs) main" && \
    apt-get update && \
    apt-get install -y git golang-go vim && \
    curl -sL https://deb.nodesource.com/setup_14.x | bash && \
    apt-get install -y nodejs && \
    npm install -g yarn && \
    apt-get install -y docker-ce docker-ce-cli containerd.io && \
    apt-get install -y openjdk-8-jdk && \
    curl -L https://dl.google.com/android/repository/platform-tools-latest-linux.zip -o platform-tools.zip && \
    unzip platform-tools.zip -d /usr/local/ && \
    rm platform-tools.zip && \
    ln -s /usr/local/platform-tools/adb /usr/local/bin/adb && \
    rm /etc/ssh/ssh_host_* && \
    curl -L "https://github.com/docker/compose/releases/download/1.28.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose && \
    curl -fsSL https://code-server.dev/install.sh | sh && \
    pip3 install ecdsa fastecdsa sympy && \
    pip3 install cairo-lang && \
    pip3 install black && \
    yarn global add prettier && \
    curl -o /tmp/nvim.tar.gz -L https://github.com/neovim/neovim/releases/download/v0.7.0/nvim-linux64.tar.gz && \
    tar zxvf /tmp/nvim.tar.gz --directory /usr --strip-components=1 && \
    rm /tmp/nvim.tar.gz && \
    apt-get install x11-xkb-utils && \
    curl -o /tmp/tigervnc.tar.gz -L https://sourceforge.net/projects/tigervnc/files/stable/1.12.0/tigervnc-1.12.0.x86_64.tar.gz/download && \
    tar zxvf /tmp/tigervnc.tar.gz --directory / --strip-components=1 && \
    rm /tmp/tigervnc.tar.gz

RUN mkdir /usr/lib/android-sdk/ && \
    cd /usr/lib/android-sdk/ && \
    curl -L https://dl.google.com/android/repository/commandlinetools-linux-7583922_latest.zip -o /tmp/commandlinetools.zip && \
    unzip /tmp/commandlinetools.zip && \
    rm /tmp/commandlinetools.zip && \
    yes | sudo /usr/lib/android-sdk/cmdline-tools/bin/sdkmanager --sdk_root=/usr/lib/android-sdk --install "build-tools;31.0.0"

COPY --from=file-locker /src/file-locker/target/release/file-locker /usr/local/bin/file-locker

RUN sed -i 's/required/sufficient/g' /etc/pam.d/chsh && \
    useradd -m dev && \
    usermod -aG sudo dev && \
    passwd -d dev && \
    sudo -u dev chsh -s /bin/bash && \
    echo 'dev ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/dev

RUN sudo -u dev sh -c 'cd /home/dev && curl --proto "=https" --tlsv1.2 -sSf https://sh.rustup.rs -o rust.sh && sh rust.sh -y && rm rust.sh' && \
    echo "export PATH=\"\$PATH:/home/dev/.cargo/bin\"" >> /home/dev/.bashrc && \
    sudo -u dev sh -c '/home/dev/.cargo/bin/rustup toolchain install nightly' && \
    sudo -u dev sh -c '/home/dev/.cargo/bin/cargo install --locked ripgrep'

RUN mkdir /var/run/sshd && \
    sed -i 's/#PermitEmptyPasswords no/PermitEmptyPasswords yes/g' /etc/ssh/sshd_config && \
    sed -i 's/#X11UseLocalhost yes/X11UseLocalhost no/g' /etc/ssh/sshd_config && \
    sed -i 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' /etc/pam.d/sshd

USER dev

RUN echo "export PATH=\"\$PATH:$(yarn global bin)\"" >> /home/dev/.bashrc && \
    echo 'export GPG_TTY=$(tty)' >> /home/dev/.bashrc && \
    echo "export PATH=\"\$PATH:/home/dev/.local/bin\"" >> /home/dev/.bashrc && \
    echo "alias git=\"TZ=Etc/GMT git\"" >> /home/dev/.bashrc

COPY ./entry.sh /usr/local/bin/entry

ENTRYPOINT [ "entry" ]
