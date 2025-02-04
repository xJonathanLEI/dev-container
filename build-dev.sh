#!/bin/bash

set -e
set -x

echo 'export GPG_TTY=$(tty)' >> /home/dev/.bashrc
echo "export PATH=\"/usr/bin/:\$PATH\"" >> /home/dev/.bashrc
echo "alias git=\"TZ=Etc/GMT git\"" >> /home/dev/.bashrc

echo "export HELIX_RUNTIME=\"/var/lib/helix/runtime/\"" >> /home/dev/.bashrc
