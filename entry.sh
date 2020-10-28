#!/bin/sh

OPTION_PORT=22

if [ -n "${PORT}" ]; then
    OPTION_PORT=${PORT}
fi

sudo sed -i "s/#Port 22/Port ${OPTION_PORT}/g" /etc/ssh/sshd_config

exec sudo /usr/sbin/sshd -D
