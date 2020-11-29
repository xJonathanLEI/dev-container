#!/bin/sh

OPTION_SSH_PORT=22
OPTION_SSH_KEY=
OPTION_SSH_HOST_DSA_KEY=
OPTION_SSH_HOST_ECDSA_KEY=
OPTION_SSH_HOST_ED25519_KEY=
OPTION_SSH_HOST_RSA_KEY=
OPTION_ADB_KEY=

if [ -n "${SSH_PORT}" ]; then
    OPTION_SSH_PORT=${SSH_PORT}
fi

if [ -n "${SSH_KEY}" ]; then
    OPTION_SSH_KEY=${SSH_KEY}
fi

if [ -n "${SSH_HOST_DSA_KEY}" ]; then
    OPTION_SSH_HOST_DSA_KEY=${SSH_HOST_DSA_KEY}
fi

if [ -n "${SSH_HOST_ECDSA_KEY}" ]; then
    OPTION_SSH_HOST_ECDSA_KEY=${SSH_HOST_ECDSA_KEY}
fi

if [ -n "${SSH_HOST_ED25519_KEY}" ]; then
    OPTION_SSH_HOST_ED25519_KEY=${SSH_HOST_ED25519_KEY}
fi

if [ -n "${SSH_HOST_RSA_KEY}" ]; then
    OPTION_SSH_HOST_RSA_KEY=${SSH_HOST_RSA_KEY}
fi

if [ -n "${ADB_KEY}" ]; then
    OPTION_ADB_KEY=${ADB_KEY}
fi

sudo sed -i "s/#Port 22/Port ${OPTION_SSH_PORT}/g" /etc/ssh/sshd_config

if [ -n "${OPTION_SSH_KEY}" ]; then
    mkdir ~/.ssh
    echo "${OPTION_SSH_KEY}" > ~/.ssh/authorized_keys
    sudo sed -i "s/#PasswordAuthentication yes/PasswordAuthentication no/g" /etc/ssh/sshd_config
fi

if [ -n "${OPTION_SSH_HOST_DSA_KEY}" ]; then
    sudo sh -c "echo \"${OPTION_SSH_HOST_DSA_KEY}\" | base64 -d > /etc/ssh/ssh_host_dsa_key"
    sudo chmod 600 /etc/ssh/ssh_host_dsa_key
    sudo sh -c "ssh-keygen -y -f /etc/ssh/ssh_host_dsa_key > /etc/ssh/ssh_host_dsa_key.pub"
fi

if [ -n "${OPTION_SSH_HOST_ECDSA_KEY}" ]; then
    sudo sh -c "echo \"${OPTION_SSH_HOST_ECDSA_KEY}\" | base64 -d > /etc/ssh/ssh_host_ecdsa_key"
    sudo chmod 600 /etc/ssh/ssh_host_ecdsa_key
    sudo sh -c "ssh-keygen -y -f /etc/ssh/ssh_host_ecdsa_key > /etc/ssh/ssh_host_ecdsa_key.pub"
fi

if [ -n "${OPTION_SSH_HOST_ED25519_KEY}" ]; then
    sudo sh -c "echo \"${OPTION_SSH_HOST_ED25519_KEY}\" | base64 -d > /etc/ssh/ssh_host_ed25519_key"
    sudo chmod 600 /etc/ssh/ssh_host_ed25519_key
    sudo sh -c "ssh-keygen -y -f /etc/ssh/ssh_host_ed25519_key > /etc/ssh/ssh_host_ed25519_key.pub"
fi

if [ -n "${OPTION_SSH_HOST_RSA_KEY}" ]; then
    sudo sh -c "echo \"${OPTION_SSH_HOST_RSA_KEY}\" | base64 -d > /etc/ssh/ssh_host_rsa_key"
    sudo chmod 600 /etc/ssh/ssh_host_rsa_key
    sudo sh -c "ssh-keygen -y -f /etc/ssh/ssh_host_rsa_key > /etc/ssh/ssh_host_rsa_key.pub"
fi

sudo ssh-keygen -A

if [ -n "${OPTION_ADB_KEY}" ]; then
    mkdir ~/.android && echo ${OPTION_ADB_KEY} | base64 -d > ~/.android/adbkey
fi

exec sudo /usr/sbin/sshd -D
