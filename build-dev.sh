#!/bin/bash

set -e
set -x

echo "export PATH=\"\$PATH:$(yarn global bin)\"" >> /home/dev/.bashrc
echo 'export GPG_TTY=$(tty)' >> /home/dev/.bashrc
echo "export PATH=\"\$PATH:/home/dev/.local/bin\"" >> /home/dev/.bashrc
echo "alias git=\"TZ=Etc/GMT git\"" >> /home/dev/.bashrc

echo "export HELIX_RUNTIME=\"/var/lib/helix/runtime/\"" >> /home/dev/.bashrc
