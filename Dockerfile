FROM ubuntu:20.04

ENV TZ=Etc/GMT
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone && \
    apt-get update && \
    apt-get install -y sudo nano curl software-properties-common build-essential openssh-server libssl-dev unzip apt-transport-https ca-certificates ufw clang zlib1g-dev libkrb5-dev libtinfo5 bash-completion && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - && \
    curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add - && \
    add-apt-repository -y ppa:git-core/ppa && \
    add-apt-repository -y ppa:longsleep/golang-backports && \
    add-apt-repository -y "deb [arch=$(dpkg --print-architecture)] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" && \
    sudo apt-add-repository "deb [arch=$(dpkg --print-architecture)] https://apt.releases.hashicorp.com $(lsb_release -cs) main" && \
    apt-get update && \
    apt-get install -y git golang-go && \
    curl https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -o packages-microsoft-prod.deb && \
    dpkg -i packages-microsoft-prod.deb && \
    rm packages-microsoft-prod.deb && \
    apt-get update && \
    apt-get install -y dotnet-sdk-5.0 aspnetcore-runtime-3.1 && \
    curl -sL https://deb.nodesource.com/setup_14.x | bash && \
    apt-get install -y nodejs && \
    npm install -g yarn && \
    apt-get install -y docker-ce-cli && \
    apt-get install -y terraform && \
    apt-get install -y openjdk-8-jdk && \
    curl -L https://dl.google.com/android/repository/platform-tools-latest-linux.zip -o platform-tools.zip && \
    unzip platform-tools.zip -d /usr/local/ && \
    rm platform-tools.zip && \
    ln -s /usr/local/platform-tools/adb /usr/local/bin/adb && \
    rm /etc/ssh/ssh_host_*

RUN sed -i 's/required/sufficient/g' /etc/pam.d/chsh && \
    useradd -m dev && \
    usermod -aG sudo dev && \
    passwd -d dev && \
    sudo -u dev chsh -s /bin/bash && \
    echo 'dev ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/dev

RUN sudo -u dev sh -c 'cd /home/dev && curl --proto "=https" --tlsv1.2 -sSf https://sh.rustup.rs -o rust.sh && sh rust.sh -y && rm rust.sh' && \
    echo "export PATH=\"\$PATH:/home/dev/.cargo/bin\"" >> /home/dev/.bashrc

RUN mkdir /var/run/sshd && \
    sed -i 's/#PermitEmptyPasswords no/PermitEmptyPasswords yes/g' /etc/ssh/sshd_config && \
    sed -i 's/#X11UseLocalhost yes/X11UseLocalhost no/g' /etc/ssh/sshd_config && \
    sed -i 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' /etc/pam.d/sshd

USER dev

RUN echo "export PATH=\"\$PATH:$(yarn global bin)\"" >> /home/dev/.bashrc

COPY ./entry.sh /usr/local/bin/entry

ENTRYPOINT [ "entry" ]
