#!/bin/sh

OPTION_PORT=22
OPTION_ADB_KEY=

if [ -n "${PORT}" ]; then
    OPTION_PORT=${PORT}
fi

if [ -n "${ADB_KEY}" ]; then
    OPTION_ADB_KEY=${ADB_KEY}
fi

sudo sed -i "s/#Port 22/Port ${OPTION_PORT}/g" /etc/ssh/sshd_config

if [ -n "${OPTION_ADB_KEY}" ]; then
    mkdir ~/.android && echo ${OPTION_ADB_KEY} | base64 -d > ~/.android/adbkey
fi

exec sudo /usr/sbin/sshd -D
