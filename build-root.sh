#!/bin/bash

set -e
set -x

# Timezone
ln -snf /usr/share/zoneinfo/$TZ /etc/localtime
echo $TZ > /etc/timezone

apt-get update
apt-get install -y sudo curl software-properties-common build-essential openssh-server cmake git

# Clear existing host keys
rm /etc/ssh/ssh_host_*

# `dev` user creation
useradd -m dev
usermod -aG sudo dev
passwd -d dev
sudo -u dev chsh -s /bin/bash
echo 'dev ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/dev

# Install Rust for `dev` user
sudo -u dev sh -c 'cd /home/dev && curl --proto "=https" --tlsv1.2 -sSf https://sh.rustup.rs -o rust.sh && sh rust.sh -y && rm rust.sh'

mkdir /var/run/sshd
