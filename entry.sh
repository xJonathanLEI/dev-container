#!/bin/bash

OPTION_SSH_PORT=22
OPTION_SSH_KEYS=
OPTION_SSH_HOST_DSA_KEY=
OPTION_SSH_HOST_ECDSA_KEY=
OPTION_SSH_HOST_ED25519_KEY=
OPTION_SSH_HOST_RSA_KEY=
OPTION_ADB_KEY=
OPTION_CODE_SERVER_PORT=8040
OPTION_CODE_SERVER_PASSWORD=
OPTION_STARTUP_COMMAND=

if [ -n "${SSH_PORT}" ]; then
    OPTION_SSH_PORT=${SSH_PORT}
fi

if [ -n "${SSH_KEYS}" ]; then
    OPTION_SSH_KEYS=${SSH_KEYS}
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

if [ -n "${CODE_SERVER_PORT}" ]; then
    OPTION_CODE_SERVER_PORT=${CODE_SERVER_PORT}
fi

if [ -n "${CODE_SERVER_PASSWORD}" ]; then
    OPTION_CODE_SERVER_PASSWORD=${CODE_SERVER_PASSWORD}
fi

if [ -n "${STARTUP_COMMAND}" ]; then
    OPTION_STARTUP_COMMAND=${STARTUP_COMMAND}
fi

sudo sed -i "s/#Port 22/Port ${OPTION_SSH_PORT}/g" /etc/ssh/sshd_config

if [ -n "${OPTION_SSH_KEYS}" ]; then
    mkdir -p ~/.ssh && truncate -s 0 ~/.ssh/authorized_keys
    IFS=',' read -ra ssh_keys <<< ${OPTION_SSH_KEYS}
    for key in "${ssh_keys[@]}"
    do
        echo "${key}" >> ~/.ssh/authorized_keys
    done
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
    mkdir -p ~/.android && echo ${OPTION_ADB_KEY} | base64 -d > ~/.android/adbkey
fi

if [ -n "${OPTION_STARTUP_COMMAND}" ]; then
    ${OPTION_STARTUP_COMMAND}
fi

sudo dockerd &

if [ -n "${OPTION_CODE_SERVER_PASSWORD}" ]; then
    PASSWORD="${OPTION_CODE_SERVER_PASSWORD}" code-server \
        --bind-addr 0.0.0.0:${CODE_SERVER_PORT} \
        --user-data-dir ${HOME}/.code-server/data \
        --extensions-dir ${HOME}/.code-server/extensions &
fi

exec sudo /usr/sbin/sshd -D
