FROM ubuntu:20.04

ENV TZ=Etc/GMT
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone && \
    apt-get update && \
    apt-get install -y sudo nano curl software-properties-common openssh-server && \
    add-apt-repository -y ppa:git-core/ppa && \
    apt-get update && \
    apt-get install -y git && \
    curl https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -o packages-microsoft-prod.deb && \
    dpkg -i packages-microsoft-prod.deb && \
    rm packages-microsoft-prod.deb && \
    apt-get update && \
    apt-get install -y apt-transport-https && \
    apt-get update && \
    apt-get install -y dotnet-sdk-3.1 && \
    curl -sL https://deb.nodesource.com/setup_14.x | bash && \
    apt-get install -y nodejs && \
    npm install -g yarn

RUN sed -i 's/required/sufficient/g' /etc/pam.d/chsh && \
    useradd -m dev && \
    usermod -aG sudo dev && \
    passwd -d dev && \
    sudo -u dev chsh -s /bin/bash && \
    echo 'dev ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/dev

RUN mkdir /var/run/sshd && \
    sed -i 's/#PermitEmptyPasswords no/PermitEmptyPasswords yes/g' /etc/ssh/sshd_config && \
    sed -i 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' /etc/pam.d/sshd

USER dev

COPY ./entry.sh /usr/local/bin/entry

ENTRYPOINT [ "entry" ]
